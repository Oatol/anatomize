package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class TimerItem extends Trigger
   {
      
      public function TimerItem()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc6_:b2Body = null;
         var _loc7_:userData = null;
         super.trigger(param1,param2);
         if(param2.triggerState == 4 && triggerDuration == param2.originalTriggerDuration)
         {
            for each(_loc6_ in param2.connected)
            {
               userData(_loc6_.GetUserData()).triggered = !userData(_loc6_.GetUserData()).triggered;
            }
         }
         param2.triggerDuration -= TimeLord.speed;
         var _loc3_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(-4 * param2.size,1 * param2.size),bodyAngle);
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(-4 * param2.size + 8 * param2.size * (param2.triggerDuration / param2.originalTriggerDuration),1 * param2.size),bodyAngle);
         var _loc5_:Sprite = new Sprite();
         if(param2.triggerState == 1)
         {
            _loc5_.graphics.lineStyle(2,1118481);
         }
         else
         {
            _loc5_.graphics.lineStyle(2,15658734);
         }
         _loc5_.graphics.drawCircle(GraphicUtils.camX(pixelCenter.x) + camPos.x,GraphicUtils.camY(pixelCenter.y) + camPos.y,4 * param2.size * (param2.triggerDuration / param2.originalTriggerDuration) * Main.instance.cam.scaleX);
         Main.instance.particlesBMD.draw(_loc5_);
         if(param2.triggerDuration <= 0)
         {
            for each(_loc6_ in param2.connected)
            {
               _loc7_ = userData(_loc6_.GetUserData());
               if(param2.triggerState == 2 || param2.triggerState == 4)
               {
                  _loc7_.triggered = !_loc7_.triggered;
               }
               else if(param2.triggerState == 3)
               {
                  _loc7_.triggered = false;
               }
               else if(param2.triggerState == -1)
               {
                  _loc7_.triggered = false;
               }
               else
               {
                  _loc7_.triggered = true;
               }
            }
            param2.triggerDuration = param2.originalTriggerDuration;
            if(param2.triggerState == 1 || param2.triggerState == -1 || param2.triggerState == 4)
            {
               param2.triggered = false;
            }
         }
      }
   }
}

