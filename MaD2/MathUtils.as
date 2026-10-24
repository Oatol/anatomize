package
{
   import Box2D.Common.Math.b2Vec2;
   
   public class MathUtils
   {
      
      public function MathUtils()
      {
         super();
      }
      
      public static function dotProduct(param1:b2Vec2, param2:b2Vec2) : Number
      {
         return param1.x * param2.x + param1.y * param2.y;
      }
   }
}

