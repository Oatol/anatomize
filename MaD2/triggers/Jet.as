package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Jet extends Trigger
   {
      
      public function Jet()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         param1.WakeUp();
         param1.ApplyForce(new b2Vec2(Math.sin(bodyAngle) * param1.GetMass() * triggerForce,-Math.cos(bodyAngle) * param1.GetMass() * triggerForce),bodyCenter);
      }
   }
}

