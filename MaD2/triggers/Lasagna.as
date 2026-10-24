package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Lasagna extends PaintBrush
   {
      
      public function Lasagna()
      {
         super();
         minSize = 1;
         maxSize = 3;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc7_:String = ["e0bc62","bfba7d","871d16","871d16"][Math.random() * 3 >> 0];
         pcolour = uint("0x" + _loc7_);
         return super.OnCollision(param1,param2,param3,param4,param5,param6);
      }
   }
}

