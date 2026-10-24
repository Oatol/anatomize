package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Bomb extends Trigger
   {
      
      public function Bomb()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc7_:int = 0;
         super.trigger(param1,param2);
         if(param2.burning || param2.temperature > 200)
         {
            param2.triggerDuration = 0;
         }
         param2.triggerDuration -= TimeLord.speed;
         var _loc3_:b2Vec2 = param2.triggerPos.Copy();
         _loc3_.Multiply(param2.size);
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         _loc4_.Add(pixelCenter);
         var _loc5_:String = "fire2";
         var _loc6_:String = "explosive";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc5_ = param2.pfx.getParticle();
            _loc6_ = param2.pfx.getParticle();
         }
         GameState.particles.addParticles(_loc4_.x,_loc4_.y,1,_loc5_,bodyVel.x * 0.1,bodyVel.y * 0.1,1,1);
         if((triggerDuration >> 0) % 29 == 0 && triggerDuration > 28)
         {
            sounds.play("ui_hover",param1,pixelCenter);
         }
         if(triggerDuration <= 1)
         {
            Body.Destroy(param1,"explosion");
            World.explode("grenade",pixelCenter,triggerForce * param2.size,param2.triggerRadius * param2.size,false);
            _loc7_ = 0;
            while(_loc7_ < 100 * param2.size)
            {
               if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
               {
                  _loc6_ = param2.pfx.getParticle();
               }
               GameState.particles.addParticles(pixelCenter.x + (Math.random() * 20 - 10) * param2.size,pixelCenter.y + (Math.random() * 20 - 10) * param2.size,1,_loc6_,bodyVel.x * 0.01,bodyVel.y * 0.01,Math.random() * 100 * param2.size,Math.random() * 100 * param2.size);
               GameState.particles.addParticles(pixelCenter.x + (Math.random() * 20 - 10) * param2.size,pixelCenter.y + (Math.random() * 20 - 10) * param2.size,1,_loc5_,bodyVel.x * 0.01,bodyVel.y * 0.01,Math.random() * 100 * param2.size,Math.random() * 100 * param2.size);
               _loc7_++;
            }
            sounds.random(["explosion","explosion2","explosion4"],param1,pixelCenter);
         }
         if(triggerDuration <= 0)
         {
            param2.dead = true;
         }
      }
   }
}

