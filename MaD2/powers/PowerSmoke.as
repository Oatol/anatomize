package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import triggers.Invis;
   
   public class PowerSmoke extends Power
   {
      
      public function PowerSmoke()
      {
         super(Tool.SMOKE,"bigSmoke","smoke");
         noThrowAmount = true;
         noDuration = false;
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         if(!bodyUD.graphic)
         {
            return;
         }
         bodyUD.trigger = new Invis();
         bodyUD.triggerDuration = Tweak.toolDuration * 60;
         bodyUD.triggered = true;
      }
      
      override protected function AddParticles(param1:b2Vec2, param2:b2Vec2) : void
      {
         var _loc3_:b2Vec2 = GeneralUtils.pointOnCircle(param1.x,param1.y,particleRadius,particleAngle);
         var _loc4_:Vector.<MyLittleParticle> = GameState.particles.addParticles(_loc3_.x,_loc3_.y,1,"bigSmoke",param2.x * 0.1,param2.y * 0.1,0,0);
         if((Boolean(_loc4_)) && Boolean(_loc4_[0]))
         {
            _loc4_[0].friction = 0.5;
            _loc4_[0].fade = 1;
            _loc4_[0].health = 1000;
         }
      }
      
      override protected function ThrowUpdate(param1:b2Vec2) : void
      {
         super.ThrowUpdate(param1);
         throwProjectiles = 1;
      }
   }
}

