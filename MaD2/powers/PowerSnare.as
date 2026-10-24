package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import triggers.Snare;
   
   public class PowerSnare extends Power
   {
      
      public function PowerSnare()
      {
         super(Tool.SNARE,"snare","sna");
         throwSound = "tinygrowth";
         bodySound = "drain2";
         throwVol = 0.8;
         bodyVol = 0.6;
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         if(bodyUD.resistSnare)
         {
            return;
         }
         bodyUD.trigger = new Snare();
         bodyUD.triggered = true;
         bodyUD.triggerForce = 1;
      }
      
      override protected function AddParticles(param1:b2Vec2, param2:b2Vec2) : void
      {
         var _loc3_:b2Vec2 = GeneralUtils.pointOnCircle(param1.x,param1.y,particleRadius,particleAngle);
         var _loc4_:b2Vec2 = GeneralUtils.pointOnCircle(param1.x,param1.y,particleRadius * 1.1,particleAngle + Math.random() * 20 - 10);
         GameState.particles.addParticles(_loc3_.x,_loc3_.y,1,"snare",param2.x * 0.1 + _loc3_.x - _loc4_.x,param2.y * 0.1 + _loc3_.y - _loc4_.y,0,0);
      }
   }
}

