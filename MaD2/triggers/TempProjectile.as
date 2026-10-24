package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class TempProjectile extends Trigger
   {
      
      private var duration:Number;
      
      private var particles:Number;
      
      private var particle:String;
      
      public function TempProjectile(param1:Number = 20, param2:Number = 10, param3:String = "")
      {
         super();
         this.duration = param1;
         this.particles = param2;
         this.particle = param3;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         this.duration -= TimeLord.speed;
         if(this.duration <= 0)
         {
            if(this.particle != "")
            {
               ud.trigger = new Disintegrate(this.particle,this.particles,0.5);
            }
            else
            {
               ud.trigger = new DisintegratePowder(this.particles,0.5);
            }
            ud.triggered = true;
         }
      }
   }
}

