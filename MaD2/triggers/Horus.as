package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Horus extends Trigger
   {
      
      public function Horus()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius,param2.triggerRadius,false);
         for each(_loc4_ in _loc3_)
         {
            if(!userData(_loc4_.GetUserData()).animated)
            {
               Body.Animate(_loc4_);
            }
         }
      }
   }
}

