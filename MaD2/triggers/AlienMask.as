package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class AlienMask extends ArmourHelmet
   {
      
      public function AlienMask(param1:b2Body, param2:Number, param3:Number = 0.1, param4:Number = 0.5, param5:Number = 100)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(userData(param1.GetUserData()).name.indexOf("antialienhat") != -1)
         {
            ud.trigger = new DisintegratePowder(50,2,true);
            ud.triggerLock = false;
            ud.triggered = true;
         }
         return true;
      }
   }
}

