package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ZenithTorso extends ArmourTorso
   {
      
      public function ZenithTorso(param1:b2Body, param2:Number, param3:int = 0, param4:Number = 0.1, param5:Number = 0.5, param6:Number = 100)
      {
         super(param1,param2,param3,param4,param5,param6);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         super.OnCollision(param1,param2,param3,param4,param5,param6);
         var _loc7_:b2Vec2 = param1.GetLinearVelocity().Copy();
         _loc7_.Multiply(ud.triggerForce * 0.01);
         param1.SetLinearVelocity(_loc7_);
         return true;
      }
   }
}

