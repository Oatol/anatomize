package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class GeigerCounter extends Trigger
   {
      
      public function GeigerCounter()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:userData = null;
         var _loc6_:b2Body = null;
         var _loc7_:b2Body = null;
         super.trigger(param1,param2);
         if(ud.triggerState == 1)
         {
            ud.triggerDuration -= TimeLord.speed;
            if(ud.triggerDuration <= 0)
            {
               sounds.play("touch1",body,pixelCenter,2);
               ud.triggerDuration = ud.originalTriggerDuration;
               ud.triggerState = -1;
            }
         }
         var _loc3_:Array = Body.GetAround(body,ud.triggerRadius,ud.triggerRadius,true);
         var _loc5_:Number = 0;
         for each(_loc6_ in _loc3_)
         {
            _loc4_ = userData(_loc6_.GetUserData());
            if(!(!_loc4_ || !_loc4_.trigger))
            {
               if(_loc4_.trigger is Radioactive || _loc4_.trigger is DroneRadiation)
               {
                  _loc5_ += ud.triggerRadius / Math.sqrt(BoxUtils.vectorDist(_loc6_.GetPosition(),bodyCenter));
               }
            }
         }
         if(ud.triggerState == -1)
         {
            if(_loc5_ > 200)
            {
               ud.triggerDuration = 6;
               ud.originalTriggerDuration = 6;
            }
            else if(_loc5_ > 100)
            {
               ud.triggerDuration = 12;
               ud.originalTriggerDuration = 12;
            }
            else if(_loc5_ > 50)
            {
               ud.triggerDuration = 18;
               ud.originalTriggerDuration = 18;
            }
            else if(_loc5_ > 20)
            {
               ud.triggerDuration = 24;
               ud.originalTriggerDuration = 24;
            }
            if(_loc5_ > 100)
            {
               for each(_loc7_ in ud.connected)
               {
                  userData(_loc7_.GetUserData()).triggered = true;
               }
            }
         }
         if(_loc5_ <= 20)
         {
            ud.triggerState = -1;
         }
         else
         {
            ud.triggerState = 1;
         }
      }
   }
}

