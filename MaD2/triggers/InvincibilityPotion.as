package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class InvincibilityPotion extends Trigger
   {
      
      public function InvincibilityPotion()
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
            userData(_loc4_.GetUserData()).trigger = new Invincible();
            userData(_loc4_.GetUserData()).triggered = true;
            userData(_loc4_.GetUserData()).triggerDuration = triggerDuration;
            userData(_loc4_.GetUserData()).triggerLock = true;
         }
         param2.dead = true;
         Body.Disintegrate(param1,"supershiny",50,12,12);
      }
   }
}

