package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class GhostLever extends Trigger
   {
      
      public function GhostLever()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc6_:userData = null;
         super.trigger(param1,param2);
         param2.graphic.scaleY *= -1;
         param2.triggered = false;
         if(param2.connected.length == 0)
         {
            return;
         }
         var _loc3_:int = int(param2.connected.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = param2.connected[_loc5_];
            if(_loc4_)
            {
               _loc6_ = userData(_loc4_.GetUserData());
               _loc6_.ghost = param2.triggerForce > 0;
            }
            _loc5_++;
         }
      }
   }
}

