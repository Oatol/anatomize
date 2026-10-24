package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Poisoned extends Trigger
   {
      
      public var sound:Boolean = true;
      
      public var particles:Boolean = true;
      
      public function Poisoned()
      {
         super();
         temporary = true;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         super.trigger(param1,param2);
         if(!param2.alive || param2.brittle)
         {
            return;
         }
         if(this.sound)
         {
            sounds.play("hiss",param1,pixelCenter,Math.random() * 0.2 + 0.2,false);
         }
         param2.triggerDuration -= TimeLord.speed;
         if(param2.resistPoison || param2.triggerDuration <= 0)
         {
            param2.trigger.reset();
            return;
         }
         if(TimeLord.speed == 1 || Math.random() * TimeLord.speed < TimeLord.speed * 0.25)
         {
            param2.health -= param2.maxhealth * 0.001 + Math.random() * 2.4 + 1.2;
            if(this.particles && Math.random() > 0.95)
            {
               _loc3_ = Math.random() * param2.width - param2.width * 0.5;
               _loc4_ = Math.random() * param2.height - param2.height * 0.5;
               _loc5_ = bodyCenter.x * Physics.scale + _loc3_ * Math.cos(bodyAngle) - _loc4_ * Math.sin(bodyAngle);
               _loc6_ = bodyCenter.y * Physics.scale + _loc3_ * Math.sin(bodyAngle) + _loc4_ * Math.cos(bodyAngle);
               _loc7_ = bodyVel.x * 0.1 + Math.random() * Math.random() * Math.random() * Math.random() * (Math.random() * 50 - 25);
               _loc8_ = bodyVel.y * 0.1 + Math.random() * Math.random() * Math.random() * Math.random() * (Math.random() * 50 - 25);
               GameState.particles.addParticles(_loc5_,_loc6_,1,"poison",_loc7_,_loc8_,0,0);
            }
         }
      }
   }
}

