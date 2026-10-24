package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Firework extends Trigger
   {
      
      protected var which:int;
      
      public function Firework()
      {
         super();
      }
      
      protected function explode(param1:b2Body, param2:userData) : void
      {
         var _loc3_:int = 0;
         var _loc4_:b2Vec2 = null;
         var _loc5_:int = 0;
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:Number = NaN;
         if(this.which == 0)
         {
            param2.triggerDuration -= TimeLord.speed;
            _loc3_ = 0;
            while(_loc3_ < 10)
            {
               GameState.particles.addParticles(pixelCenter.x + (Math.random() * 10 - 5) * param2.size,pixelCenter.y + (Math.random() * 10 - 5) * param2.size,1,"fire2",bodyVel.x * 0.01,bodyVel.y * 0.01,param2.size * 12,param2.size * 12);
               _loc3_++;
            }
            if(param2.triggerDuration < -10)
            {
               this.damage();
            }
         }
         else if(this.which == 1)
         {
            param2.triggerDuration -= TimeLord.speed;
            _loc3_ = 0;
            while(_loc3_ < 10)
            {
               GameState.particles.addParticles(pixelCenter.x + (Math.random() * 30 - 15) * param2.size,pixelCenter.y + (Math.random() * 30 - 15) * param2.size,10,"light",bodyVel.x * 0.01,bodyVel.y * 0.01,param2.size * 2,param2.size * 2);
               _loc3_++;
            }
            if(param2.triggerDuration < -10)
            {
               this.damage();
            }
         }
         else if(this.which == 2)
         {
            param2.triggerDuration -= TimeLord.speed;
            _loc3_ = 0;
            while(_loc3_ < 10)
            {
               _loc4_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,10 * param2.size,param2.triggerDuration * 30 + _loc3_);
               GameState.particles.addParticles(_loc4_.x,_loc4_.y,1,"explosive",(_loc4_.x - pixelCenter.x) * param2.size * 3,(_loc4_.y - pixelCenter.y) * param2.size * 3,1,1);
               _loc3_++;
            }
            if(param2.triggerDuration < -30)
            {
               this.damage();
            }
         }
         else if(this.which == 3)
         {
            param2.triggerDuration -= TimeLord.speed;
            _loc5_ = 0;
            while(_loc5_ < 20)
            {
               _loc6_ = new b2Vec2(1 * param2.size,-15 * param2.size);
               _loc7_ = BoxUtils.rotateVec(_loc6_,bodyAngle);
               _loc8_ = bodyAngle + Vars.PI * 0.5;
               GameState.particles.addParticles(pixelCenter.x + _loc7_.x,pixelCenter.y + _loc7_.y,1,"shock2",param2.size * _loc5_ * Math.cos(_loc8_),param2.size * _loc5_ * Math.sin(_loc8_),2,2);
               _loc5_++;
            }
            if(param2.triggerDuration < -30)
            {
               this.damage();
            }
         }
         else if(this.which == 4)
         {
            param2.triggerDuration -= TimeLord.speed;
            _loc5_ = 0;
            while(_loc5_ < 20)
            {
               GameState.particles.addParticles(pixelCenter.x + (Math.random() * _loc5_ * 12 - _loc5_ * 6) * param2.size,pixelCenter.y + (Math.random() * _loc5_ * 12 - _loc5_ * 6) * param2.size,1,"decoration",0,0,param2.size * _loc5_,param2.size * _loc5_);
               _loc5_++;
            }
            if(param2.triggerDuration < -60)
            {
               this.damage();
            }
         }
      }
      
      protected function damage() : void
      {
         ud.trigger = new PhosphorusGrenade(0.01,false);
         if(ud.triggerRadius == 0)
         {
            ud.triggerRadius = 20;
         }
         ud.triggerForce = 800;
         ud.triggered = true;
         sounds.random(["thumper_explosion","disc_shoot","carbine_shoot","explosion5","explosion4","explosion3","explosion2","explosion","thunder"],body,pixelCenter,0.5);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         param1.WakeUp();
         param1.ApplyForce(new b2Vec2(Math.sin(bodyAngle) * param1.GetMass() * triggerForce,-Math.cos(bodyAngle) * param1.GetMass() * triggerForce),bodyCenter);
         if(triggerDuration > 0)
         {
            param2.triggerDuration -= TimeLord.speed;
         }
         var _loc3_:b2Vec2 = new b2Vec2(1 * param2.size,15 * param2.size);
         if(param2.triggerPos.x != 0 || param2.triggerPos.y != 0)
         {
            _loc3_ = param2.triggerPos.Copy();
            _loc3_.Multiply(param2.size);
         }
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc5_:Number = bodyAngle + Vars.PI * 0.5;
         var _loc6_:String = "fire3";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc6_ = param2.pfx.getParticle();
         }
         _loc5_ = Math.atan2(bodyCenter.y - _loc4_.y,bodyCenter.x - _loc4_.x);
         var _loc7_:Number = param2.size * 8 * Math.sin(_loc5_);
         GameState.particles.addParticles(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y,1,_loc6_,param2.size * 8 * Math.cos(_loc5_),_loc7_,2,2);
         if(param2.triggerDuration <= 0)
         {
            if(!this.which)
            {
               this.which = int(Math.random() * 5);
            }
            this.explode(param1,param2);
         }
      }
   }
}

