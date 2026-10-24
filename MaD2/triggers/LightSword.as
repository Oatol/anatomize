package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class LightSword extends Trigger
   {
      
      public function LightSword()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc7_:int = 0;
         var _loc8_:b2Vec2 = null;
         var _loc9_:b2Vec2 = null;
         var _loc10_:String = null;
         super.trigger(param1,param2);
         if(triggerDuration > 0)
         {
            --param2.triggerDuration;
         }
         var _loc3_:b2Vec2 = new b2Vec2(0,-10 * param2.size);
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc5_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
         var _loc6_:b2Vec2 = new b2Vec2(0,-1);
         _loc6_ = BoxUtils.rotateVec(_loc6_.Copy(),bodyAngle);
         if(triggerState != -1)
         {
            _loc7_ = 0;
            while(_loc7_ < 10)
            {
               _loc8_ = new b2Vec2(Math.random() * 8 - 4,Math.random() * 90 - 30);
               _loc9_ = BoxUtils.rotateVec(_loc8_,bodyAngle);
               _loc10_ = "light";
               if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
               {
                  _loc10_ = param2.pfx.getParticle();
               }
               GameState.particles.addParticles(_loc5_.x - _loc9_.x * param2.size,_loc5_.y - _loc9_.y * param2.size,1,_loc10_,_loc6_.x,_loc6_.y,0,0);
               _loc7_++;
            }
         }
      }
   }
}

