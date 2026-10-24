package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Trail extends Trigger
   {
      
      public function Trail()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(bodyVel.Length() > 40)
         {
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,"poof",bodyVel.x * 0.1,bodyVel.y * 0.1,bodyVel.x * 0.01,bodyVel.y * 0.01);
         }
      }
   }
}

