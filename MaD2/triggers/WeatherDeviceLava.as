package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class WeatherDeviceLava extends Trigger
   {
      
      public function WeatherDeviceLava()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:Array = null;
         var _loc10_:b2Body = null;
         var _loc11_:userData = null;
         super.trigger(param1,param2);
         var _loc3_:String = "lava";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc3_ = param2.pfx.getParticle();
         }
         var _loc4_:String = "fire3";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc4_ = param2.pfx.getParticle();
         }
         var _loc5_:String = "ash";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc5_ = param2.pfx.getParticle();
         }
         if(Math.random() > 0.5)
         {
            _loc6_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,param2.triggerRadius * Math.random(),Math.random() * 360);
            GameState.particles.addParticles(_loc6_.x,_loc6_.y,1,_loc5_,0,0,0.1,0.1);
         }
         if(Math.random() > 0.7)
         {
            _loc6_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,param2.triggerRadius * Math.random(),Math.random() * 360);
            GameState.particles.addParticles(_loc6_.x,_loc6_.y,1,_loc4_,0,Math.random() * 5,0.1,0.1);
         }
         if(Math.random() > 0.95)
         {
            _loc7_ = new b2Vec2(0,-20);
            _loc7_ = BoxUtils.rotateVec(_loc7_,bodyAngle);
            _loc7_.Add(pixelCenter);
            _loc8_ = new b2Vec2(0,-5);
            _loc8_ = BoxUtils.rotateVec(_loc8_,bodyAngle);
            GameState.particles.addParticles(_loc7_.x,_loc7_.y,1,_loc3_,_loc8_.x,_loc8_.y,2,2);
         }
         if(param2.temperature < 0)
         {
            param2.temperature += TimeLord.speed * 0.1;
         }
         else
         {
            _loc9_ = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
            for each(_loc10_ in _loc9_)
            {
               _loc11_ = userData(_loc10_.GetUserData());
               _loc11_.temperature += 0.5;
            }
         }
      }
   }
}

