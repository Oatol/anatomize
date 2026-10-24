package
{
   import Box2D.Dynamics.b2Body;
   
   public class TriggerSystem
   {
      
      public function TriggerSystem()
      {
         super();
      }
      
      public function action(param1:b2Body) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_ || !_loc2_.trigger)
         {
            return;
         }
         this.trigger(param1);
      }
      
      private function trigger(param1:b2Body) : void
      {
         var _loc3_:b2Body = null;
         var _loc4_:userData = null;
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.triggerLinkedInstead)
         {
            for each(_loc3_ in _loc2_.connected)
            {
               _loc4_ = userData(_loc3_.GetUserData());
               if(_loc4_.trigger)
               {
                  _loc4_.trigger.trigger(_loc3_,_loc4_);
                  _loc2_.triggered = false;
               }
            }
            return;
         }
         if(_loc2_.trigger)
         {
            _loc2_.trigger.trigger(param1,_loc2_);
            if(_loc2_.triggerLinkedAsWell)
            {
               for each(_loc3_ in _loc2_.connected)
               {
                  _loc4_ = userData(_loc3_.GetUserData());
                  if(_loc4_.trigger)
                  {
                     _loc4_.trigger.trigger(_loc3_,_loc4_);
                  }
               }
            }
         }
      }
   }
}

