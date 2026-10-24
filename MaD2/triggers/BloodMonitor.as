package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class BloodMonitor extends Trigger
   {
      
      public function BloodMonitor()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:userData = null;
         var _loc6_:b2Body = null;
         super.trigger(param1,param2);
         if(param2.connected.length == 0)
         {
            return;
         }
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         for each(_loc6_ in param2.connected)
         {
            _loc3_ = userData(_loc6_.GetUserData());
            if(_loc3_.alive)
            {
               _loc4_ += _loc3_.health;
               _loc5_ += _loc3_.maxhealth;
            }
         }
         if(_loc4_ < 0.1 * _loc5_)
         {
            _loc4_ = 0;
         }
         param2.health = _loc4_;
         param2.maxhealth = _loc5_;
         BoxUtils.drawHealthBar(param1);
      }
   }
}

