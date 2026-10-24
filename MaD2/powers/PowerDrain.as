package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class PowerDrain extends Power
   {
      
      public function PowerDrain()
      {
         super(Tool.DRAIN,"blood","dra");
         throwSound = "cut4";
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         var _loc4_:b2Vec2 = null;
         var _loc5_:b2Vec2 = null;
         super.OnBodyPress(param1);
         if(!bodyUD.alive)
         {
            return;
         }
         if(bodyUD.resistDrain)
         {
            return;
         }
         var _loc2_:b2Vec2 = pressPos.Copy();
         if(bodyUD.health > 8)
         {
            _loc4_ = bodyPos.Copy();
            _loc4_.Multiply(Physics.scale);
            _loc5_ = new b2Vec2((_loc2_.x - _loc4_.x) * 0.1,(_loc2_.y - _loc4_.y) * 0.1);
            Body.BloodParticles(param1,_loc4_,_loc5_);
            bodyUD.health *= 0.99;
            --bodyUD.health;
         }
         var _loc3_:int = 1 + Math.random() * 4;
         sounds.play("drain" + _loc3_.toString(),null,new b2Vec2(bodyPos.x * Physics.scale,bodyPos.y * Physics.scale),0.5,false);
      }
      
      override protected function AddParticles(param1:b2Vec2, param2:b2Vec2) : void
      {
         var _loc3_:b2Vec2 = GeneralUtils.pointOnCircle(param1.x,param1.y,particleRadius,particleAngle);
         var _loc4_:b2Vec2 = GeneralUtils.pointOnCircle(param1.x,param1.y,particleRadius,particleAngle + 2);
         GameState.particles.addParticles(_loc3_.x,_loc3_.y,1,particle,param2.x * 0.1 + _loc3_.x - _loc4_.x,param2.y * 0.1 + _loc3_.y - _loc4_.y,0,0);
      }
   }
}

