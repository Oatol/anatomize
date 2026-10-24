package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DustOven extends Trigger
   {
      
      private var tcg:String;
      
      private var tcgbody:b2Body;
      
      public function DustOven()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc7_:b2Vec2 = null;
         var _loc10_:b2Body = null;
         var _loc11_:userData = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:String = null;
         var _loc15_:b2Vec2 = null;
         var _loc16_:int = 0;
         var _loc17_:b2Body = null;
         var _loc18_:userData = null;
         var _loc19_:b2Vec2 = null;
         var _loc20_:b2Vec2 = null;
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = param2.triggerPos.Copy();
         _loc3_.Multiply(param2.size);
         if(param2.flipped)
         {
            _loc3_.x *= -1;
         }
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc5_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
         var _loc6_:b2Vec2 = new b2Vec2(-22,8);
         _loc6_.Multiply(param2.size);
         if(param2.flipped)
         {
            _loc6_.x *= -1;
         }
         _loc4_ = BoxUtils.rotateVec(_loc6_,bodyAngle);
         _loc7_ = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
         var _loc8_:Number = 20 * param2.size;
         var _loc9_:Array = Body.GetAroundPoint(_loc7_,_loc8_,_loc8_,false);
         for each(_loc10_ in _loc9_)
         {
            if(_loc10_ != param1)
            {
               this.tcgbody = _loc10_;
               _loc11_ = userData(_loc10_.GetUserData());
               if(_loc11_.trigger is Dust)
               {
                  if(_loc11_.name == "dustpile")
                  {
                     if(Dust(_loc11_.trigger).item)
                     {
                        this.tcg = Dust(_loc11_.trigger).item.slice();
                        param2.triggerState = 1;
                        param2.triggerDuration = 240;
                     }
                     _loc11_.dead = true;
                     break;
                  }
                  if(_loc11_.name == "moltendust" || _loc11_.name == "crystaldust")
                  {
                     Body.RemoveJoints(_loc10_);
                     _loc10_.SetXForm(new b2Vec2(_loc5_.x / Physics.scale,_loc5_.y / Physics.scale),0);
                     _loc10_.SetLinearVelocity(new b2Vec2());
                     _loc12_ = (_loc7_.x - _loc5_.x) * -0.2;
                     _loc13_ = (_loc7_.y - _loc5_.y) * -0.2;
                     _loc10_.ApplyImpulse(new b2Vec2(_loc12_,_loc13_),_loc10_.GetWorldCenter());
                     if(_loc11_.name == "moltendust")
                     {
                        param2.triggerState = 2;
                        param2.triggerDuration = 60;
                        break;
                     }
                     if(_loc11_.name == "crystaldust")
                     {
                        param2.triggerState = 3;
                        param2.triggerDuration = 60;
                        break;
                     }
                  }
               }
            }
         }
         if(param2.triggerState == 1)
         {
            param2.triggerDuration -= TimeLord.speed;
            if(param2.triggerDuration <= 0)
            {
               _loc16_ = Properties.forceObjVanilla;
               Properties.forceObjVanilla = 0;
               _loc17_ = GameState.objects.spawnObject("tradingcard",_loc5_.x,_loc5_.y,0,false,true);
               Properties.forceObjVanilla = _loc16_;
               if(_loc17_)
               {
                  _loc18_ = userData(_loc17_.GetUserData());
                  TradingCard(_loc18_.trigger).item = this.tcg;
                  TradingCard(_loc18_.trigger).seed = Math.random() * 9000;
                  param2.triggerState = 0;
                  _loc12_ = (_loc7_.x - _loc5_.x) * -0.1;
                  _loc13_ = (_loc7_.y - _loc5_.y) * -0.1;
                  _loc17_.ApplyImpulse(new b2Vec2(_loc12_,_loc13_),_loc17_.GetWorldCenter());
               }
               else
               {
                  param2.triggerDuration = 10;
               }
            }
            _loc14_ = "petal";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc14_ = param2.pfx.getParticle();
            }
            _loc15_ = GeneralUtils.pointOnCircle(_loc7_.x,_loc7_.y,Math.random() * _loc8_,Math.random() * 360);
            GameState.particles.addParticles(_loc15_.x,_loc15_.y,1,_loc14_,(-_loc7_.x + _loc15_.x) * 0.04,(-_loc7_.y + _loc15_.y) * 0.04,1,1);
            param1.ApplyImpulse(new b2Vec2(Math.random() * 8 - 4,Math.random() * 40 - 20),bodyCenter);
         }
         else if(param2.triggerState == 2)
         {
            param2.triggerDuration -= TimeLord.speed;
            if(param2.triggerDuration <= 0)
            {
               param2.triggerState = 0;
            }
            _loc15_ = GeneralUtils.pointOnCircle(_loc7_.x,_loc7_.y,Math.random() * _loc8_,Math.random() * 360);
            _loc19_ = GeneralUtils.pointOnCircle(_loc5_.x,_loc5_.y,Math.random() * _loc8_,Math.random() * 360);
            _loc20_ = this.tcgbody.GetPosition().Copy();
            _loc20_.Multiply(Physics.scale);
            if(Math.random() > 0.8)
            {
               BoxUtils.randomSlopeParticles("crystal",_loc19_,_loc20_);
               GameState.particles.addParticles(_loc15_.x,_loc15_.y,1,"error",(-_loc7_.x + _loc15_.x) * 0.04,(-_loc7_.y + _loc15_.y) * 0.04,1,1);
            }
         }
         else if(param2.triggerState == 3)
         {
            param2.triggerDuration -= TimeLord.speed;
            if(param2.triggerDuration <= 0)
            {
               param2.triggerState = 0;
            }
            _loc15_ = GeneralUtils.pointOnCircle(_loc7_.x,_loc7_.y,Math.random() * _loc8_,Math.random() * 360);
            _loc19_ = GeneralUtils.pointOnCircle(_loc5_.x,_loc5_.y,Math.random() * _loc8_,Math.random() * 360);
            _loc20_ = this.tcgbody.GetPosition().Copy();
            _loc20_.Multiply(Physics.scale);
            if(Math.random() > 0.8)
            {
               BoxUtils.randomSlopeParticles("petal",_loc19_,_loc20_,10,1);
               GameState.particles.addParticles(_loc15_.x,_loc15_.y,1,"error",(-_loc7_.x + _loc15_.x) * 0.04,(-_loc7_.y + _loc15_.y) * 0.04,1,1);
            }
         }
      }
   }
}

