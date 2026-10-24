package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Stasis extends Trigger
   {
      
      internal var duration:Number;
      
      public function Stasis(param1:Number)
      {
         super();
         temporary = true;
         this.duration = param1;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         this.duration -= TimeLord.speed;
         if(this.duration <= 0)
         {
            param2.trigger.reset();
            param1.WakeUp();
            return;
         }
         param1.SetLinearVelocity(new b2Vec2(-Vars.wind * 0.02,-Vars.gravity * 0.02));
         BoxUtils.randomParticlesOnBody(param1,"forcefield");
      }
   }
}

