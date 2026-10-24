package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ParryingShield extends Trigger
   {
      
      public function ParryingShield()
      {
         super();
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(!param2.sharp)
         {
            return true;
         }
         param1.ApplyImpulse(new b2Vec2(-param6.x * ud.triggerForce * 0.01,-param6.y * ud.triggerForce * 0.01),param1.GetLocalPoint(param5));
         return false;
      }
   }
}

