package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PowerWind extends Power
   {
      
      public function PowerWind()
      {
         super(Tool.WIND,"air","win");
         bodySound = "throw4";
         noEffectForce = false;
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         var _loc2_:b2Vec2 = param1.GetWorldCenter().Copy();
         _loc2_.Multiply(-Physics.scale);
         _loc2_.Add(pressPos);
         var _loc3_:Number = _loc2_.Normalize();
         var _loc4_:Number = (10 - _loc3_) / 10 * -10 * Tweak.toolEffectForce;
         if(_loc4_ > 0)
         {
            _loc4_ *= -1;
         }
         var _loc5_:b2Vec2 = new b2Vec2(_loc2_.x * _loc4_,_loc2_.y * _loc4_);
         param1.ApplyForce(_loc5_,param1.GetWorldCenter());
      }
      
      override protected function AddParticles(param1:b2Vec2, param2:b2Vec2) : void
      {
         var _loc3_:b2Vec2 = GeneralUtils.pointOnCircle(param1.x,param1.y,particleRadius,particleAngle);
         var _loc4_:b2Vec2 = GeneralUtils.pointOnCircle(param1.x,param1.y,particleRadius * 1.4,particleAngle);
         var _loc5_:b2Vec2 = GeneralUtils.pointOnCircle(param1.x,param1.y,particleRadius,particleAngle + (Math.random() > 0.5 ? -10 : 10));
         GameState.particles.addParticles(_loc3_.x,_loc3_.y,1,"air",param2.x * 0.1 + (_loc4_.x - _loc3_.x) * 0.1,param2.y * 0.1 + (_loc4_.y - _loc3_.y) * 0.1,0,0);
         GameState.particles.addParticles(_loc3_.x,_loc3_.y,1,"air",param2.x * 0.1 + (_loc5_.x - _loc3_.x) * 0.1,param2.y * 0.1 + (_loc5_.y - _loc3_.y) * 0.1,0,0);
      }
      
      override protected function OnProjectileThrow(param1:b2Vec2, param2:b2Vec2) : void
      {
         super.OnProjectileThrow(param1,param2);
         if(!throwBody)
         {
            return;
         }
         userData(throwBody.GetUserData()).triggerForce = Tweak.toolEffectForce;
      }
   }
}

