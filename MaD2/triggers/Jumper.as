package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Jumper extends Trigger
   {
      
      public function Jumper()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration > 0)
         {
            return;
         }
         param2.triggered = false;
         param2.triggerDuration = param2.originalTriggerDuration;
         param1.WakeUp();
         var _loc3_:userData = userData(param1.GetUserData());
         var _loc4_:b2Vec2 = new b2Vec2(param2.triggerForce * 0.1,Math.abs(param2.triggerForce) * -0.5);
         _loc4_.Multiply(param1.GetMass());
         param1.ApplyImpulse(_loc4_,param1.GetWorldCenter());
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         ud.triggered = true;
         return super.OnCollision(param1,param2,param3,param4,param5,param6);
      }
   }
}

