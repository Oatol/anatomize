package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ModifyForce extends Trigger
   {
      
      private var multiX:Number;
      
      private var multiY:Number;
      
      public function ModifyForce(param1:Number, param2:Number)
      {
         super();
         this.multiX = param1;
         this.multiY = param2;
         temporary = true;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration <= 0)
         {
            param2.trigger.reset();
            return;
         }
         param1.ApplyForce(new b2Vec2(param1.GetMass() * this.multiX,param1.GetMass() * this.multiY),param1.GetWorldCenter());
      }
   }
}

