package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class LeafBlower extends Trigger
   {
      
      public function LeafBlower()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc14_:b2Body = null;
         var _loc15_:userData = null;
         super.trigger(param1,param2);
         var _loc3_:Number = bodyCenter.x * Physics.scale;
         var _loc4_:Number = bodyCenter.y * Physics.scale;
         var _loc5_:int = 1;
         if(param1.GetUserData().flipped)
         {
            _loc5_ = -1;
         }
         var _loc6_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(triggerPos.x * param2.size * _loc5_,triggerPos.y * param2.size),bodyAngle);
         var _loc7_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2((triggerPos.x + 1) * param2.size * _loc5_,triggerPos.y * param2.size),bodyAngle);
         var _loc8_:b2Vec2 = new b2Vec2(_loc3_ + _loc6_.x,_loc4_ + _loc6_.y);
         var _loc9_:b2Vec2 = new b2Vec2(_loc3_ + _loc7_.x,_loc4_ + _loc7_.y);
         var _loc10_:Array = GameState.cutter.CustomRaycast(_loc8_,2 * param2.triggerForce * param2.size,_loc9_,false);
         var _loc11_:Number = bodyAngle + Vars.PI + Math.random() * 0.5 - 0.25;
         var _loc12_:Number = -triggerForce * 0.02;
         if(_loc12_ > 30)
         {
            _loc12_ = 30;
         }
         if(_loc12_ < -30)
         {
            _loc12_ = -30;
         }
         var _loc13_:String = "air";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc13_ = param2.pfx.getParticle();
         }
         GameState.particles.addParticles(_loc8_.x,_loc8_.y,1,_loc13_,_loc12_ * Math.cos(_loc11_) * param2.size * _loc5_,_loc12_ * Math.sin(_loc11_) * param2.size * _loc5_,Math.random() * Math.cos(_loc11_),Math.random() * Math.sin(_loc11_));
         if(_loc10_[0])
         {
            _loc14_ = b2Body(_loc10_[0]);
            if(_loc14_ == param1)
            {
               return;
            }
            _loc14_.WakeUp();
            _loc15_ = userData(_loc14_.GetUserData());
            _loc14_.ApplyForce(new b2Vec2(-triggerForce * Math.cos(_loc11_) * param2.size * _loc5_,-triggerForce * Math.sin(_loc11_) * param2.size * _loc5_),b2Vec2(_loc10_[1]));
         }
      }
   }
}

