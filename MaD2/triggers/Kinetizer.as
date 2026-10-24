package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Kinetizer extends Trigger
   {
      
      public function Kinetizer()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Vec2 = null;
         var _loc11_:b2Vec2 = null;
         var _loc12_:b2Vec2 = null;
         var _loc13_:b2Vec2 = null;
         var _loc14_:b2Vec2 = null;
         var _loc15_:b2Vec2 = null;
         var _loc16_:b2Vec2 = null;
         var _loc17_:Array = null;
         var _loc18_:b2Body = null;
         var _loc19_:b2Vec2 = null;
         var _loc20_:int = 0;
         var _loc21_:String = null;
         var _loc22_:b2Vec2 = null;
         super.trigger(param1,param2);
         var _loc3_:int = 1;
         if(param2.flipped)
         {
            _loc3_ = -1;
         }
         _loc4_ = param2.triggerPos.Copy();
         _loc4_.Multiply(param2.size);
         _loc4_.x *= _loc3_;
         var _loc5_:b2Vec2 = BoxUtils.rotateVec(_loc4_,bodyAngle);
         _loc5_.Add(pixelCenter);
         var _loc6_:Number = Math.cos(bodyAngle + Math.PI * 0.5);
         var _loc7_:Number = Math.sin(bodyAngle + Math.PI * 0.5);
         var _loc8_:Number = bodyCenter.x * Physics.scale;
         var _loc9_:Number = bodyCenter.y * Physics.scale;
         var _loc10_:int = 1;
         while(_loc10_ < 3)
         {
            _loc11_ = new b2Vec2(-_loc3_ * 30 * param2.size + _loc3_ * _loc10_ * 30 * param2.size,-35 * param2.size);
            _loc12_ = new b2Vec2(-_loc3_ * 30 * param2.size + _loc3_ * _loc10_ * 30 * param2.size,-40 * param2.size);
            _loc13_ = BoxUtils.rotateVec(_loc11_,bodyAngle);
            _loc14_ = BoxUtils.rotateVec(_loc12_,bodyAngle);
            _loc15_ = new b2Vec2(_loc8_ + _loc13_.x,_loc9_ + _loc13_.y);
            _loc16_ = new b2Vec2(_loc8_ + _loc14_.x,_loc9_ + _loc14_.y);
            _loc17_ = GameState.cutter.CustomRaycast(_loc15_,20 * param2.size,_loc16_,true);
            _loc18_ = _loc17_[0] as b2Body;
            if(_loc18_)
            {
               if(_loc18_.IsStatic())
               {
                  return;
               }
               if(param2.connected.indexOf(_loc18_) != -1)
               {
                  return;
               }
               Body.RemoveJoints(_loc18_);
               _loc18_.SetXForm(new b2Vec2(_loc5_.x / Physics.scale,_loc5_.y / Physics.scale),_loc18_.GetAngle());
               _loc19_ = new b2Vec2(-_loc3_ * param2.triggerForce * _loc18_.GetMass(),0);
               _loc19_ = BoxUtils.rotateVec(_loc19_,bodyAngle);
               _loc18_.ApplyImpulse(_loc19_,_loc18_.GetPosition());
               Body.ThrowItem(userData(_loc18_.GetUserData()),_loc18_.GetPosition().Copy());
               _loc20_ = 0;
               while(_loc20_ < 20)
               {
                  _loc21_ = "air";
                  if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
                  {
                     _loc21_ = param2.pfx.getParticle();
                  }
                  GameState.particles.addParticles(_loc5_.x,_loc5_.y,1,_loc21_,-_loc3_ * Math.cos(bodyAngle) * Math.random() * 5,-_loc3_ * Math.sin(bodyAngle) * Math.random() * 5,1,1);
                  _loc20_++;
               }
               sounds.play("thumper_shoot",param1,_loc5_,0.6);
            }
            _loc10_++;
         }
         if(Math.random() > 0.9)
         {
            _loc21_ = "air";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc21_ = param2.pfx.getParticle();
            }
            _loc22_ = GeneralUtils.pointOnCircle(_loc15_.x,_loc15_.y,36,bodyAngle * Vars.toDegrees + 20 - Math.random() * 220);
            GameState.particles.addParticles(_loc22_.x,_loc22_.y,1,_loc21_,(_loc15_.x - _loc22_.x) * 0.03,(_loc15_.y - _loc22_.y) * 0.03,0.1,0.1);
         }
      }
   }
}

