package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class WeatherDeviceRain extends Trigger
   {
      
      public function WeatherDeviceRain()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,param2.size * (param2.triggerRadius * 0.3 + param2.triggerRadius * 0.7 * Math.random()),Math.random() * -180);
         var _loc4_:userData = Properties.objTemp("water");
         _loc4_.trigger = new Water();
         _loc4_.triggered = true;
         _loc4_.projectileName = "wat";
         var _loc5_:b2Body = Spawn.circle(_loc3_.x,_loc3_.y,2,_loc4_,[1,1,0]);
      }
   }
}

