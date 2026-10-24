package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PowerDeath extends Power
   {
      
      public function PowerDeath()
      {
         super(Tool.DEATH,"dark","dea");
         throwSound = "flies";
         bodySound = "tinyflies";
         bodyVol = 0.3;
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         if(bodyUD.resistKill)
         {
            return;
         }
         Body.Kill(param1,pressPos);
      }
      
      override public function Particles(param1:b2Vec2, param2:b2Vec2) : void
      {
         if(Math.random() > 0.5)
         {
            super.Particles(param1,param2);
         }
      }
      
      override protected function AddParticles(param1:b2Vec2, param2:b2Vec2) : void
      {
         var _loc3_:b2Vec2 = param1;
         var _loc4_:b2Vec2 = GeneralUtils.pointOnCircle(param1.x,param1.y,particleRadius * Math.random() * Math.random() * 1.5,particleAngle);
         GameState.particles.addParticles(_loc3_.x,_loc3_.y,1,particle,param2.x * 0.1 + (_loc4_.x - _loc3_.x),param2.y * 0.1 + (_loc4_.y - _loc3_.y),0,0);
      }
   }
}

