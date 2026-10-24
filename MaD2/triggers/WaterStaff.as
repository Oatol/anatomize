package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class WaterStaff extends Trigger
   {
      
      public function WaterStaff()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc8_:b2Vec2 = null;
         var _loc9_:b2Body = null;
         var _loc10_:String = null;
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = param2.triggerPos.Copy();
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc5_:Number = param2.triggerRadius * param2.size;
         var _loc6_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
         if(triggerState == -1)
         {
            _loc5_ *= 0.25;
            param2.triggered = false;
         }
         var _loc7_:Array = Body.GetAroundPoint(_loc6_,_loc5_,_loc5_,false);
         for each(_loc9_ in _loc7_)
         {
            _loc8_ = _loc9_.GetPosition().Copy();
            _loc8_.Multiply(Physics.scale);
            _loc8_.Add(new b2Vec2(Math.random() * 50 - 25,Math.random() * 50 - 25));
            Body.Wet(_loc9_,_loc8_);
         }
         _loc10_ = "water";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc10_ = param2.pfx.getParticle();
         }
         var _loc11_:b2Vec2 = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,_loc5_,Math.random() * 360);
         GameState.particles.addParticles(_loc11_.x,_loc11_.y,1,_loc10_,(_loc6_.x - _loc11_.x) * 0.01 + bodyVel.x * 0.1,(_loc6_.y - _loc11_.y) * 0.01 + bodyVel.y * 0.1,1,1);
         var _loc12_:b2Vec2 = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,0.2 * _loc5_,Math.random() * 360);
         GameState.particles.addParticles(_loc12_.x,_loc12_.y,1,_loc10_,(_loc6_.x - _loc12_.x) * -0.1 + bodyVel.x * 0.1,(_loc6_.y - _loc12_.y) * -0.1 + bodyVel.y * 0.1,1,1);
         if(triggerState == -1)
         {
            param2.triggerState = 0;
         }
      }
   }
}

