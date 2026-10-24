package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PowerVoid extends Power
   {
      
      public function PowerVoid()
      {
         super(Tool.VOID,"void","voi");
         noEffectForce = false;
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         var _loc2_:b2Vec2 = new b2Vec2(-param1.GetWorldCenter().x * Physics.scale + pressPos.x,-param1.GetWorldCenter().y * Physics.scale + pressPos.y);
         var _loc3_:Number = _loc2_.Normalize();
         var _loc4_:Number = (10 - _loc3_) / 10 * -20 * Tweak.toolEffectForce * bodyUD.size;
         if(_loc4_ < 0)
         {
            _loc4_ *= -1;
         }
         var _loc5_:b2Vec2 = new b2Vec2(_loc2_.x * _loc4_,_loc2_.y * _loc4_);
         var _loc6_:b2Vec2 = bodyPos.Copy();
         _loc6_.Add(new b2Vec2(Math.random() - 0.5,Math.random() - 0.5));
         param1.ApplyForce(_loc5_,_loc6_);
      }
      
      override protected function AddParticles(param1:b2Vec2, param2:b2Vec2) : void
      {
         var _loc3_:b2Vec2 = GeneralUtils.pointOnCircle(param1.x,param1.y,particleRadius,particleAngle);
         var _loc4_:b2Vec2 = GeneralUtils.pointOnCircle(param1.x,param1.y,particleRadius * 1.04,particleAngle - 2);
         GameState.particles.addParticles(_loc3_.x,_loc3_.y,1,particle,param2.x * 0.1 + _loc3_.x - _loc4_.x,param2.y * 0.1 + _loc3_.y - _loc4_.y,0,0);
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

