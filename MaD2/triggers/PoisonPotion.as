package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class PoisonPotion extends Trigger
   {
      
      public function PoisonPotion()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:Vector.<b2Body> = null;
         var _loc6_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size);
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.GetUserData().alive)
            {
               userData(_loc4_.GetUserData()).trigger = new Poisoned();
               userData(_loc4_.GetUserData()).triggered = true;
               userData(_loc4_.GetUserData()).triggerDuration = 120 + Math.random() * 120;
            }
         }
         _loc5_ = Body.Decompose(param1);
         for each(_loc6_ in _loc5_)
         {
            if(userData(_loc6_.GetUserData()).name == "266826")
            {
               Body.Disintegrate(_loc6_,"poison",20,30,30);
            }
         }
      }
   }
}

