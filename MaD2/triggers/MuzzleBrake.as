package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class MuzzleBrake extends BarrelAttachment
   {
      
      private var origRecoil:Number;
      
      public function MuzzleBrake()
      {
         super();
         rayFrom = new b2Vec2(10 / Physics.scale,0);
         rayTo = new b2Vec2(15 / Physics.scale,0);
         rayRange = 6;
      }
      
      override protected function Attach(param1:b2Body) : void
      {
         super.Attach(param1);
         this.origRecoil = Gun(userData(param1.GetUserData()).trigger).firearm.recoil;
         Gun(userData(param1.GetUserData()).trigger).firearm.recoil = Gun(userData(param1.GetUserData()).trigger).firearm.recoil * (ud.triggerForce * 0.01);
      }
      
      override protected function Detach() : void
      {
         if(!(userData(attachedBody.GetUserData()).trigger is Gun))
         {
            return;
         }
         super.Detach();
         if(attachedBody)
         {
            Gun(userData(attachedBody.GetUserData()).trigger).firearm.recoil = this.origRecoil;
         }
      }
   }
}

