package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class VoidBullet extends GenericBullet
   {
      
      public function VoidBullet()
      {
         super(null);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Body = null;
         var _loc6_:int = 0;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:b2Vec2 = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:b2Vec2 = null;
         var _loc13_:b2Vec2 = null;
         super.trigger(param1,param2);
         var _loc3_:Number = param2.triggerRadius;
         var _loc4_:Array = Body.GetAroundPoint(pixelCenter,_loc3_,_loc3_,false);
         for each(_loc5_ in _loc4_)
         {
            if(userData(_loc5_.GetUserData()).name != "voidbullet")
            {
               _loc5_.WakeUp();
               _loc9_ = new b2Vec2(-_loc5_.GetWorldCenter().x * Physics.scale + pixelCenter.x,-_loc5_.GetWorldCenter().y * Physics.scale + pixelCenter.y);
               _loc10_ = _loc9_.Normalize();
               _loc11_ = (_loc3_ - _loc10_) / _loc3_ * -20 * param2.triggerForce * param2.size;
               if(_loc11_ < 0)
               {
                  _loc11_ *= -1;
               }
               _loc12_ = new b2Vec2(_loc9_.x * _loc11_,_loc9_.y * _loc11_);
               _loc13_ = _loc5_.GetWorldCenter().Copy();
               _loc13_.Add(new b2Vec2(Math.random() - 0.5,Math.random() - 0.5));
               _loc5_.ApplyForce(_loc12_,_loc13_);
               _loc5_.SetAngularVelocity(_loc5_.GetAngularVelocity() * 1.1);
               if(_loc5_.GetAngularVelocity() > 30)
               {
                  _loc5_.SetAngularVelocity(30);
               }
               if(_loc5_.GetAngularVelocity() < -30)
               {
                  _loc5_.SetAngularVelocity(-30);
               }
            }
         }
         _loc6_ = Math.random() * 360 >> 0;
         _loc7_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,_loc3_,_loc6_);
         _loc8_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,_loc3_ * 1.1,_loc6_ - 2);
         GameState.particles.addParticles(_loc7_.x,_loc7_.y,1,"void",bodyVel.x * 0.1 + _loc7_.x - _loc8_.x,bodyVel.y * 0.1 + _loc7_.y - _loc8_.y,0,0);
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration < 0)
         {
            param2.dead = true;
         }
      }
   }
}

