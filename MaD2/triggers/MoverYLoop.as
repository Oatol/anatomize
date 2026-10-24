package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class MoverYLoop extends Mover
   {
      
      internal var dir:int = 1;
      
      public function MoverYLoop()
      {
         super();
         yvel = 1;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         param2.triggerDuration -= TimeLord.speed * this.dir;
         if(param2.triggerDuration < -param2.originalTriggerDuration || param2.triggerDuration > param2.originalTriggerDuration)
         {
            this.dir *= -1;
         }
         yvel = param2.triggerDuration;
         super.trigger(param1,param2);
      }
   }
}

