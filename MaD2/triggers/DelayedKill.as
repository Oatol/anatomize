package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class DelayedKill extends Trigger
   {
      
      internal var durr:Number;
      
      public function DelayedKill(param1:Number = 10)
      {
         super();
         this.durr = param1;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         this.durr -= TimeLord.speed;
         if(this.durr <= 0)
         {
            param2.dead = true;
         }
      }
   }
}

