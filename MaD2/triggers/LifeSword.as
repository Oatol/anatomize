package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class LifeSword extends Trigger
   {
      
      public function LifeSword()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc6_:String = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:b2Vec2 = null;
         var _loc10_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(triggerDuration > 0)
         {
            --param2.triggerDuration;
         }
         var _loc3_:b2Vec2 = new b2Vec2(0,-10 * param2.size);
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc5_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
         if(triggerState % 32 == 0)
         {
            _loc6_ = "heal";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc6_ = param2.pfx.getParticle();
            }
            if(bodyVel.Length() < 1)
            {
               _loc7_ = new b2Vec2(Math.sin(triggerState * 0.02) * 8,triggerState * 0.1 - 24);
               _loc8_ = new b2Vec2(Math.sin(-triggerState * 0.02) * 8,80 - triggerState * 0.1 - 24);
               _loc9_ = BoxUtils.rotateVec(_loc7_,bodyAngle);
               _loc10_ = BoxUtils.rotateVec(_loc8_,bodyAngle);
               GameState.particles.addParticles(_loc5_.x - _loc9_.x * param2.size,_loc5_.y - _loc9_.y * param2.size,1,_loc6_,bodyVel.x * 0.1,bodyVel.y * 0.1,0,0);
               GameState.particles.addParticles(_loc5_.x - _loc10_.x * param2.size,_loc5_.y - _loc10_.y * param2.size,1,_loc6_,bodyVel.x * 0.1,bodyVel.y * 0.1,0,0);
            }
            else
            {
               _loc7_ = new b2Vec2(Math.random() * 20 - 10,Math.random() * 90 - 30);
               _loc9_ = BoxUtils.rotateVec(_loc7_,bodyAngle);
               GameState.particles.addParticles(_loc5_.x - _loc9_.x * param2.size,_loc5_.y - _loc9_.y * param2.size,1,_loc6_,bodyVel.x * 0.1,bodyVel.y * 0.1,0,0);
            }
         }
         param2.triggerState += 4;
         if(param2.triggerState > 800)
         {
            param2.triggerState = 0;
         }
      }
   }
}

