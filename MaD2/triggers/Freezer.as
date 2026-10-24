package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Freezer extends Trigger
   {
      
      public function Freezer()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Array = null;
         var _loc4_:b2Body = null;
         var _loc5_:userData = null;
         super.trigger(param1,param2);
         if(param2.temperature > 10)
         {
            --param2.temperature;
         }
         else
         {
            _loc3_ = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_ != param1)
               {
                  _loc5_ = userData(_loc4_.GetUserData());
                  if(_loc5_.temperature > -5)
                  {
                     _loc5_.temperature -= 0.5;
                  }
               }
            }
         }
      }
   }
}

