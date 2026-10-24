package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class GhostPotion extends Trigger
   {
      
      public function GhostPotion()
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
            Body.Ghost(_loc4_);
         }
         param2.dead = true;
         Body.Disintegrate(param1,"ghost",25,5,5);
      }
   }
}

