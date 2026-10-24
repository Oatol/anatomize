package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class CupidBullet extends GenericBullet
   {
      
      public function CupidBullet()
      {
         super("heart");
         trail = true;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(_loc7_.trigger is MagnetMagnet)
         {
            _loc7_.trigger = new Disintegrate("heart",100,10);
            _loc7_.triggered = true;
         }
         _loc7_.trigger = new MagnetMagnet();
         _loc7_.triggerRadius = ud.triggerRadius;
         _loc7_.triggerForce = ud.triggerForce;
         _loc7_.triggered = true;
         ud.trigger = new Disintegrate("heart",100,10);
         ud.triggered = true;
         return true;
      }
   }
}

