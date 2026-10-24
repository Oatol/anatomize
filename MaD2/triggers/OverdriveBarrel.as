package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class OverdriveBarrel extends BarrelAttachment
   {
      
      private var orig:Number;
      
      public function OverdriveBarrel()
      {
         super();
         barrelX = 30;
         rayFrom = new b2Vec2(20 / Physics.scale,0);
         rayTo = new b2Vec2(25 / Physics.scale,0);
         rayRange = 6;
      }
      
      override protected function Attach(param1:b2Body) : void
      {
         super.Attach(param1);
         this.orig = Gun(userData(param1.GetUserData()).trigger).firearm.shootForce;
         var _loc2_:Number = 1 + ud.triggerForce * 0.01;
         if(_loc2_ < 1)
         {
            _loc2_ = 1;
         }
         if(_loc2_ > 2)
         {
            _loc2_ = 2;
         }
         Gun(userData(param1.GetUserData()).trigger).firearm.shootForce = Gun(userData(param1.GetUserData()).trigger).firearm.shootForce * _loc2_;
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
            Gun(userData(attachedBody.GetUserData()).trigger).firearm.shootForce = this.orig;
         }
      }
   }
}

