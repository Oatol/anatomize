package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class RandomEffectInRadius extends Trigger
   {
      
      public function RandomEffectInRadius()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius,param2.triggerRadius);
         for each(_loc4_ in _loc3_)
         {
            if(param2.ignored.indexOf(_loc4_) == -1)
            {
               Body.RandomEffect(_loc4_);
               param2.ignored.push(_loc4_);
            }
         }
      }
   }
}

