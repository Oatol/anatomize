package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Tesla extends Trigger
   {
      
      public function Tesla()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc8_:String = null;
         var _loc10_:userData = null;
         var _loc11_:* = undefined;
         var _loc12_:b2Vec2 = null;
         var _loc13_:b2Vec2 = null;
         var _loc14_:Number = NaN;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = param2.triggerPos.Copy();
         _loc3_.Multiply(param2.size);
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         _loc4_.Add(pixelCenter);
         var _loc5_:Number = param2.triggerRadius / Physics.scale * param2.size;
         var _loc6_:Array = Body.GetMultiple(new b2Vec2(_loc4_.x / Physics.scale - _loc5_ * 0.5,_loc4_.y / Physics.scale - _loc5_ * 0.5),_loc5_,_loc5_,false);
         var _loc7_:b2Body = _loc6_[Math.random() * _loc6_.length >> 0];
         if((Boolean(_loc7_)) && _loc7_ != param1)
         {
            _loc10_ = userData(_loc7_.GetUserData());
            if(_loc10_.resistShock)
            {
               return;
            }
            if(_loc10_.trigger is Tesla)
            {
               return;
            }
            if(_loc10_.name == "electropulsegun")
            {
               return;
            }
            if(_loc10_.name == "shockwavemine")
            {
               return;
            }
            if(_loc10_.name == "electronicbottle")
            {
               return;
            }
            if(_loc10_.name == "bottleofzap")
            {
               return;
            }
            if(_loc10_.name == "cloudsplitter")
            {
               return;
            }
            _loc11_ = 1;
            if(Boolean(param2.triggerForce) && param2.triggerForce != 0)
            {
               _loc11_ = param2.triggerForce * 0.01;
            }
            _loc10_.trigger = new Electrified();
            _loc10_.triggered = true;
            _loc10_.triggerDuration = Math.random() * 30 + 30;
            Body.Damage(_loc7_,_loc11_ * (Math.random() * 32 + 24),new b2Vec2(),new b2Vec2(),new b2Vec2(),false);
            _loc12_ = GeneralUtils.pointOnCircle(_loc4_.x,_loc4_.y,20 * param2.size,Math.random() * 360);
            _loc13_ = _loc7_.GetWorldCenter().Copy();
            _loc13_.Multiply(Physics.scale);
            _loc14_ = (_loc13_.y - _loc4_.y) / (_loc13_.x - _loc4_.x);
            _loc15_ = 2;
            _loc16_ = 0;
            while(_loc16_ < 20 * _loc15_)
            {
               _loc8_ = "shock";
               if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
               {
                  _loc8_ = param2.pfx.getParticle();
               }
               _loc17_ = _loc12_.x + _loc16_ / (20 * _loc15_) * (_loc13_.x - _loc12_.x);
               _loc18_ = _loc12_.y + _loc14_ * (_loc17_ - _loc12_.x);
               GameState.particles.addParticles(_loc17_,_loc18_,1,_loc8_,(-_loc12_.x + _loc17_) * 0.05,(-_loc12_.y + _loc18_) * 0.05,2 * _loc15_,2 * _loc15_);
               _loc16_++;
            }
         }
         _loc8_ = "shock";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc8_ = param2.pfx.getParticle();
         }
         var _loc9_:b2Vec2 = new b2Vec2(Math.random() * 80 - 40,Math.random() * 16 - 8);
         _loc9_ = BoxUtils.rotateVec(_loc9_,bodyAngle);
         GameState.particles.addParticles(_loc4_.x + _loc9_.x,_loc4_.y + _loc9_.y,1,_loc8_,bodyVel.x * 0.1,bodyVel.y * 0.1,4,4);
      }
   }
}

