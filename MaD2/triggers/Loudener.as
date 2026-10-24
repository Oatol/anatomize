package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Loudener extends BarrelAttachment
   {
      
      private var origVol:Array;
      
      private var origSounds:Array;
      
      public function Loudener()
      {
         super();
         rayFrom = new b2Vec2(15 / Physics.scale,0);
         rayTo = new b2Vec2(20 / Physics.scale,0);
         rayRange = 6;
      }
      
      override protected function Attach(param1:b2Body) : void
      {
         super.Attach(param1);
         this.origSounds = Gun(userData(param1.GetUserData()).trigger).firearm.soundNames.slice();
         this.origVol = Gun(userData(param1.GetUserData()).trigger).firearm.soundVolumes.slice();
         Gun(userData(param1.GetUserData()).trigger).firearm.clearSounds();
         Gun(userData(param1.GetUserData()).trigger).firearm.attachSound("explosion4",0.75);
      }
      
      override protected function Detach() : void
      {
         var _loc1_:int = 0;
         if(!(userData(attachedBody.GetUserData()).trigger is Gun))
         {
            return;
         }
         super.Detach();
         if(attachedBody)
         {
            Gun(userData(attachedBody.GetUserData()).trigger).firearm.clearSounds();
            _loc1_ = 0;
            while(_loc1_ < this.origSounds.length)
            {
               Gun(userData(attachedBody.GetUserData()).trigger).firearm.attachSound(this.origSounds[_loc1_],this.origVol[_loc1_]);
               _loc1_++;
            }
         }
      }
   }
}

