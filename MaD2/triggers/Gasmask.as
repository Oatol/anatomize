package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Gasmask extends ArmourHelmet
   {
      
      internal var done:Boolean = false;
      
      public function Gasmask(param1:b2Body, param2:Number, param3:Number = 0.1, param4:Number = 0.5, param5:Number = 100)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         ud.triggerLock = false;
         ud.triggered = true;
      }
      
      override public function OnJoint(param1:b2Body, param2:String) : Boolean
      {
         ud.triggerLock = false;
         ud.triggered = true;
         return super.OnJoint(param1,param2);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Array = null;
         var _loc4_:userData = null;
         var _loc5_:b2Body = null;
         super.trigger(param1,param2);
         if(this.done)
         {
            return;
         }
         if(!attachedBody)
         {
            ud.triggerLock = false;
            ud.triggered = true;
            return;
         }
         if(attachedBody)
         {
            _loc3_ = BoxUtils.selectCompound(attachedBody,false);
            for each(_loc5_ in _loc3_)
            {
               _loc4_ = userData(_loc5_.GetUserData());
               if(!(!_loc4_ || !_loc4_.alive))
               {
                  _loc4_.resistPoison = true;
               }
            }
            this.done = true;
         }
      }
      
      override public function OnDelete() : void
      {
         var _loc2_:userData = null;
         var _loc3_:b2Body = null;
         super.OnDelete();
         if(!attachedBody)
         {
            return;
         }
         var _loc1_:Array = BoxUtils.selectCompound(attachedBody,false);
         for each(_loc3_ in _loc1_)
         {
            _loc2_ = userData(_loc3_.GetUserData());
            if(!(!_loc2_ || !_loc2_.alive))
            {
               _loc2_.resistPoison = false;
            }
         }
      }
   }
}

