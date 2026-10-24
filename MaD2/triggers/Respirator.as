package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Respirator extends ArmourHelmet
   {
      
      public function Respirator(param1:b2Body, param2:Number, param3:Number = 0.1, param4:Number = 0.5, param5:Number = 100)
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
         for each(_loc5_ in _loc3_)
         {
            _loc4_ = userData(_loc5_.GetUserData());
            if(!(!_loc4_ || !_loc4_.alive))
            {
               if(_loc4_.trigger is Poisoned)
               {
                  _loc4_.trigger.reset();
                  _loc4_.health += 10;
               }
            }
         }
      }
   }
}

