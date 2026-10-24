package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class StunGun extends Trigger
   {
      
      public function StunGun()
      {
         super();
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc7_:userData = null;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(!ud.triggered)
         {
            return true;
         }
         if(param1.IsStatic())
         {
            return true;
         }
         if(param3.name == ud.triggerColour)
         {
            _loc7_ = userData(param1.GetUserData());
            _loc7_.trigger = new Electrified();
            _loc7_.triggered = true;
            if(ud.originalTriggerDuration)
            {
               _loc7_.triggerDuration = ud.originalTriggerDuration;
            }
            else
            {
               _loc7_.triggerDuration = 240;
            }
         }
         return true;
      }
   }
}

