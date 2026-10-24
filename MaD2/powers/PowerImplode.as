package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PowerImplode extends Power
   {
      
      public function PowerImplode()
      {
         super(Tool.IMPLODE,"shock2","implosive");
         noEffectRadius = false;
         noEffectForce = false;
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         var _loc2_:b2Body = null;
         super.OnBodyPress(param1);
         if(Math.random() > 0.99)
         {
            ThrowUpdate(new b2Vec2());
            _loc2_ = GameState.objects.addbullet("implosive",pressPos.x / Physics.scale + throwPos.x,pressPos.y / Physics.scale + throwPos.y,0,1,1,throwPos,0,Physics.world.GetGroundBody());
            userData(_loc2_.GetUserData()).triggerRadius = Tweak.toolEffectRadius;
            userData(_loc2_.GetUserData()).triggerForce = Tweak.toolEffectForce;
         }
      }
      
      override protected function AddParticles(param1:b2Vec2, param2:b2Vec2) : void
      {
         var _loc5_:b2Vec2 = null;
         var _loc6_:int = 0;
         var _loc3_:b2Vec2 = GeneralUtils.pointOnCircle(param1.x,param1.y,particleRadius,particleAngle);
         var _loc4_:b2Vec2 = GeneralUtils.pointOnCircle(param1.x,param1.y,particleRadius,particleAngle + (Math.random() > 0.5 ? -10 : 10));
         GameState.particles.addParticles(_loc3_.x,_loc3_.y,1,"shock2",param2.x * 0.1 + (_loc4_.x - _loc3_.x) * 0.1,param2.y * 0.1 + (_loc4_.y - _loc3_.y) * 0.1,0,0);
         if(Math.random() > 0.96)
         {
            _loc5_ = GeneralUtils.pointOnCircle(param1.x,param1.y,Math.random() * particleRadius * 0.4 + particleRadius * 0.8,Math.random() * 360);
            _loc6_ = 0;
            while(_loc6_ < 10)
            {
               GameState.particles.addParticles(_loc5_.x,_loc5_.y,1,Math.random() > 0.7 ? "shock" : "shock2",(-param1.x + _loc5_.x) * 0.01 + Math.random() * 4 - 2,(-param1.y + _loc5_.y) * 0.01 + Math.random() * 4 - 2,2,2);
               _loc6_++;
            }
         }
      }
      
      override protected function OnProjectileThrow(param1:b2Vec2, param2:b2Vec2) : void
      {
         super.OnProjectileThrow(param1,param2);
         if(!throwBody)
         {
            return;
         }
         userData(throwBody.GetUserData()).triggerRadius = Tweak.toolEffectRadius;
         userData(throwBody.GetUserData()).triggerForce = Tweak.toolEffectForce;
      }
   }
}

