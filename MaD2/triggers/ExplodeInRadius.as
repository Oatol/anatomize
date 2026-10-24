package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class ExplodeInRadius extends Trigger
   {
      
      public function ExplodeInRadius()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Body = null;
         super.trigger(param1,param2);
         if(param2.triggerDuration > 0)
         {
            param2.triggerDuration -= TimeLord.speed;
            return;
         }
         param2.triggerDuration = 15;
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         var _loc4_:String = "fire3";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc4_ = param2.pfx.getParticle();
         }
         for each(_loc5_ in _loc3_)
         {
            if(_loc5_ != param1)
            {
               if(!userData(_loc5_.GetUserData()).projectile)
               {
                  if(_loc5_.GetMass() >= 1)
                  {
                     userData(_loc5_.GetUserData()).trigger = new Explode();
                     userData(_loc5_.GetUserData()).triggered = true;
                  }
               }
            }
         }
      }
   }
}

