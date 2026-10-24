package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DelayedRocket extends Rocket
   {
      
      public function DelayedRocket(param1:String = "fire3", param2:Number = 0.5)
      {
         super(param1,param2);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration < 0)
         {
            super.trigger(param1,param2);
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         ud.dead = true;
         return true;
      }
   }
}

