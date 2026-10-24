package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class WeatherDeviceSnow extends Trigger
   {
      
      public function WeatherDeviceSnow()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:Array = null;
         var _loc6_:b2Body = null;
         var _loc7_:userData = null;
         super.trigger(param1,param2);
         var _loc3_:String = "snow";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc3_ = param2.pfx.getParticle();
         }
         var _loc4_:b2Vec2 = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,param2.triggerRadius * Math.random(),Math.random() * 360);
         GameState.particles.addParticles(_loc4_.x,_loc4_.y,1,_loc3_,0,0,0.1,0.1);
         if(param2.temperature > 0)
         {
            param2.temperature -= TimeLord.speed * 0.1;
         }
         else
         {
            _loc5_ = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
            for each(_loc6_ in _loc5_)
            {
               _loc7_ = userData(_loc6_.GetUserData());
               if(_loc7_.temperature > 0)
               {
                  _loc7_.temperature -= 0.5;
               }
               else if(_loc7_.temperature > -10)
               {
                  Body.Freeze(_loc6_,-20);
               }
            }
         }
      }
   }
}

