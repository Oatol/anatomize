package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class TimerDelete extends Trigger
   {
      
      public function TimerDelete()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc8_:b2Body = null;
         var _loc9_:userData = null;
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         var _loc3_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(-4 * param2.size,-4 * param2.size),bodyAngle);
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(4 * param2.size,4 * param2.size),bodyAngle);
         var _loc5_:Number = 1 - param2.triggerDuration / param2.originalTriggerDuration;
         var _loc6_:Sprite = new Sprite();
         var _loc7_:uint = BoxUtils.getSkinColour(param2.skin,"660B0B");
         if(_loc7_ == 16711935)
         {
            _loc7_ = 6687499;
         }
         _loc6_.graphics.lineStyle(2,_loc7_);
         _loc6_.graphics.drawCircle(GraphicUtils.camX(pixelCenter.x) + camPos.x,GraphicUtils.camY(pixelCenter.y) + camPos.y,8 * param2.size * (1 - _loc5_) * Main.instance.cam.scaleX);
         Main.instance.particlesBMD.draw(_loc6_);
         if(param2.triggerDuration <= 0)
         {
            for each(_loc8_ in param2.connected)
            {
               _loc9_ = userData(_loc8_.GetUserData());
               _loc9_.dead = true;
            }
            param2.triggerDuration = param2.originalTriggerDuration;
         }
      }
   }
}

