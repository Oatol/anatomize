package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class GhostBullet extends Trigger
   {
      
      public function GhostBullet()
      {
         super();
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc7_:userData = userData(param1.GetUserData());
         if(!_loc7_)
         {
            return false;
         }
         if(_loc7_.saveable || param1.IsStatic())
         {
            ud.dead = true;
         }
         if(!_loc7_.ghost)
         {
            return false;
         }
         _loc7_.trigger = new Disintegrate("bigSmoke",20,12);
         _loc7_.triggerLock = false;
         _loc7_.triggered = true;
         return true;
      }
   }
}

