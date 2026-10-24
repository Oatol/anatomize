package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class SanguineEdge extends Trigger
   {
      
      public function SanguineEdge()
      {
         super();
      }
      
      override public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
         var _loc4_:userData = null;
         var _loc5_:b2Body = null;
         super.OnSharp(param1);
         var _loc3_:Array = BoxUtils.selectCompound(param1);
         for each(_loc5_ in _loc3_)
         {
            _loc4_ = userData(_loc5_.GetUserData());
            if(_loc4_)
            {
               if(_loc4_.alive)
               {
                  Body.Exsanguinate(_loc5_);
               }
            }
         }
      }
   }
}

