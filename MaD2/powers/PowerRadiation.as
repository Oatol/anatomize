package powers
{
   import Box2D.Common.Math.b2Vec2;
   
   public class PowerRadiation extends Power
   {
      
      public function PowerRadiation()
      {
         super(Tool.RADIATION,"radioactive");
         noPressRadius = true;
         noThrow = true;
      }
      
      override public function Throw(param1:b2Vec2, param2:b2Vec2) : void
      {
         Main.instance.stopDragging();
      }
      
      override protected function AddParticles(param1:b2Vec2, param2:b2Vec2) : void
      {
         particlePos = GeneralUtils.pointOnCircle(param1.x,param1.y,particleRadius,particleAngle);
         if(Math.random() > 0.8)
         {
            GameState.particles.addParticles(particlePos.x,particlePos.y,1,particle,param2.x * 0.1,param2.y * 0.1,0,2);
         }
      }
   }
}

