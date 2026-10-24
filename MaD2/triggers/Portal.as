package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Portal extends Trigger
   {
      
      public function Portal()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Body = null;
         var _loc4_:b2Body = null;
         var _loc6_:Vector.<Array> = null;
         var _loc7_:uint = 0;
         var _loc13_:Vector.<MyLittleParticle> = null;
         var _loc15_:b2Body = null;
         var _loc16_:userData = null;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:MyLittleParticle = null;
         var _loc25_:userData = null;
         var _loc26_:* = undefined;
         var _loc27_:* = undefined;
         var _loc28_:* = undefined;
         var _loc29_:Array = null;
         var _loc30_:b2Body = null;
         var _loc31_:b2Vec2 = null;
         var _loc32_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(param2.connected.length == 0)
         {
            return;
         }
         for each(_loc3_ in param2.connected)
         {
            _loc16_ = userData(_loc3_.GetUserData());
            if(!_loc16_ || _loc16_.dead)
            {
               param2.disconnect(_loc3_);
               return;
            }
            if(!_loc16_.trigger || !(_loc16_.trigger is Portal))
            {
               _loc17_ = BoxUtils.vectorDist(_loc3_.GetWorldCenter(),bodyCenter);
               if(_loc17_ > param2.triggerRadius * 2)
               {
                  param2.disconnect(_loc3_);
               }
               else
               {
                  _loc18_ = (Math.random() * param2.width - param2.width * 0.5) / Physics.scale;
                  _loc19_ = (Math.random() * param2.height - param2.height * 0.5) / Physics.scale;
                  _loc20_ = (bodyCenter.x + _loc18_ * Math.cos(bodyAngle) - _loc19_ * Math.sin(bodyAngle)) * Physics.scale;
                  _loc21_ = (bodyCenter.y + _loc18_ * Math.sin(bodyAngle) + _loc19_ * Math.cos(bodyAngle)) * Physics.scale;
                  _loc22_ = -_loc20_ + _loc3_.GetWorldCenter().x * Physics.scale;
                  _loc23_ = -_loc21_ + _loc3_.GetWorldCenter().y * Physics.scale;
                  _loc22_ *= 0.1;
                  _loc23_ *= 0.1;
                  _loc6_ = param2.skin;
                  _loc7_ = param2.name == "portal1" ? 1118651 : 16746497;
                  if(_loc6_.length > 0)
                  {
                     _loc7_ = BoxUtils.getSkinColour(_loc6_,param2.name == "portal1" ? "1111BB" : "FF8801");
                  }
                  _loc7_ = 4278190080 + _loc7_;
                  _loc13_ = GameState.particles.addParticles(_loc20_,_loc21_,1,"laser",_loc22_,_loc23_);
                  for each(_loc24_ in _loc13_)
                  {
                     _loc24_.colour = _loc7_;
                     _loc24_.health = 50;
                     _loc24_.friction = 0.9;
                     _loc24_.wanderX = 0;
                     _loc24_.wanderY = 0;
                  }
               }
            }
         }
         _loc4_ = param2.connected[0];
         if(!_loc4_)
         {
            return;
         }
         if(userData(_loc4_.GetUserData()).name != "portal1" && userData(_loc4_.GetUserData()).name != "portal2")
         {
            return;
         }
         var _loc5_:Number = triggerRadius * param2.size;
         _loc6_ = param2.skin;
         _loc7_ = param2.name == "portal1" ? 1118651 : 16746497;
         if(Boolean(_loc6_) && _loc6_.length > 0)
         {
            _loc7_ = BoxUtils.getSkinColour(_loc6_,param2.name == "portal1" ? "1111BB" : "FF8801");
         }
         _loc7_ = 4278190080 + _loc7_;
         var _loc8_:Number = Math.random() * _loc5_;
         var _loc9_:* = Math.random() * 360;
         var _loc10_:b2Vec2 = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,_loc8_,_loc9_);
         var _loc11_:b2Vec2 = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,_loc8_ * 0.95,_loc9_ + (param2.name == "portal1" ? 5 : -5));
         var _loc12_:String = "laser";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc12_ = param2.pfx.getParticle();
         }
         _loc13_ = GameState.particles.addParticles(_loc10_.x,_loc10_.y,1,_loc12_,_loc11_.x - _loc10_.x,_loc11_.y - _loc10_.y);
         if((Boolean(_loc13_)) && _loc13_.length > 0)
         {
            for each(_loc24_ in _loc13_)
            {
               _loc24_.colour = _loc7_;
               _loc24_.health = 50;
               _loc24_.friction = 0.9;
               _loc24_.wanderX = 0;
               _loc24_.wanderY = 0;
            }
         }
         var _loc14_:Array = Body.GetAround(param1,_loc5_,_loc5_);
         for each(_loc15_ in _loc14_)
         {
            _loc25_ = userData(_loc15_.GetUserData());
            if(!(_loc25_.name == "portal1" || _loc25_.name == "portal2"))
            {
               if(param2.connected.indexOf(_loc15_) == -1)
               {
                  _loc26_ = bodyCenter.x - _loc15_.GetWorldCenter().x;
                  _loc27_ = bodyCenter.y - _loc15_.GetWorldCenter().y;
                  _loc28_ = _loc26_ * _loc26_ + _loc27_ * _loc27_;
                  _loc15_.ApplyForce(new b2Vec2(_loc26_ * triggerForce * 0.03,_loc27_ * triggerForce * 0.03),_loc15_.GetWorldCenter());
                  if(_loc28_ < 8 * userData(param1.GetUserData()).size)
                  {
                     _loc29_ = BoxUtils.selectCompound(_loc15_);
                     for each(_loc30_ in _loc29_)
                     {
                        _loc31_ = _loc30_.GetLinearVelocity();
                        if(_loc31_.x > Tweak.PortalSpeedCap)
                        {
                           _loc31_.x = Tweak.PortalSpeedCap;
                        }
                        if(_loc31_.y > Tweak.PortalSpeedCap)
                        {
                           _loc31_.y = Tweak.PortalSpeedCap;
                        }
                        _loc32_ = _loc4_.GetPosition();
                        if(_loc29_.length > 1)
                        {
                           _loc32_ = new b2Vec2(_loc4_.GetPosition().x - (param1.GetPosition().x - _loc30_.GetPosition().x),_loc4_.GetPosition().y - (param1.GetPosition().y - _loc30_.GetPosition().y));
                        }
                        _loc30_.SetXForm(_loc32_,_loc30_.GetAngle());
                        _loc30_.SetLinearVelocity(_loc31_);
                        if(userData(_loc4_.GetUserData()).connected.indexOf(_loc30_) == -1)
                        {
                           userData(_loc4_.GetUserData()).connected.push(_loc30_);
                        }
                     }
                  }
               }
            }
         }
      }
   }
}

