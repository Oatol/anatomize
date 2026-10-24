package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Banhammer extends Trigger
   {
      
      public function Banhammer()
      {
         super();
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc8_:b2Body = null;
         var _loc9_:userData = null;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(!param3.sticky)
         {
            return false;
         }
         var _loc7_:Array = BoxUtils.selectCompound(param1);
         for each(_loc8_ in _loc7_)
         {
            _loc9_ = userData(_loc8_.GetUserData());
            if(_loc9_)
            {
               _loc9_.trigger = new Disintegrate("error",10,20);
               _loc9_.triggerLock = false;
               _loc9_.triggered = true;
            }
         }
         return true;
      }
   }
}

