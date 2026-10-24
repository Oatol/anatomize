package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class StopSign extends Trigger
   {
      
      public function StopSign()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Body = null;
         super.trigger(param1,param2);
         for each(_loc3_ in param2.connected)
         {
            _loc3_.SetLinearVelocity(new b2Vec2(0,-GameState.environment.gravity * 0.02));
            _loc3_.SetAngularVelocity(0);
         }
      }
   }
}

