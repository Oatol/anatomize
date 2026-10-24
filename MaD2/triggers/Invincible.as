package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Invincible extends Trigger
   {
      
      public function Invincible()
      {
         super();
         temporary = true;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:String = null;
         var _loc4_:Vector.<MyLittleParticle> = null;
         var _loc5_:MyLittleParticle = null;
         super.trigger(param1,param2);
         if(!param2 || param2.dead || param2.hasBeenCut)
         {
            return;
         }
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration <= 0)
         {
            param2.triggerLock = false;
            param2.trigger.reset();
            return;
         }
         if(Math.random() > 0.8)
         {
            _loc3_ = "supershiny";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc3_ = param2.pfx.getParticle();
            }
            _loc4_ = GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,_loc3_,bodyVel.x * 0.1,bodyVel.y * 0.1);
            if(_loc4_)
            {
               for each(_loc5_ in _loc4_)
               {
                  _loc5_.health = 100;
                  _loc5_.friction = 0.9;
                  _loc5_.wander = 0;
               }
            }
         }
         if(param2.health < param2.maxhealth || param2.bleeding.length > 0 || param2.temperature < 0 || param2.temperature > 100)
         {
            param2.health = param2.maxhealth;
            param2.bleeding = [];
            if(param2.ignition)
            {
               param2.ignition = 100;
            }
            if(param2.temperature < 0)
            {
               param2.temperature = Math.random() * 30 + 10;
               param2.brittle = false;
            }
            else if(param2.temperature > 100)
            {
               param2.temperature = Math.random() * 30 + 10;
            }
         }
      }
   }
}

