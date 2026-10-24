package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ShockSword extends Trigger
   {
      
      public function ShockSword()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(triggerDuration > 0)
         {
            --param2.triggerDuration;
         }
         var _loc3_:b2Vec2 = new b2Vec2(0,-10 * param2.size);
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc5_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
         var _loc6_:String = "shock";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc6_ = param2.pfx.getParticle();
         }
         if(bodyVel.Length() < 60)
         {
            _loc7_ = new b2Vec2(Math.random() * 20 - 10,Math.random() * 90 - 30);
            _loc8_ = BoxUtils.rotateVec(_loc7_,bodyAngle);
            GameState.particles.addParticles(_loc5_.x - _loc8_.x * param2.size,_loc5_.y - _loc8_.y * param2.size,1,_loc6_,Math.random() * 10 - 5,Math.random() * 10 - 5,0,0);
         }
         else
         {
            _loc7_ = new b2Vec2(Math.random() * 20 - 10,Math.random() * 90 - 30);
            _loc8_ = BoxUtils.rotateVec(_loc7_,bodyAngle);
            GameState.particles.addParticles(_loc5_.x - _loc8_.x * param2.size,_loc5_.y - _loc8_.y * param2.size,1,_loc6_,bodyVel.x,bodyVel.y,0,0);
         }
      }
   }
}

