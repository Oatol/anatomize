package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class HeavyBarrel extends BarrelAttachment
   {
      
      private var origSize:Number;
      
      public function HeavyBarrel()
      {
         super();
         barrelX = 60;
         rayFrom = new b2Vec2(20 / Physics.scale,0);
         rayTo = new b2Vec2(25 / Physics.scale,0);
         rayRange = 6;
      }
      
      override protected function Attach(param1:b2Body) : void
      {
         super.Attach(param1);
         this.origSize = Gun(userData(param1.GetUserData()).trigger).firearm.bulletSize;
         var _loc2_:Number = 1 + ud.triggerForce * 0.01;
         if(_loc2_ < 1)
         {
            _loc2_ = 1;
         }
         if(_loc2_ > 2)
         {
            _loc2_ = 2;
         }
         Gun(userData(param1.GetUserData()).trigger).firearm.bulletSize = Gun(userData(param1.GetUserData()).trigger).firearm.bulletSize * _loc2_;
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
            Gun(userData(attachedBody.GetUserData()).trigger).firearm.bulletSize = this.origSize;
         }
      }
   }
}

