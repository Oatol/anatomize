package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class InvisibilityPotion extends Trigger
   {
      
      public function InvisibilityPotion()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size);
         for each(_loc4_ in _loc3_)
         {
            if(!userData(_loc4_.GetUserData()).invisible)
            {
               if(userData(_loc4_.GetUserData()).graphic)
               {
                  userData(_loc4_.GetUserData()).trigger = new Invis();
                  userData(_loc4_.GetUserData()).triggered = true;
                  userData(_loc4_.GetUserData()).triggerDuration = triggerDuration;
                  userData(_loc4_.GetUserData()).triggerLock = true;
               }
            }
         }
         Body.Disintegrate(param1,"void",50,10,10);
      }
   }
}

