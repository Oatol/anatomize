package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class TimeScatter extends Trigger
   {
      
      public function TimeScatter()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(triggerState != 1)
         {
            return;
         }
         --ud.triggerDuration;
         if(ud.triggerDuration <= 0)
         {
            this.ResetTime();
         }
      }
      
      override public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
         super.OnSharp(param1);
         if(param1.IsStatic())
         {
            return;
         }
         if(param2 < 50)
         {
            return;
         }
         TimeLord.speed = 0.1 + Math.random() * 2;
         ud.triggered = true;
         ud.triggerState = 1;
         ud.triggerDuration = ud.originalTriggerDuration;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param1.IsStatic())
         {
            this.ResetTime();
         }
         return true;
      }
      
      internal function ResetTime() : void
      {
         TimeLord.speed = 1;
         ud.dead = true;
      }
      
      override public function OnDelete() : void
      {
         this.ResetTime();
         super.OnDelete();
      }
   }
}

