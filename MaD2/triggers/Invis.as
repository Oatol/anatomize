package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Invis extends Trigger
   {
      
      internal var dir:int;
      
      internal var speed:Number = 0.05;
      
      internal var targetAlpha:Number;
      
      public function Invis()
      {
         super();
         temporary = true;
         this.dir = -1;
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         this.targetAlpha = ud.graphic.alpha;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(!param2)
         {
            return;
         }
         param2.triggerLock = true;
         if(TimeLord.speed == 1 || Math.random() * TimeLord.speed < TimeLord.speed * 0.25)
         {
            if(this.dir == 0)
            {
               param2.triggerDuration -= TimeLord.speed;
               if(param2.triggerDuration > 0)
               {
                  return;
               }
               this.dir = 1;
            }
            if(!param2.graphic)
            {
               param2.triggerLock = false;
               param2.trigger.reset();
               return;
            }
            param2.graphic.alpha += this.dir * this.speed;
            if(this.dir < 0 && param2.graphic.alpha <= 0.1)
            {
               param2.graphic.alpha = 0;
               this.dir = 0;
            }
            if(param2.graphic.alpha >= this.targetAlpha)
            {
               param2.graphic.alpha = this.targetAlpha;
               this.dir = 0;
               param2.triggerLock = false;
               param2.trigger.reset();
            }
         }
      }
   }
}

