package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Brimstone extends Trigger
   {
      
      public function Brimstone()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc9_:Number = NaN;
         var _loc10_:b2Vec2 = null;
         var _loc11_:b2Vec2 = null;
         var _loc12_:int = 0;
         var _loc13_:b2Vec2 = null;
         var _loc14_:Vector.<MyLittleParticle> = null;
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = new b2Vec2(0,-15 * param2.size);
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc5_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
         var _loc6_:String = "fire3";
         var _loc7_:String = "smoke";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc6_ = param2.pfx.getParticle();
            _loc7_ = param2.pfx.getParticle();
         }
         if(Math.random() > 0.9)
         {
            _loc9_ = Math.random() * 80 - 40;
            _loc10_ = new b2Vec2(Math.sin(_loc9_),_loc9_);
            _loc11_ = BoxUtils.rotateVec(_loc10_,bodyAngle);
            GameState.particles.addParticles(_loc5_.x + _loc11_.x * param2.size,_loc5_.y + _loc11_.y * param2.size,1,_loc7_,bodyVel.x * 0.1,bodyVel.y * 0.1,0,0);
         }
         var _loc8_:Number = Math.abs(param1.GetAngularVelocity());
         if(_loc8_ > 1)
         {
            param2.triggerRadius = _loc8_ * 10;
            if(param2.triggerRadius > 200 * param2.size)
            {
               param2.triggerRadius = 200 * param2.size;
            }
            if(param2.triggerRadius < 20)
            {
               param2.triggerRadius = 0;
            }
         }
         if(param2.triggerRadius > 10)
         {
            this.Effect();
            if(_loc8_ > 5)
            {
               _loc8_ = 5;
            }
            _loc12_ = 0;
            while(_loc12_ < _loc8_ * 4)
            {
               _loc13_ = GeneralUtils.pointOnCircle(_loc5_.x,_loc5_.y,triggerRadius,Math.random() * 360);
               _loc14_ = GameState.particles.addParticles(_loc13_.x,_loc13_.y,1,_loc6_,(_loc5_.x - _loc13_.x) * -0.1 + bodyVel.x * 0.1,(_loc5_.y - _loc13_.y) * -0.1 + bodyVel.y * 0.1,1,1);
               if((Boolean(_loc14_)) && Boolean(_loc14_[0]))
               {
                  _loc14_[0].friction = 0.8;
                  _loc14_[0].health = 4;
                  _loc14_[0].wanderX = 0;
                  _loc14_[0].wanderY = 0;
               }
               _loc12_++;
            }
         }
      }
      
      public function Effect() : void
      {
         var _loc5_:userData = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:Number = NaN;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Vector.<MyLittleParticle> = null;
         var _loc1_:b2Vec2 = pixelCenter;
         var _loc2_:Number = ud.triggerRadius * ud.size;
         var _loc3_:Array = Body.GetAroundPoint(_loc1_,_loc2_,_loc2_,false);
         var _loc4_:b2Body = _loc3_[Math.random() * _loc3_.length >> 0];
         if((Boolean(_loc4_)) && _loc4_ != body)
         {
            _loc5_ = userData(_loc4_.GetUserData());
            new FierySword().Effect(_loc4_);
            Body.Damage(_loc4_,Math.random() * 32 + 16,new b2Vec2(),new b2Vec2(),new b2Vec2(),false);
            _loc5_.temperature += 10;
            _loc6_ = GeneralUtils.pointOnCircle(_loc1_.x,_loc1_.y,20 * ud.size,Math.random() * 360);
            _loc7_ = _loc4_.GetWorldCenter().Copy();
            _loc7_.Multiply(Physics.scale);
            _loc8_ = (_loc7_.y - _loc1_.y) / (_loc7_.x - _loc1_.x);
            _loc9_ = "fire3";
            if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
            {
               _loc9_ = ud.pfx.getParticle();
            }
            _loc10_ = 0;
            while(_loc10_ < 20)
            {
               _loc11_ = _loc6_.x + _loc10_ / 20 * (_loc7_.x - _loc6_.x);
               _loc12_ = _loc6_.y + _loc8_ * (_loc11_ - _loc6_.x);
               _loc13_ = GameState.particles.addParticles(_loc11_,_loc12_,1,_loc9_,(-_loc6_.x + _loc11_) * 0.05,(-_loc6_.y + _loc12_) * 0.05,2,2);
               if((Boolean(_loc13_)) && Boolean(_loc13_[0]))
               {
                  _loc13_[0].health = 10;
               }
               _loc10_++;
            }
         }
      }
   }
}

