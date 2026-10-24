package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class SmokeGrenade extends Trigger
   {
      
      public function SmokeGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:String = null;
         var _loc6_:Vector.<MyLittleParticle> = null;
         super.trigger(param1,param2);
         if(triggerDuration == param2.originalTriggerDuration)
         {
            sounds.play("explosion5",param1,pixelCenter);
         }
         if(triggerDuration <= 0)
         {
            param2.dead = true;
         }
         param2.triggerDuration -= TimeLord.speed;
         var _loc3_:int = 0;
         while(_loc3_ < 4)
         {
            _loc5_ = "bigSmoke";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc5_ = param2.pfx.getParticle();
            }
            _loc6_ = GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,_loc5_,bodyVel.x * 0.01,bodyVel.y * 0.01,Math.random() * 100,Math.random() * 100);
            if((Boolean(_loc6_)) && _loc6_.length > 0)
            {
               _loc6_[0].friction = 0.6;
               _loc6_[0].fade = 0.1;
               _loc6_[0].health = 1000;
            }
            _loc3_++;
         }
         if(Math.random() < 0.9)
         {
            return;
         }
         var _loc4_:b2Body = GameState.objects.spawnItem(O.getItem("circle").vertices,[1],2 * param2.size,"fog",pixelCenter.x,pixelCenter.y,0,["clustershrapnel"]);
         if(_loc4_)
         {
            userData(_loc4_.GetUserData()).trigger = new FogBullet();
            userData(_loc4_.GetUserData()).triggered = true;
            userData(_loc4_.GetUserData()).saveable = false;
            userData(_loc4_.GetUserData()).graphic.alpha = 0;
            _loc4_.SetLinearVelocity(new b2Vec2(bodyVel.x * 0.5,bodyVel.y * 0.5));
            _loc4_.ApplyImpulse(new b2Vec2((Math.random() * 80 - 40) * _loc4_.GetMass() * param2.size,(Math.random() * 80 - 40) * _loc4_.GetMass() * param2.size),_loc4_.GetPosition());
         }
      }
   }
}

