package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Oven extends HotPlate
   {
      
      public function Oven()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         super.trigger(param1,param2);
         if(triggerDuration > 0)
         {
            ud.triggerDuration -= TimeLord.speed;
            return;
         }
         var _loc3_:Array = Body.GetAround(body,30 * ud.size,30 * ud.size);
         if(_loc3_.length == 0)
         {
            ud.triggerDuration = 60;
         }
         for each(_loc4_ in _loc3_)
         {
            userData(_loc4_.GetUserData()).temperature = userData(_loc4_.GetUserData()).temperature + 2;
         }
      }
   }
}

