package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ShockStaff extends Trigger
   {
      
      public function ShockStaff()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc8_:b2Body = null;
         var _loc9_:String = null;
         var _loc12_:userData = null;
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
         for each(_loc8_ in _loc7_)
         {
            _loc12_ = userData(_loc8_.GetUserData());
            if(_loc12_.name != "shockstaff")
            {
               _loc12_.trigger = new Electrified();
               _loc12_.triggered = true;
               if(triggerState == -1)
               {
                  _loc12_.triggerDuration = 120;
               }
               else
               {
                  _loc12_.triggerDuration = 60;
               }
            }
         }
         _loc9_ = "shock";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc9_ = param2.pfx.getParticle();
         }
         var _loc10_:b2Vec2 = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,_loc5_,triggerDuration);
         var _loc11_:b2Vec2 = GeneralUtils.pointOnCircle(_loc6_.x,_loc6_.y,_loc5_ * Math.random() * 0.5,Math.random() * 360);
         GameState.particles.addParticles(_loc10_.x,_loc10_.y,1,_loc9_,(-_loc6_.x + _loc10_.x) * 0.01 + bodyVel.x * 0.1,(-_loc6_.y + _loc10_.y) * 0.01 + bodyVel.y * 0.1,2,2);
         GameState.particles.addParticles(_loc11_.x,_loc11_.y,1,_loc9_,(-_loc6_.x + _loc11_.x) * 0.05 + bodyVel.x * 0.1,(-_loc6_.y + _loc11_.y) * 0.05 + bodyVel.y * 0.1,2,2);
         param2.triggerDuration += 3 * TimeLord.speed;
         if(param2.triggerDuration > 360)
         {
            param2.triggerDuration = 0;
         }
         if(Math.random() > 0.9)
         {
            param2.triggerDuration += 15 * TimeLord.speed;
         }
         if(triggerState == -1)
         {
            param2.triggerState = 0;
         }
      }
   }
}

