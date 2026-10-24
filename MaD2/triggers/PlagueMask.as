package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class PlagueMask extends ArmourHelmet
   {
      
      public function PlagueMask(param1:b2Body, param2:Number, param3:Number = 0.1, param4:Number = 0.5, param5:Number = 100)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:userData = null;
         var _loc5_:b2Body = null;
         super.trigger(param1,param2);
         ud.triggered = true;
         if(!attachedBody)
         {
            return;
         }
         var _loc3_:Array = BoxUtils.selectCompound(attachedBody);
         _loc3_.push(attachedBody);
         for each(_loc5_ in _loc3_)
         {
            _loc4_ = userData(_loc5_.GetUserData());
            if(!(!_loc4_ || !_loc4_.alive))
            {
               _loc4_.resistBlighting = true;
               if(_loc4_.trigger is ToxinMelt)
               {
                  _loc4_.triggerLock = false;
                  _loc4_.trigger.reset();
                  _loc4_.health += 10;
               }
            }
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
         var _loc1_:Array = BoxUtils.selectCompound(attachedBody);
         _loc1_.push(attachedBody);
         for each(_loc3_ in _loc1_)
         {
            _loc2_ = userData(_loc3_.GetUserData());
            if(!(!_loc2_ || !_loc2_.alive))
            {
               _loc2_.resistBlighting = false;
            }
         }
      }
   }
}

