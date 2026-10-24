package triggers
{
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class RelayTrigger extends Trigger
   {
      
      public var continuous:Boolean;
      
      public function RelayTrigger(param1:Boolean)
      {
         super();
         this.continuous = param1;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:int = 0;
         var _loc5_:b2Body = null;
         var _loc6_:userData = null;
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         var _loc3_:Sprite = new Sprite();
         _loc3_.graphics.lineStyle(2,param2.triggerState == 1 ? 4097883 : 11885403);
         _loc3_.graphics.drawCircle(GraphicUtils.camX(pixelCenter.x) + camPos.x,GraphicUtils.camY(pixelCenter.y) + camPos.y,4 * param2.size * Main.instance.cam.scaleX);
         Main.instance.particlesBMD.draw(_loc3_);
         if(param2.triggerState == 2 || param2.triggerState == -2)
         {
            if(param2.connected.length > 0)
            {
               _loc4_ = int(Math.random() * param2.connected.length);
               _loc5_ = param2.connected[_loc4_];
               userData(_loc5_.GetUserData()).triggered = param2.triggerState == 2;
            }
         }
         else
         {
            for each(_loc5_ in param2.connected)
            {
               _loc6_ = userData(_loc5_.GetUserData());
               _loc6_.triggered = param2.triggerState == 1;
            }
         }
         if(!this.continuous)
         {
            param2.triggered = false;
         }
      }
   }
}

