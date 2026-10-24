package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class MemoryStick extends Trigger
   {
      
      protected var drone:b2Body;
      
      public function MemoryStick()
      {
         super();
      }
      
      override public function OnJoint(param1:b2Body, param2:String) : Boolean
      {
         if(!super.OnJoint(param1,param2))
         {
            return false;
         }
         var _loc3_:userData = userData(param1.GetUserData());
         if(!_loc3_ || !_loc3_.trigger)
         {
            return false;
         }
         if(_loc3_.trigger is DroneSpeaker)
         {
            this.drone = param1;
         }
         return true;
      }
      
      override public function OnDelete() : void
      {
         var _loc1_:userData = null;
         super.OnDelete();
         if(this.drone)
         {
            _loc1_ = userData(this.drone.GetUserData());
            if(Boolean(_loc1_) && !_loc1_.dead)
            {
               _loc1_.trigger = new DroneSpeaker();
            }
         }
      }
   }
}

