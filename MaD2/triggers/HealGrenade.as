package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class HealGrenade extends Trigger
   {
      
      public function HealGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration <= 0)
         {
            param2.dead = true;
         }
         if(param2.triggerDuration <= 0)
         {
            _loc5_ = 0;
            while(_loc5_ < 40)
            {
               _loc6_ = "heal";
               if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
               {
                  _loc6_ = param2.pfx.getParticle();
               }
               GameState.particles.addParticles(pixelCenter.x + Math.random() * 20 - 10,pixelCenter.y + Math.random() * 20 - 10,1,_loc6_,-bodyVel.x,-bodyVel.y,100,100);
               _loc5_++;
            }
         }
         else
         {
            _loc6_ = "heal";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc6_ = param2.pfx.getParticle();
            }
            GameState.particles.addParticles(pixelCenter.x + Math.random() * 20 - 10,pixelCenter.y + Math.random() * 20 - 10,1,_loc6_,-bodyVel.x,-bodyVel.y,100,100);
         }
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         for each(_loc4_ in _loc3_)
         {
            userData(_loc4_.GetUserData()).health = userData(_loc4_.GetUserData()).health + triggerForce;
         }
      }
   }
}

