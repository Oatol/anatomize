package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class BloodBag extends Trigger
   {
      
      public function BloodBag()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:userData = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         super.trigger(param1,param2);
         if(param2.health <= 0)
         {
            param2.triggered = false;
            return;
         }
         var _loc3_:String = "heal";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc3_ = param2.pfx.getParticle();
         }
         for each(_loc4_ in param2.connected)
         {
            _loc5_ = userData(_loc4_.GetUserData());
            if(_loc5_.alive && _loc5_.health < _loc5_.maxhealth)
            {
               ++userData(_loc4_.GetUserData()).health;
               --param2.health;
               _loc6_ = Math.random() * _loc5_.width - _loc5_.width * 0.5;
               _loc7_ = Math.random() * _loc5_.height - _loc5_.height * 0.5;
               _loc8_ = _loc4_.GetPosition().x * Physics.scale + _loc6_ * Math.cos(_loc4_.GetAngle()) - _loc7_ * Math.sin(_loc4_.GetAngle());
               _loc9_ = _loc4_.GetPosition().y * Physics.scale + _loc6_ * Math.sin(_loc4_.GetAngle()) + _loc7_ * Math.cos(_loc4_.GetAngle());
               _loc10_ = _loc4_.GetLinearVelocity().x * 0.1;
               _loc11_ = _loc4_.GetLinearVelocity().y * 0.1;
               GameState.particles.addParticles(_loc8_,_loc9_,1,_loc3_,_loc10_,_loc11_);
            }
         }
      }
   }
}

