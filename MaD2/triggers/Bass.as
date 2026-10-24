package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Bass extends Trigger
   {
      
      public function Bass()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(param2.alive)
         {
            param2.triggerDuration -= TimeLord.speed;
            if(triggerDuration < 0)
            {
               param2.triggered = false;
               Body.Disintegrate(param1,"blood",param2.health > 100 ? 100 : int(param2.health),triggerPos.x * 0.02 + 0.3,triggerPos.y * 0.02 + 0.3);
            }
            else
            {
               param2.graphic.scaleX = 1 + (Math.random() * 0.4 - 0.2);
               param2.graphic.scaleY = 1 + (Math.random() * 0.4 - 0.2);
            }
         }
      }
   }
}

