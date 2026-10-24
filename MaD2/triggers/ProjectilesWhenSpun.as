package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class ProjectilesWhenSpun extends Trigger
   {
      
      public function ProjectilesWhenSpun()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         if(triggerDuration <= 0)
         {
            if(Math.abs(param1.GetAngularVelocity()) > param2.triggerForce)
            {
               GameState.objects.addbullet(param2.triggerCustom,bodyCenter.x,bodyCenter.y,Math.random() * 360,1,Math.random() * 2 + 0.2,bodyVel,Math.abs(param1.GetAngularVelocity()) * 0.01,param1);
               param2.triggerDuration = param2.originalTriggerDuration;
            }
         }
      }
   }
}

