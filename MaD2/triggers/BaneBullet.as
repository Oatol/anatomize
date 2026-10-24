package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class BaneBullet extends GenericBullet
   {
      
      public function BaneBullet()
      {
         super("moss");
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         ud.dead = true;
         var _loc7_:userData = param1.GetUserData() as userData;
         if(!_loc7_.alive)
         {
            return false;
         }
         if(_loc7_.resistBlighting)
         {
            return false;
         }
         if(_loc7_.trigger is BaneBullet)
         {
            return false;
         }
         Body.BlightEffect(param1,param5);
         if(_loc7_.trigger is ToxinMelt)
         {
            return false;
         }
         Body.Blight(param1,Math.random() * Math.random() * 320 + 60);
         return true;
      }
   }
}

