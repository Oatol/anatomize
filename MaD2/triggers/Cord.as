package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Cord extends Trigger
   {
      
      public function Cord()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:userData = null;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Boolean = false;
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         var _loc4_:int = int(param2.connected.length);
         if(param2.triggerState == 0)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc3_ = userData(param2.connected[_loc5_].GetUserData());
               if(_loc3_.trigger is Cord)
               {
                  _loc6_ = pixelCenter.x + (param2.connected[_loc5_].GetPosition().x * Physics.scale - pixelCenter.x) * (1 - param2.triggerDuration / param2.originalTriggerDuration);
                  _loc7_ = pixelCenter.y + (param2.connected[_loc5_].GetPosition().y * Physics.scale - pixelCenter.y) * (1 - param2.triggerDuration / param2.originalTriggerDuration);
                  GameState.particles.addParticles(_loc6_,_loc7_,1,"shock");
               }
               _loc5_++;
            }
            if(param2.triggerDuration <= 0)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  _loc3_ = userData(param2.connected[_loc5_].GetUserData());
                  if(_loc3_.trigger is Cord)
                  {
                     _loc3_.triggered = true;
                     if(param2.triggerForce == 0)
                     {
                        _loc3_.triggerDuration = param2.originalTriggerDuration;
                     }
                     else
                     {
                        _loc3_.triggerDuration = param2.triggerForce;
                     }
                  }
                  _loc5_++;
               }
               param2.triggerDuration = param2.originalTriggerDuration;
               param2.triggered = false;
            }
         }
         else
         {
            _loc8_ = param2.triggerDuration > 0;
            param2.triggered = _loc8_;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc3_ = userData(param2.connected[_loc5_].GetUserData());
               if(!(_loc3_.trigger is Cord) || _loc3_.triggerState != 0)
               {
                  _loc3_.triggered = param2.triggerState == 1;
               }
               _loc5_++;
            }
         }
      }
   }
}

