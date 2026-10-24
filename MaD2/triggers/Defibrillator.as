package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Defibrillator extends Trigger
   {
      
      public function Defibrillator()
      {
         super();
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc8_:Array = null;
         var _loc9_:b2Body = null;
         var _loc10_:userData = null;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(_loc7_.alive)
         {
            _loc8_ = BoxUtils.selectCompound(param1);
            for each(_loc9_ in _loc8_)
            {
               _loc10_ = userData(_loc9_.GetUserData());
               _loc10_.trigger = new Electrified();
               _loc10_.triggered = true;
               if(_loc10_.health < 0.6 * _loc10_.maxhealth)
               {
                  _loc10_.triggerDuration = 2;
                  _loc10_.health = 0.6 * _loc10_.maxhealth;
               }
               else if(_loc10_.trigger is Concussion)
               {
                  _loc10_.triggerDuration = 2;
               }
               else
               {
                  _loc10_.triggerDuration = 24;
               }
            }
         }
         return true;
      }
   }
}

