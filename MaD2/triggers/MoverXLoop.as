package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class MoverXLoop extends Mover
   {
      
      internal var dir:int = 1;
      
      public function MoverXLoop()
      {
         super();
         xvel = 1;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         param2.triggerDuration -= TimeLord.speed * this.dir;
         if(param2.triggerDuration < -param2.originalTriggerDuration || param2.triggerDuration > param2.originalTriggerDuration)
         {
            this.dir *= -1;
         }
         xvel = param2.triggerDuration;
         super.trigger(param1,param2);
      }
   }
}

