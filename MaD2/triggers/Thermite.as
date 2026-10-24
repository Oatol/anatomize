package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Thermite extends Trigger
   {
      
      public function Thermite()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:userData = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size);
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = userData(_loc4_.GetUserData());
            if(!(!_loc5_ || _loc5_.resistFlame))
            {
               if(_loc5_.temperature < 90)
               {
                  _loc5_.temperature = 100;
               }
               _loc5_.conductivity = 0.1;
               _loc5_.ignition = 100;
               _loc5_.trigger = new Napalmed();
               _loc5_.triggerDuration = 520;
               _loc5_.triggered = true;
            }
         }
         param2.dead = true;
         Body.Disintegrate(param1,"fire2",200,20,20);
         sounds.play("incendiary",param1,pixelCenter);
      }
   }
}

