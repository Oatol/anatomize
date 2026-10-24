package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class GuitarPick extends Trigger
   {
      
      public function GuitarPick()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:userData = null;
         var _loc4_:b2Body = null;
         var _loc5_:int = 0;
         super.trigger(param1,param2);
         if(ud.connected.length == 0)
         {
            ud.triggered = false;
            return;
         }
         for each(_loc4_ in ud.connected)
         {
            _loc3_ = userData(_loc4_.GetUserData());
            if(Boolean(_loc3_) && Boolean(_loc3_.trigger) && _loc3_.trigger is Guitar)
            {
               _loc5_ = ud.triggerForce;
               if(_loc5_ < 1)
               {
                  _loc5_ = 1;
               }
               if(_loc5_ > 6)
               {
                  _loc5_ = 6;
               }
               Guitar(_loc3_.trigger).Play(_loc5_);
               _loc3_.triggered = true;
            }
         }
         ud.triggered = false;
      }
   }
}

