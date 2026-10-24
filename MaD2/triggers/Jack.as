package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Jack extends Trigger
   {
      
      public function Jack()
      {
         super();
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(Math.random() > 0.9)
         {
            _loc7_.trigger = new Transmute();
            _loc7_.triggered = true;
            _loc7_.triggerLock = false;
         }
         return true;
      }
   }
}

