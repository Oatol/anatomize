package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class BlockBarrelAttachment extends BarrelAttachment
   {
      
      private var origVol:Array;
      
      private var origSounds:Array;
      
      private var origBullet:String;
      
      private var origBullets:Number;
      
      private var origDisable:Boolean;
      
      private var origSize:Number;
      
      internal var customs:Object;
      
      public function BlockBarrelAttachment()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         rayFrom = new b2Vec2(24 / Physics.scale,0);
         rayTo = new b2Vec2(32 / Physics.scale,0);
         rayRange = 6;
         barrelX = 40;
         this.customs = param2.ParseTriggerCustom();
         var _loc3_:String = this.customs["barrelOffset"];
         var _loc4_:String = this.customs["attachOffset"];
         var _loc5_:String = this.customs["attachStart"];
         var _loc6_:String = this.customs["attachEnd"];
         if(GeneralUtils.isStringVector(_loc3_))
         {
            barrelX = GeneralUtils.toVec(_loc3_).x;
            barrelY = GeneralUtils.toVec(_loc3_).y;
         }
         else if(_loc3_)
         {
            barrelX = Number(_loc3_);
         }
         if(GeneralUtils.isStringVector(_loc4_))
         {
            attachX = GeneralUtils.toVec(_loc4_).x;
            attachY = GeneralUtils.toVec(_loc4_).y;
         }
         else if(_loc4_)
         {
            attachX = Number(_loc4_);
         }
         if(!GeneralUtils.isStringVector(_loc5_))
         {
            return;
         }
         if(!GeneralUtils.isStringVector(_loc6_))
         {
            return;
         }
         rayFrom = GeneralUtils.toVec(_loc5_);
         rayTo = GeneralUtils.toVec(_loc6_);
         rayRange = Math.sqrt(BoxUtils.vectorDist(rayFrom,rayTo));
         rayFrom.Multiply(1 / Physics.scale);
         rayTo.Multiply(1 / Physics.scale);
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
         this.origSize = Gun(userData(param1.GetUserData()).trigger).firearm.bulletSize;
         Gun(userData(param1.GetUserData()).trigger).firearm.disableAfterFiring = false;
         var _loc2_:Array = ["thumper_shoot"];
         var _loc3_:Array = [0.75];
         var _loc4_:String = "riflegrenade";
         var _loc5_:Number = 1;
         var _loc6_:Number = 1;
         if(this.customs["sounds"])
         {
            _loc2_ = this.customs["sounds"].split(",");
         }
         if(this.customs["volumes"])
         {
            _loc3_ = this.customs["volumes"].split(",");
         }
         if(this.customs["projectile"])
         {
            _loc4_ = this.customs["projectile"];
         }
         if(this.customs["amount"])
         {
            _loc6_ = Number(this.customs["amount"]);
         }
         if(this.customs["size"])
         {
            _loc5_ = Number(this.customs["size"]);
         }
         Gun(userData(param1.GetUserData()).trigger).firearm.clearSounds();
         Gun(userData(param1.GetUserData()).trigger).firearm.attachSounds(_loc2_,_loc3_);
         this.origBullet = Gun(userData(param1.GetUserData()).trigger).firearm.bulletType;
         Gun(userData(param1.GetUserData()).trigger).firearm.bulletType = _loc4_;
         Gun(userData(param1.GetUserData()).trigger).firearm.bulletAmount = _loc6_;
         Gun(userData(param1.GetUserData()).trigger).firearm.bulletSize = _loc5_;
         ud.triggered = true;
         ud.triggerLock = true;
         ud.triggerState = 1;
      }
      
      override protected function Detach() : void
      {
         var _loc1_:int = 0;
         ud.triggerLock = false;
         ud.triggerState = 0;
         if(!attachedBody || !(userData(attachedBody.GetUserData()).trigger is Gun))
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
            Gun(userData(attachedBody.GetUserData()).trigger).firearm.bulletSize = this.origSize;
         }
      }
   }
}

