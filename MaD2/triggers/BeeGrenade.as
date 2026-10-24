package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class BeeGrenade extends Trigger
   {
      
      public function BeeGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:userData = null;
         var _loc5_:b2Body = null;
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
         if(TimeLord.speed == 1 || Math.random() * TimeLord.speed < TimeLord.speed * 0.1)
         {
            _loc3_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,30 * param2.size,Math.random() * 360);
            _loc4_ = Properties.objectProperties("beepod");
            _loc4_.trigger = new Bee();
            _loc4_.name = "beepod";
            _loc4_.triggered = true;
            _loc5_ = Spawn.circle(_loc3_.x,_loc3_.y,1,_loc4_,[1,1,1]);
            _loc5_.SetBullet(true);
            _loc5_.SetLinearVelocity(new b2Vec2(bodyVel.x * 0.5,bodyVel.y * 0.5));
            _loc5_.ApplyImpulse(new b2Vec2((Math.random() * triggerForce - triggerForce * 0.5) * _loc5_.GetMass() * param2.size,(Math.random() * triggerForce - triggerForce * 0.5) * _loc5_.GetMass() * param2.size),_loc5_.GetPosition());
         }
      }
   }
}

