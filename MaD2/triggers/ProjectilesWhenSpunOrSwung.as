package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class ProjectilesWhenSpunOrSwung extends ProjectilesWhen
   {
      
      public function ProjectilesWhenSpunOrSwung()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         if(param1.GetLinearVelocity().Length() > param2.triggerForce || Math.abs(param1.GetAngularVelocity()) > param2.triggerForce)
         {
            spawn = true;
         }
         else
         {
            spawn = false;
         }
         super.trigger(param1,param2);
      }
   }
}

