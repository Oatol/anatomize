package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class HealBullet extends GenericBullet
   {
      
      public function HealBullet()
      {
         super(null);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Body = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:userData = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         super.trigger(param1,param2);
         var _loc3_:Number = param2.triggerRadius;
         var _loc4_:Array = Body.GetAroundPoint(pixelCenter,_loc3_,_loc3_,false);
         for each(_loc5_ in _loc4_)
         {
            _loc7_ = userData(_loc5_.GetUserData());
            if(_loc7_.alive)
            {
               if(_loc7_.health < _loc7_.maxhealth)
               {
                  _loc7_.bleeding = [];
                  _loc7_.health += 50 * param2.size * TimeLord.speed;
                  _loc8_ = Math.random() * _loc7_.width - _loc7_.width * 0.5;
                  _loc9_ = Math.random() * _loc7_.height - _loc7_.height * 0.5;
                  _loc10_ = _loc5_.GetLinearVelocity().x * 0.1;
                  _loc11_ = _loc5_.GetLinearVelocity().y * 0.1;
                  _loc12_ = _loc5_.GetPosition().x * Physics.scale + _loc8_ * Math.cos(_loc5_.GetAngle()) - _loc9_ * Math.sin(_loc5_.GetAngle());
                  _loc13_ = _loc5_.GetPosition().y * Physics.scale + _loc8_ * Math.sin(_loc5_.GetAngle()) + _loc9_ * Math.cos(_loc5_.GetAngle());
                  GameState.particles.addParticles(_loc12_,_loc13_,1,"heal",_loc10_,_loc11_);
               }
            }
         }
         _loc6_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,_loc3_ * 0.5,Math.random() * 360);
         GameState.particles.addParticles(_loc6_.x,_loc6_.y,1,"heal",pixelCenter.x - _loc6_.x + bodyVel.x,pixelCenter.y - _loc6_.y + bodyVel.y,0,0);
      }
   }
}

