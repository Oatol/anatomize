package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class GolfHole extends Trigger
   {
      
      public function GolfHole()
      {
         super();
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc7_:b2Body = null;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param1.IsStatic())
         {
            return false;
         }
         if(param3.name == "113254")
         {
            for each(_loc7_ in ud.connected)
            {
               userData(_loc7_.GetUserData()).triggered = true;
            }
         }
         return true;
      }
   }
}

