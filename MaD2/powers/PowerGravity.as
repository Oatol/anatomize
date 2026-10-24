package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import triggers.ModifyGravity;
   
   public class PowerGravity extends Power
   {
      
      public function PowerGravity()
      {
         super(Tool.GRAVITY,"gravity","gravity");
         noDuration = false;
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         if(userData(param1.GetUserData()).resistGravity)
         {
            return;
         }
         bodyUD.trigger = new ModifyGravity(3);
         bodyUD.triggerDuration = Tweak.toolDuration * 60;
         bodyUD.triggered = true;
      }
      
      override protected function AddParticles(param1:b2Vec2, param2:b2Vec2) : void
      {
         particlePos = GeneralUtils.pointOnCircle(param1.x,param1.y,particleRadius,particleAngle);
         GameState.particles.addParticles(particlePos.x,particlePos.y,1,particle,param2.x * 0.1,param2.y * 0.1 + Vars.gravity * 0.1);
      }
      
      override protected function OnProjectileThrow(param1:b2Vec2, param2:b2Vec2) : void
      {
         super.OnProjectileThrow(param1,param2);
         if(!throwBody)
         {
            return;
         }
         userData(throwBody.GetUserData()).triggerDuration = Tweak.toolDuration * 60;
      }
   }
}

