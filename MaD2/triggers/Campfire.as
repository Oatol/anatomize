package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Campfire extends Trigger
   {
      
      public function Campfire()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Array = null;
         var _loc4_:b2Body = null;
         var _loc5_:userData = null;
         super.trigger(param1,param2);
         if(param2.temperature < param2.triggerForce)
         {
            param2.temperature += 2;
         }
         else
         {
            _loc3_ = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = userData(_loc4_.GetUserData());
               if(_loc5_.temperature < 40)
               {
                  if(_loc5_.temperature < 0)
                  {
                     _loc5_.temperature += 0.5;
                  }
                  else
                  {
                     _loc5_.temperature += 0.2;
                  }
               }
            }
         }
      }
   }
}

