package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class NovaGun extends Trigger
   {
      
      public function NovaGun()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc6_:b2Body = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:userData = null;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:int = 0;
         super.trigger(param1,param2);
         if(param2.group < 1000)
         {
            param2.group += 1000;
         }
         var _loc3_:String = "verydark";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc3_ = param2.pfx.getParticle();
         }
         var _loc4_:int = 0;
         while(_loc4_ < 2 * TimeLord.speed)
         {
            _loc7_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,(-param2.originalTriggerDuration * 0.1 + param2.triggerDuration * 0.2) * 10,Math.random() * 360);
            GameState.particles.addParticles(_loc7_.x,_loc7_.y,1,_loc3_,0,0,1,1);
            _loc4_++;
         }
         var _loc5_:Array = Body.GetAround(param1,triggerRadius,triggerRadius);
         if(_loc5_.length == 0 && param2.triggerDuration <= 0)
         {
            param2.triggerState = 2;
         }
         if(param2.triggerState == 2)
         {
            param2.triggerState = 0;
            if(param2.group >= 1000)
            {
               param2.group -= 1000;
            }
            param2.triggerDuration = param2.originalTriggerDuration;
            param2.triggered = false;
         }
         for each(_loc6_ in _loc5_)
         {
            _loc6_.WakeUp();
            _loc8_ = userData(_loc6_.GetUserData());
            _loc9_ = bodyCenter.x - _loc6_.GetWorldCenter().x;
            _loc10_ = bodyCenter.y - _loc6_.GetWorldCenter().y;
            _loc11_ = _loc9_ * _loc9_ + _loc10_ * _loc10_;
            _loc12_ = 10;
            if(param2.triggerState == 3)
            {
               _loc12_ = -100;
               _loc8_.killOnContact = true;
            }
            _loc6_.ApplyForce(new b2Vec2(-Vars.wind * _loc6_.GetMass() + _loc9_ * triggerForce * _loc12_,-Vars.gravity * _loc6_.GetMass() + _loc10_ * triggerForce * _loc12_),_loc6_.GetWorldCenter());
         }
         if(param2.triggerDuration > 0)
         {
            param2.triggerDuration -= TimeLord.speed;
         }
      }
      
      override public function onUntrigger() : void
      {
         super.onUntrigger();
         if(triggerState != 0)
         {
            return;
         }
         ud.triggered = true;
         ud.triggerState = 3;
         sounds.play("swish",body,pixelCenter);
      }
   }
}

