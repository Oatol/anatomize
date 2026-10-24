package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class GhostVacuum extends Trigger
   {
      
      internal var value:int = 0;
      
      internal var wander:Number = 0;
      
      public function GhostVacuum()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc9_:b2Body = null;
         var _loc10_:userData = null;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:b2Vec2 = null;
         var _loc15_:b2Vec2 = null;
         var _loc16_:b2Vec2 = null;
         var _loc17_:b2Vec2 = null;
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = param2.triggerPos.Copy();
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc5_:Number = param2.triggerRadius * param2.size;
         var _loc6_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
         var _loc7_:Array = Body.GetAroundPoint(_loc6_,_loc5_,_loc5_,false);
         var _loc8_:String = "air";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc8_ = param2.pfx.getParticle();
         }
         for each(_loc9_ in _loc7_)
         {
            if(_loc9_ != param1)
            {
               _loc10_ = userData(_loc9_.GetUserData());
               if(_loc10_.ghost)
               {
                  if(param2.ignored.indexOf(_loc9_) == -1)
                  {
                     _loc9_.WakeUp();
                     _loc11_ = bodyCenter.x - _loc9_.GetWorldCenter().x;
                     _loc12_ = bodyCenter.y - _loc9_.GetWorldCenter().y;
                     _loc13_ = Math.sqrt(_loc11_ * _loc11_ + _loc12_ * _loc12_);
                     _loc14_ = new b2Vec2(_loc11_,_loc12_);
                     _loc14_.Multiply(0.1 * param2.triggerForce * (param2.triggerRadius / _loc13_) * param2.size);
                     _loc9_.ApplyForce(_loc14_,_loc9_.GetWorldCenter());
                     if(Math.random() > 0.5)
                     {
                        _loc15_ = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,Math.random() * _loc5_,Math.random() * 360);
                        GameState.particles.addParticles(_loc15_.x,_loc15_.y,1,_loc8_,(-_loc6_.x + _loc15_.x) * -0.08,(-_loc6_.y + _loc15_.y) * -0.08,1,1);
                     }
                     if(Math.random() > 0.9)
                     {
                        _loc16_ = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,_loc5_,Math.random() * 360);
                        GameState.particles.addParticles(_loc16_.x,_loc16_.y,1,_loc8_,(-_loc6_.x + _loc16_.x) * 0.01,(-_loc6_.y + _loc16_.y) * 0.01,1,1);
                     }
                     if(_loc13_ < 3)
                     {
                        Body.Disintegrate(_loc9_,"bigSmoke",10);
                        ++this.value;
                        param2.triggerCustom = this.value.toString();
                        break;
                     }
                  }
               }
            }
         }
         if(this.value > 0)
         {
            param1.WakeUp();
            this.wander = this.value * Math.random() * 100;
            _loc17_ = new b2Vec2(Math.random() * this.wander - this.wander * 0.5,Math.random() * this.wander - this.wander * 0.5);
            _loc17_.Multiply(param1.GetMass());
            param1.ApplyForce(_loc17_,bodyCenter);
         }
         if(this.value > 3)
         {
            this.vomit();
         }
      }
      
      private function vomit() : void
      {
         var _loc4_:b2Vec2 = null;
         var _loc1_:b2Vec2 = BoxUtils.rotateVec(ud.triggerPos,bodyAngle);
         _loc1_.Add(pixelCenter);
         var _loc2_:String = O.names[int(Math.random() * O.names.length)];
         var _loc3_:b2Body = GameState.objects.spawnObject(_loc2_,_loc1_.x,_loc1_.y,bodyAngle * Vars.toDegrees,ud.flipped,true);
         if(_loc3_)
         {
            this.value = 0;
            _loc4_ = _loc3_.GetPosition().Copy();
            _loc4_.Subtract(bodyCenter);
            _loc4_.Multiply(_loc3_.GetMass() * 10);
            ud.ignored.push(_loc3_);
            _loc3_.ApplyImpulse(_loc4_,_loc3_.GetWorldCenter());
            Body.Ghost(_loc3_);
         }
      }
      
      override public function OnLoadCustom() : void
      {
         if(ud.triggerCustom)
         {
            this.value = int(ud.triggerCustom);
         }
      }
   }
}

