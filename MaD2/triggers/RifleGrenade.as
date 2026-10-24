package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class RifleGrenade extends BarrelAttachment
   {
      
      private var origVol:Array;
      
      private var origSounds:Array;
      
      private var origBullet:String;
      
      private var origBullets:Number;
      
      private var origDisable:Boolean;
      
      public function RifleGrenade()
      {
         super();
         rayFrom = new b2Vec2(24 / Physics.scale,0);
         rayTo = new b2Vec2(32 / Physics.scale,0);
         rayRange = 6;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         if(param2.triggerState == 0)
         {
            super.trigger(param1,param2);
         }
         else if(Boolean(attachedBody) && userData(attachedBody.GetUserData()).triggered)
         {
            param2.dead = true;
         }
      }
      
      override protected function Attach(param1:b2Body) : void
      {
         super.Attach(param1);
         this.origSounds = Gun(userData(param1.GetUserData()).trigger).firearm.soundNames.slice();
         this.origVol = Gun(userData(param1.GetUserData()).trigger).firearm.soundVolumes.slice();
         this.origBullets = Gun(userData(param1.GetUserData()).trigger).firearm.bulletAmount;
         this.origDisable = Gun(userData(param1.GetUserData()).trigger).firearm.disableAfterFiring;
         Gun(userData(param1.GetUserData()).trigger).firearm.disableAfterFiring = false;
         Gun(userData(param1.GetUserData()).trigger).firearm.clearSounds();
         Gun(userData(param1.GetUserData()).trigger).firearm.attachSound("thumper_shoot",0.75);
         this.origBullet = Gun(userData(param1.GetUserData()).trigger).firearm.bulletType;
         Gun(userData(param1.GetUserData()).trigger).firearm.bulletType = "riflegrenade";
         Gun(userData(param1.GetUserData()).trigger).firearm.bulletAmount = 1;
         ud.triggered = true;
         ud.triggerLock = true;
         ud.triggerState = 1;
      }
      
      override protected function Detach() : void
      {
         var _loc1_:int = 0;
         ud.triggerLock = false;
         ud.triggerState = 0;
         if(!(userData(attachedBody.GetUserData()).trigger is Gun))
         {
            return;
         }
         super.Detach();
         if(attachedBody)
         {
            Gun(userData(attachedBody.GetUserData()).trigger).firearm.clearSounds();
            Gun(userData(attachedBody.GetUserData()).trigger).firearm.disableAfterFiring = this.origDisable;
            _loc1_ = 0;
            while(_loc1_ < this.origSounds.length)
            {
               Gun(userData(attachedBody.GetUserData()).trigger).firearm.attachSound(this.origSounds[_loc1_],this.origVol[_loc1_]);
               _loc1_++;
            }
            Gun(userData(attachedBody.GetUserData()).trigger).firearm.bulletType = this.origBullet;
            Gun(userData(attachedBody.GetUserData()).trigger).firearm.bulletAmount = this.origBullets;
         }
      }
   }
}

