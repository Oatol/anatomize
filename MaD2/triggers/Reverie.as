package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Reverie extends Trigger
   {
      
      public function Reverie()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc8_:b2Body = null;
         var _loc9_:userData = null;
         var _loc10_:b2Vec2 = null;
         var _loc11_:Vector.<MyLittleParticle> = null;
         var _loc12_:MyLittleParticle = null;
         var _loc13_:b2Vec2 = null;
         var _loc14_:b2Vec2 = null;
         var _loc15_:b2Vec2 = null;
         var _loc16_:b2Vec2 = null;
         var _loc17_:Vector.<MyLittleParticle> = null;
         super.trigger(param1,param2);
         var _loc3_:String = "supershiny";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc3_ = param2.pfx.getParticle();
         }
         var _loc4_:b2Vec2 = new b2Vec2(0,-Math.random() * 100 * param2.size);
         var _loc5_:b2Vec2 = BoxUtils.rotateVec(_loc4_,bodyAngle);
         var _loc6_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc5_.x,pixelCenter.y + _loc5_.y);
         var _loc7_:Array = Body.GetAround(param1,triggerRadius * param2.size,triggerRadius * param2.size);
         if(param2.triggerDuration > 0)
         {
            param2.triggerDuration -= TimeLord.speed;
         }
         for each(_loc8_ in _loc7_)
         {
            _loc9_ = userData(_loc8_.GetUserData());
            if(!_loc9_.hasBeenCut)
            {
               if(_loc9_.health < _loc9_.maxhealth || _loc9_.bleeding.length > 0 || _loc9_.trigger != null && _loc9_.trigger != _loc9_.originalTrigger || _loc9_.temperature < 0 || _loc9_.temperature > 100)
               {
                  _loc10_ = _loc8_.GetPosition().Copy();
                  _loc10_.Multiply(Physics.scale);
                  if(param2.triggerDuration <= 0)
                  {
                     param2.triggerDuration = 16;
                     _loc11_ = BoxUtils.randomSlopeParticles(_loc3_,_loc6_,_loc10_);
                     for each(_loc12_ in _loc11_)
                     {
                        _loc12_.health = 200;
                        _loc12_.friction = 0.9;
                     }
                  }
                  _loc9_.health = _loc9_.maxhealth;
                  Body.Dispel(_loc8_);
               }
            }
         }
         if(triggerState % 32 == 0)
         {
            if(bodyVel.Length() < 1)
            {
               _loc13_ = new b2Vec2(Math.sin(triggerState * 0.02) * 8,triggerState * 0.1 - 24);
               _loc14_ = new b2Vec2(Math.sin(-triggerState * 0.02) * 8,80 - triggerState * 0.1 - 24);
               _loc15_ = BoxUtils.rotateVec(_loc13_,bodyAngle);
               _loc16_ = BoxUtils.rotateVec(_loc14_,bodyAngle);
               _loc11_ = GameState.particles.addParticles(pixelCenter.x - _loc15_.x * param2.size,pixelCenter.y - _loc15_.y * param2.size,1,_loc3_,bodyVel.x * 0.1,bodyVel.y * 0.1,0,0);
               _loc17_ = GameState.particles.addParticles(pixelCenter.x - _loc16_.x * param2.size,pixelCenter.y - _loc16_.y * param2.size,1,_loc3_,bodyVel.x * 0.1,bodyVel.y * 0.1,0,0);
               if(Boolean(_loc11_) && Boolean(_loc11_[0]))
               {
                  _loc11_[0].health = 400;
               }
               if(Boolean(_loc17_) && Boolean(_loc17_[0]))
               {
                  _loc17_[0].health = 400;
               }
            }
            else
            {
               _loc13_ = new b2Vec2(Math.random() * 20 - 10,Math.random() * 90 - 30);
               _loc15_ = BoxUtils.rotateVec(_loc13_,bodyAngle);
               _loc11_ = GameState.particles.addParticles(_loc6_.x - _loc15_.x * param2.size,_loc6_.y - _loc15_.y * param2.size,1,_loc3_,bodyVel.x * 0.1,bodyVel.y * 0.1,0,0);
               if((Boolean(_loc11_)) && Boolean(_loc11_[0]))
               {
                  _loc11_[0].health = 400;
               }
            }
         }
         param2.triggerState += 4;
         if(param2.triggerState > 800)
         {
            param2.triggerState = 0;
         }
      }
   }
}

