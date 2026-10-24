package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class NovaGrenade extends Trigger
   {
      
      public function NovaGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc6_:userData = null;
         var _loc7_:b2Body = null;
         var _loc8_:b2Vec2 = null;
         super.trigger(param1,param2);
         param2.triggerLock = true;
         var _loc3_:String = "verydark";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc3_ = param2.pfx.getParticle();
         }
         var _loc4_:int = 0;
         while(_loc4_ < 20 * TimeLord.speed)
         {
            _loc8_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,(param2.originalTriggerDuration * 0.5 - param2.triggerDuration) * 10,Math.random() * 360);
            GameState.particles.addParticles(_loc8_.x,_loc8_.y,1,_loc3_,0,0,1,1);
            _loc4_++;
         }
         var _loc5_:* = Body.GetAround(param1,param2.triggerRadius,param2.triggerRadius);
         for each(_loc7_ in _loc5_)
         {
            _loc7_.SetXForm(_loc7_.GetPosition(),Math.atan2(-_loc7_.GetPosition().y + bodyCenter.y,-_loc7_.GetPosition().x + bodyCenter.x));
            _loc6_ = userData(_loc7_.GetUserData());
            if(!(_loc6_.trigger is TemporaryRocket))
            {
               _loc6_.trigger = new TemporaryRocket(_loc3_,param2.triggerDuration);
               _loc6_.name = "ded";
               _loc6_.triggered = true;
               _loc6_.triggerLock = true;
               _loc6_.saveable = false;
               _loc6_.triggerPos = new b2Vec2(Math.random() * 10 - 5,Math.random() * 10 - 5);
            }
            _loc6_.triggerForce = (triggerDuration - param2.originalTriggerDuration * 0.6) * 80;
         }
         if(param2.triggerDuration <= 0)
         {
            param2.trigger = new Disintegrate(_loc3_,50,1);
            sounds.play("swish",param1,pixelCenter);
         }
         else if(param2.triggerDuration == param2.originalTriggerDuration)
         {
            sounds.play("swish",param1,pixelCenter);
         }
         param2.triggerDuration -= TimeLord.speed;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param1.IsStatic())
         {
            return false;
         }
         if(ud.triggered)
         {
            return false;
         }
         body.m_linearDamping = 9000;
         ud.ghost = true;
         ud.triggerLock = false;
         ud.triggered = true;
         ud.saveable = false;
         sounds.play("swish",body,pixelCenter);
         return true;
      }
   }
}

