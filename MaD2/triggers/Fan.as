package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Fan extends Trigger
   {
      
      public function Fan()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc6_:int = 0;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:b2Vec2 = null;
         var _loc10_:b2Vec2 = null;
         var _loc11_:Array = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:String = null;
         var _loc15_:b2Body = null;
         var _loc16_:userData = null;
         super.trigger(param1,param2);
         var _loc3_:Number = bodyCenter.x * Physics.scale;
         var _loc4_:Number = bodyCenter.y * Physics.scale;
         var _loc5_:int = 0;
         while(_loc5_ < 4)
         {
            _loc6_ = 1;
            if(param1.GetUserData().flipped)
            {
               _loc6_ = -1;
            }
            _loc7_ = BoxUtils.rotateVec(new b2Vec2(15 * param2.size * _loc6_,(-40 + 18 * _loc5_) * param2.size),bodyAngle);
            _loc8_ = BoxUtils.rotateVec(new b2Vec2(25 * param2.size * _loc6_,(-40 + 18 * _loc5_) * param2.size),bodyAngle);
            _loc9_ = new b2Vec2(_loc3_ + _loc7_.x,_loc4_ + _loc7_.y);
            _loc10_ = new b2Vec2(_loc3_ + _loc8_.x,_loc4_ + _loc8_.y);
            _loc11_ = GameState.cutter.CustomRaycast(_loc9_,200 * param2.size,_loc10_,false);
            _loc12_ = bodyAngle + Vars.PI;
            if(Math.random() > 0.9)
            {
               _loc13_ = -triggerForce * 0.1;
               if(_loc13_ > 30)
               {
                  _loc13_ = 30;
               }
               if(_loc13_ < -30)
               {
                  _loc13_ = -30;
               }
               _loc14_ = "poof";
               if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
               {
                  _loc14_ = param2.pfx.getParticle();
               }
               GameState.particles.addParticles(_loc9_.x,_loc9_.y,1,_loc14_,_loc13_ * Math.cos(_loc12_) * param2.size * _loc6_,_loc13_ * Math.sin(_loc12_) * param2.size * _loc6_,2 * Math.cos(_loc12_),2 * Math.sin(_loc12_));
            }
            if(_loc11_[0])
            {
               _loc15_ = b2Body(_loc11_[0]);
               if(_loc15_ == param1)
               {
                  return;
               }
               _loc15_.WakeUp();
               _loc16_ = userData(_loc15_.GetUserData());
               if(_loc16_.temperature > 37)
               {
                  _loc16_.temperature -= 0.1;
               }
               _loc15_.ApplyForce(new b2Vec2(-triggerForce * Math.cos(_loc12_) * param2.size * _loc6_,-triggerForce * Math.sin(_loc12_) * param2.size * _loc6_),b2Vec2(_loc11_[1]));
            }
            _loc5_++;
         }
      }
   }
}

