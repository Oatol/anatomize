package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Shrimp extends Wander
   {
      
      public function Shrimp()
      {
         super(Math.random() * 600 + 600);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(Math.random() > 0.9)
         {
            ud.trigger = new DisintegratePowder(10,1);
            ud.triggered = true;
         }
         if(userData(param1.GetUserData()).alive)
         {
            Body.Bite(param1);
         }
         return true;
      }
   }
}

