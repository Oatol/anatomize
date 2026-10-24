package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class AirHorn extends Trigger
   {
      
      public function AirHorn()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:userData = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = userData(_loc4_.GetUserData());
            if(_loc5_.alive)
            {
               if(!(_loc5_.trigger is Bass))
               {
                  _loc5_.triggerPos = new b2Vec2(4,4);
                  _loc5_.trigger = new Bass();
                  _loc5_.triggerDuration = Math.random() * 30 + 30;
                  _loc5_.triggered = true;
                  _loc5_.triggerLock = true;
               }
            }
         }
         if(!sounds.isPlaying("horn"))
         {
            sounds.play("horn",param1,pixelCenter);
         }
         param2.triggered = false;
      }
   }
}

