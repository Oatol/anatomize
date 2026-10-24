package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Camera extends Trigger
   {
      
      public function Camera()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         GameState.followBody = param1;
         param2.triggered = false;
      }
   }
}

