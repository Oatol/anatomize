package powers
{
   import Box2D.Dynamics.b2Body;
   
   public class PowerDrone extends Power
   {
      
      public function PowerDrone()
      {
         super(Tool.DRONE,"drone","droner");
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         Body.Drone(param1);
      }
   }
}

