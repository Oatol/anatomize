package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class AdrenalineBullet extends GenericBullet
   {
      
      public function AdrenalineBullet()
      {
         super("fire3");
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         ud.dead = true;
         var _loc7_:userData = param1.GetUserData() as userData;
         if(_loc7_.resistAdrenaline)
         {
            return true;
         }
         if(_loc7_.trigger is AdrenalineBullet)
         {
            return false;
         }
         _loc7_.trigger = new Hyped(ud.triggerForce);
         _loc7_.triggerDuration = 120;
         _loc7_.triggered = true;
         return true;
      }
   }
}

