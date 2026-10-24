package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Platform extends Door
   {
      
      public function Platform()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration <= 0)
         {
            super.trigger(param1,param2);
            param2.triggerDuration = param2.originalTriggerDuration;
            if(param2.group < 999)
            {
               param2.triggerLock = false;
               param2.triggered = false;
               param2.triggerLock = true;
            }
            else
            {
               param1.SetXForm(new b2Vec2(-10,-10),bodyAngle);
               param1.SetXForm(bodyCenter,bodyAngle);
            }
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param3.name == "5b9d19")
         {
            ud.triggerLock = false;
            ud.triggered = true;
            ud.triggerLock = true;
         }
         return true;
      }
   }
}

