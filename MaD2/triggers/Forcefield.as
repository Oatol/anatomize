package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Forcefield extends Trigger
   {
      
      public function Forcefield()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc16_:b2Body = null;
         var _loc17_:userData = null;
         var _loc18_:Number = NaN;
         var _loc19_:String = null;
         var _loc20_:int = 0;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:b2Vec2 = null;
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = bodyCenter;
         var _loc4_:Number = Math.cos(bodyAngle + Math.PI * 0.5);
         var _loc5_:Number = Math.sin(bodyAngle + Math.PI * 0.5);
         var _loc6_:Number = _loc3_.x * Physics.scale;
         var _loc7_:Number = _loc3_.y * Physics.scale;
         var _loc8_:b2Vec2 = new b2Vec2(_loc6_ - 10 * param2.size * _loc4_,_loc7_ - 10 * param2.size * _loc5_);
         var _loc9_:b2Vec2 = new b2Vec2(_loc6_ - 250 * param2.size * _loc4_,_loc7_ - 250 * param2.size * _loc5_);
         var _loc10_:Array = GameState.cutter.CustomRaycast(_loc8_,250 * param2.size,_loc9_,false);
         var _loc11_:Array = [];
         if(_loc10_[0])
         {
            _loc11_ = BoxUtils.selectCompound(_loc10_[0]);
            for each(_loc16_ in _loc11_)
            {
               _loc17_ = userData(_loc16_.GetUserData());
               if(!_loc17_.resistStasis)
               {
                  if(_loc17_.name != "beepod")
                  {
                     if(!param2.triggerForce || param2.triggerForce == 0)
                     {
                        param2.triggerForce = 100;
                     }
                     _loc18_ = param2.triggerForce / 100;
                     if(triggerState == 2)
                     {
                        _loc16_.SetLinearVelocity(new b2Vec2(_loc16_.GetLinearVelocity().x * 1.5 * _loc18_,_loc16_.GetLinearVelocity().y * 1.5 * _loc18_));
                     }
                     else if(triggerState == -2)
                     {
                        _loc16_.SetLinearVelocity(new b2Vec2(_loc16_.GetLinearVelocity().x * 0.8 * _loc18_,_loc16_.GetLinearVelocity().y * 0.8 * _loc18_));
                     }
                     else if(triggerState == 3)
                     {
                        _loc16_.SetAngularVelocity(_loc16_.GetAngularVelocity() * 1.25 * _loc18_);
                     }
                     else if(triggerState == 4)
                     {
                        _loc16_.SetLinearVelocity(new b2Vec2(_loc16_.GetLinearVelocity().x * -1 * _loc18_,_loc16_.GetLinearVelocity().y * -1 * _loc18_));
                     }
                     else
                     {
                        _loc16_.SetLinearVelocity(new b2Vec2(_loc16_.GetLinearVelocity().x * 0.25 * _loc18_,_loc16_.GetLinearVelocity().y * 0.25 * _loc18_));
                        _loc16_.SetAngularVelocity(_loc16_.GetAngularVelocity() * 0.75 * _loc18_);
                     }
                     if(triggerState == 0)
                     {
                        _loc20_ = -1;
                        if(_loc17_.antigrav)
                        {
                           _loc20_ = 1;
                        }
                        if(_loc17_.zerograv)
                        {
                           _loc20_ = 0;
                        }
                        _loc16_.ApplyForce(new b2Vec2(-Vars.wind * _loc16_.GetMass(),_loc20_ * Vars.gravity * _loc16_.GetMass()),_loc16_.GetWorldCenter());
                     }
                     else if(triggerState == 1)
                     {
                        _loc16_.ApplyImpulse(new b2Vec2(-10 * _loc4_ * _loc18_,-10 * _loc5_ * _loc18_),_loc16_.GetWorldCenter());
                     }
                     else if(triggerState == -1)
                     {
                        _loc16_.ApplyImpulse(new b2Vec2(10 * _loc4_ * _loc18_,10 * _loc5_ * _loc18_),_loc16_.GetWorldCenter());
                     }
                     _loc16_.WakeUp();
                     _loc19_ = "forcefield";
                     if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
                     {
                        _loc19_ = param2.pfx.getParticle();
                     }
                     BoxUtils.randomParticlesOnBody(_loc16_,_loc19_);
                  }
               }
            }
         }
         var _loc12_:b2Vec2 = _loc8_;
         var _loc13_:b2Vec2 = new b2Vec2(_loc10_[1].x * Physics.scale,_loc10_[1].y * Physics.scale);
         var _loc14_:Number = (_loc13_.y - _loc12_.y) / (_loc13_.x - _loc12_.x);
         var _loc15_:int = 0;
         while(_loc15_ < 2)
         {
            _loc21_ = _loc12_.x + Math.random() * (_loc13_.x - _loc12_.x);
            _loc22_ = _loc12_.y + _loc14_ * (_loc21_ - _loc12_.x);
            _loc19_ = "forcefield";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc19_ = param2.pfx.getParticle();
            }
            if(triggerState == 0)
            {
               GameState.particles.addParticles(_loc21_,_loc22_,1,_loc19_);
            }
            else if(triggerState == 1)
            {
               GameState.particles.addParticles(_loc21_,_loc22_,1,_loc19_,-_loc4_ * 5,-_loc5_ * 5,0.5,0.5);
            }
            else if(triggerState == -1)
            {
               GameState.particles.addParticles(_loc21_ - _loc4_ * 40,_loc22_ - _loc5_ * 40,1,_loc19_,_loc4_ * 5,_loc5_ * 5,0.5,0.5);
            }
            else if(triggerState == 2)
            {
               GameState.particles.addParticles(_loc21_,_loc22_,1,_loc19_,(Math.random() > 0.5 ? 1 : -1) * (_loc4_ + Math.PI * 0.5),(Math.random() > 0.5 ? 1 : -1) * (_loc5_ + Math.PI * 0.5),0,0);
            }
            else if(triggerState == -2)
            {
               _loc23_ = new b2Vec2(Math.random() > 0.5 ? 8 : -8,0);
               _loc23_ = BoxUtils.rotateVec(_loc23_,bodyAngle);
               GameState.particles.addParticles(_loc21_ + _loc23_.x,_loc22_ + _loc23_.y,1,_loc19_,-_loc23_.x * 0.1 * (_loc4_ + Math.PI * 0.5),-_loc23_.y * 0.1 * (_loc5_ + Math.PI * 0.5),0,0);
            }
            else
            {
               GameState.particles.addParticles(_loc21_,_loc22_,1,_loc19_,0,0,_loc4_,_loc5_);
            }
            _loc15_++;
         }
      }
   }
}

