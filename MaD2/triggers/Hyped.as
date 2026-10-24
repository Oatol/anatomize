package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Hyped extends Trigger
   {
      
      internal var force:Number;
      
      public function Hyped(param1:Number = 100)
      {
         super();
         temporary = true;
         this.force = param1;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(param2.temperature < 0)
         {
            return;
         }
         if(param1.IsStatic() || !param2.saveable)
         {
            param2.triggered = false;
            return;
         }
         param1.WakeUp();
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration > 0)
         {
            if(param2.alive)
            {
               param2.stabilise = false;
            }
            if(TimeLord.speed == 1 || Math.random() * TimeLord.speed < TimeLord.speed * 0.25)
            {
               if(param2.alive)
               {
                  param2.health -= 0.2;
               }
               param1.SetLinearVelocity(new b2Vec2(bodyVel.x * 0.2,bodyVel.y * 0.2));
               _loc3_ = new b2Vec2(Math.random() - 0.5,Math.random() - 0.5);
               _loc3_.Multiply(100 * this.force * param1.GetMass());
               param1.ApplyForce(_loc3_,bodyCenter);
            }
            return;
         }
         if(param2.alive)
         {
            param2.stabilise = true;
         }
         param2.triggerLock = false;
         param2.trigger.reset();
         if(param2.trigger is Equip)
         {
            param2.trigger = new Unequip();
         }
         if(param2.trigger)
         {
            param2.triggered = true;
         }
         param2.graphic.scaleX = 1;
         param2.graphic.scaleY = 1;
      }
   }
}

