package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class BleedBullet extends GenericBullet
   {
      
      public function BleedBullet()
      {
         super("blood");
         trail = false;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         ud.dead = true;
         if(!param1)
         {
            return false;
         }
         Body.Exsanguinate(param1);
         return true;
      }
   }
}

