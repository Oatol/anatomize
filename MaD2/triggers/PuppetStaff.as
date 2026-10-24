package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PuppetStaff extends Trigger
   {
      
      public function PuppetStaff()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:userData = null;
         var _loc5_:b2Body = null;
         super.trigger(param1,param2);
         var _loc4_:Vector.<b2Body> = param2.connected;
         if(bodyVel.Length() > 10)
         {
            for each(_loc5_ in _loc4_)
            {
               _loc5_.WakeUp();
               _loc5_.SetLinearVelocity(new b2Vec2(bodyVel.x * param2.triggerForce * 0.01,bodyVel.y * param2.triggerForce * 0.01));
            }
         }
         if(param1.GetAngularVelocity() > 5)
         {
            for each(_loc5_ in _loc4_)
            {
               _loc5_.WakeUp();
               _loc5_.SetAngularVelocity(param1.GetAngularVelocity() * param2.triggerForce * 0.05);
            }
         }
      }
   }
}

