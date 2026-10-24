package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class RendBullet extends GenericBullet
   {
      
      public function RendBullet()
      {
         super("slice");
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         ud.trigger = new RendGrenade();
         ud.triggerRadius = 100;
         ud.triggerForce = 5;
         ud.triggered = true;
         return true;
      }
   }
}

