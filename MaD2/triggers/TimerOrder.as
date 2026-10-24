package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class TimerOrder extends Trigger
   {
      
      internal var ind:int = 0;
      
      public function TimerOrder()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         var _loc3_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(-4 * param2.size,1 * param2.size),bodyAngle);
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(-4 * param2.size + 8 * param2.size * (param2.triggerDuration / param2.originalTriggerDuration),1 * param2.size),bodyAngle);
         var _loc5_:Sprite = new Sprite();
         if(param2.triggerState == 1)
         {
            _loc5_.graphics.lineStyle(2,15658734);
         }
         else
         {
            _loc5_.graphics.lineStyle(2,1118481);
         }
         _loc5_.graphics.drawCircle(GraphicUtils.camX(pixelCenter.x) + camPos.x,GraphicUtils.camY(pixelCenter.y) + camPos.y,4 * param2.size * (param2.triggerDuration / param2.originalTriggerDuration) * Main.instance.cam.scaleX);
         Main.instance.particlesBMD.draw(_loc5_);
         if(param2.triggerDuration <= 0)
         {
            param2.triggerDuration = param2.originalTriggerDuration;
            param2.connected[this.ind].GetUserData().triggered = param2.triggerState == 1;
            ++this.ind;
            if(this.ind >= param2.connected.length)
            {
               this.ind = 0;
            }
         }
      }
   }
}

