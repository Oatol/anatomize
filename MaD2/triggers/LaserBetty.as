package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class LaserBetty extends Trigger
   {
      
      public function LaserBetty()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:b2Vec2 = null;
         var _loc10_:b2Vec2 = null;
         var _loc11_:Number = NaN;
         var _loc12_:String = null;
         var _loc13_:* = 0;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         super.trigger(param1,param2);
         if(param2.triggerPos.x == 0 && param2.triggerPos.y == 0)
         {
            param2.triggerPos = bodyCenter.Copy();
            param1.WakeUp();
            param1.ApplyImpulse(new b2Vec2(Math.sin(bodyAngle) * param1.GetMass() * 30,Math.cos(bodyAngle) * -param1.GetMass() * 30),bodyCenter);
         }
         else if(BoxUtils.vectorDist(bodyCenter,param2.triggerPos) > 75 + Math.random() * 50 - 25)
         {
            param2.dead = true;
            Body.Disintegrate(param1,"poof");
            _loc3_ = Math.cos(bodyAngle);
            _loc4_ = Math.sin(bodyAngle);
            _loc5_ = pixelCenter.x;
            _loc6_ = pixelCenter.y;
            _loc7_ = new b2Vec2(_loc5_ - 25 * param2.size * _loc3_,_loc6_ - 25 * param2.size * _loc4_);
            _loc8_ = new b2Vec2(_loc5_ + 25 * param2.size * _loc3_,_loc6_ + 25 * param2.size * _loc4_);
            _loc9_ = new b2Vec2(_loc5_ - 250 * param2.size * _loc3_,_loc6_ - 250 * param2.size * _loc4_);
            _loc10_ = new b2Vec2(_loc5_ + 250 * param2.size * _loc3_,_loc6_ + 250 * param2.size * _loc4_);
            GameState.madeby = "laser";
            GameState.cutter.Cut(1,_loc7_,_loc9_,800);
            GameState.madeby = "laser";
            GameState.cutter.Cut(1,_loc8_,_loc10_,800);
            _loc11_ = (_loc9_.y - _loc7_.y) / (_loc9_.x - _loc7_.x);
            _loc12_ = "laser";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc12_ = param2.pfx.getParticle();
            }
            _loc13_ = 50;
            while(_loc13_ > 0)
            {
               _loc14_ = _loc7_.x + _loc13_ / 50 * (_loc9_.x - _loc7_.x);
               _loc15_ = _loc7_.y + _loc11_ * (_loc14_ - _loc7_.x);
               GameState.particles.addParticles(_loc14_,_loc15_,1,_loc12_,(-_loc7_.x + _loc14_) * 0.5,(-_loc7_.y + _loc15_) * 0.5,0,0);
               _loc13_--;
            }
            _loc11_ = (_loc10_.y - _loc8_.y) / (_loc10_.x - _loc8_.x);
            _loc13_ = 50;
            while(_loc13_ > 0)
            {
               _loc14_ = _loc8_.x + _loc13_ / 50 * (_loc10_.x - _loc8_.x);
               _loc15_ = _loc8_.y + _loc11_ * (_loc14_ - _loc8_.x);
               GameState.particles.addParticles(_loc14_,_loc15_,1,_loc12_,(-_loc8_.x + _loc14_) * 0.5,(-_loc8_.y + _loc15_) * 0.5,0,0);
               _loc13_--;
            }
         }
      }
   }
}

