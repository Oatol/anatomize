package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class MapCarving extends Trigger
   {
      
      public function MapCarving()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         Main.instance.changeEnvironment("openworld");
      }
   }
}

