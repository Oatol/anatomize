package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class GenericCube extends Trigger
   {
      
      public function GenericCube()
      {
         super();
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param1.IsStatic())
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(!_loc7_ || _loc7_.name == "genericcube")
         {
            return false;
         }
         _loc7_.trigger = new Transmute("genericcube");
         _loc7_.triggered = true;
         return true;
      }
   }
}

