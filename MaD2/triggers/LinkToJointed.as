package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class LinkToJointed extends Trigger
   {
      
      public function LinkToJointed()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Body = null;
         var _loc6_:b2Body = null;
         var _loc7_:userData = null;
         var _loc3_:Array = Joints.GetJoints(param1);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = Joints.Other(_loc3_[_loc4_],param1);
            if(_loc5_)
            {
               for each(_loc6_ in param2.connected)
               {
                  _loc7_ = userData(_loc6_.GetUserData());
                  _loc7_.connect(_loc5_);
               }
            }
            _loc4_++;
         }
         param2.triggered = false;
      }
   }
}

