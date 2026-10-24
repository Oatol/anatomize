package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class NapalmSword extends Trigger
   {
      
      public function NapalmSword()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:b2Vec2 = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:String = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(triggerDuration > 0)
         {
            param2.triggerDuration -= TimeLord.speed;
            if(triggerDuration > 30)
            {
               _loc3_ = new b2Vec2(0,-10 * param2.size);
               _loc4_ = BoxUtils.rotateVec(_loc3_,bodyAngle);
               _loc5_ = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
               GameState.objects.addbullet("magma",(_loc5_.x + (Math.random() * 100 - 50) * param2.size) / Physics.scale,(_loc5_.y + (Math.random() * 100 - 50) * param2.size) / Physics.scale,0,1,1,new b2Vec2(bodyVel.x * 10,bodyVel.y * 10),10,param1);
            }
         }
         if(triggerDuration <= 0)
         {
            _loc3_ = new b2Vec2(0,-10 * param2.size);
            _loc4_ = BoxUtils.rotateVec(_loc3_,bodyAngle);
            _loc5_ = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
            _loc6_ = "fire3";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc6_ = param2.pfx.getParticle();
            }
            _loc7_ = new b2Vec2(Math.random() * 20 - 10,Math.random() * 90 - 30);
            _loc8_ = BoxUtils.rotateVec(_loc7_,bodyAngle);
            GameState.particles.addParticles(_loc5_.x - _loc8_.x * param2.size,_loc5_.y - _loc8_.y * param2.size,1,_loc6_,bodyVel.x * 0.1,bodyVel.y * 0.1,0,0);
            if(param1.GetLinearVelocity().Length() > 60)
            {
               sounds.play("incendiary",param1,_loc5_);
               GameState.objects.addbullet("magma",(_loc5_.x + (Math.random() * 100 - 50) * param2.size) / Physics.scale,(_loc5_.y + (Math.random() * 100 - 50) * param2.size) / Physics.scale,0,1,1,bodyVel,10,param1);
               param2.triggerDuration = 60;
            }
         }
      }
   }
}

