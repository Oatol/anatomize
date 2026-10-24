package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import triggers.ModifyGravity;
   
   public class PowerCrush extends Power
   {
      
      public function PowerCrush()
      {
         super(Tool.CRUSH,"gravity","crush");
         noEffectForce = false;
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         bodyUD.trigger = new ModifyGravity(10 * Tweak.toolEffectForce);
         bodyUD.triggerDuration = 10;
         bodyUD.triggered = true;
      }
      
      override protected function AddParticles(param1:b2Vec2, param2:b2Vec2) : void
      {
         particlePos = GeneralUtils.pointOnCircle(param1.x,param1.y,particleRadius,particleAngle);
         GameState.particles.addParticles(particlePos.x,particlePos.y,1,particle,param2.x * 0.1,param2.y * 0.1,0,2);
      }
   }
}

