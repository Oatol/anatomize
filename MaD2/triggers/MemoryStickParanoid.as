package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class MemoryStickParanoid extends MemoryStick
   {
      
      public function MemoryStickParanoid()
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
            _loc3_.trigger = new DroneSpeakerParanoid();
         }
         return true;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc7_:userData = userData(param1.GetUserData());
         if(!_loc7_ || !_loc7_.trigger)
         {
            return false;
         }
         if(_loc7_.trigger is DroneSpeaker)
         {
            Joints.Weld("weldjoint",body,param1,bodyCenter);
         }
         return true;
      }
      
      override public function OnDelete() : void
      {
         var _loc1_:userData = null;
         super.OnDelete();
         if(drone)
         {
            _loc1_ = userData(drone.GetUserData());
            if(Boolean(_loc1_) && !_loc1_.dead)
            {
               _loc1_.trigger = new DroneSpeaker();
            }
         }
      }
   }
}

