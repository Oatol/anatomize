package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class FaultyLighter extends Lighter
   {
      
      public function FaultyLighter(param1:b2Vec2, param2:b2Vec2, param3:String = "fire2")
      {
         v1 = param1;
         v2 = param2;
         papa = param3;
         super(v1,v2,papa);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         if(param2.triggerState == 0)
         {
            super.trigger(param1,param2);
            if(Math.random() > 0.99)
            {
               param2.triggered = false;
            }
            return;
         }
         param2.triggered = false;
      }
      
      override public function onTrigger() : void
      {
         super.onTrigger();
         if(Math.random() > 0.8)
         {
            ud.triggerState = 0;
            return;
         }
         ud.triggerState = 1;
         updateTriggerHelpers();
         var _loc1_:int = 1;
         if(ud.flipped)
         {
            _loc1_ = -1;
         }
         var _loc2_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(v1.x * _loc1_,v1.y),bodyAngle);
         var _loc3_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc2_.x * ud.size,pixelCenter.y + _loc2_.y * ud.size);
         var _loc4_:String = "sparkle";
         if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
         {
            _loc4_ = ud.pfx.getParticle();
         }
         var _loc5_:int = 0;
         while(_loc5_ < 5)
         {
            GameState.particles.addParticles(_loc3_.x,_loc3_.y,1,_loc4_,bodyVel.x * 0.1,bodyVel.y * 0.1 + 1,2,2);
            _loc5_++;
         }
      }
      
      override public function onUntrigger() : void
      {
         super.onUntrigger();
         ud.triggerState = -1;
      }
   }
}

