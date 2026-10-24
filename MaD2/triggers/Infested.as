package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Infested extends Trigger
   {
      
      public var sound:Boolean = true;
      
      public var particles:Boolean = true;
      
      public function Infested()
      {
         super();
         temporary = true;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         super.trigger(param1,param2);
         if(!param2.alive || param2.brittle)
         {
            param2.trigger.reset();
            return;
         }
         if(Math.random() < 0.99)
         {
            return;
         }
         var _loc3_:b2Vec2 = BoxUtils.randomPointOnBody(param1);
         _loc3_.Multiply(Physics.scale);
         var _loc4_:b2Body = GameState.objects.spawnItem(O.getItem("circle").vertices,[1],0.1 * param2.size,"circle",_loc3_.x,_loc3_.y,0,["circle"]);
         _loc4_.SetBullet(true);
         _loc4_.SetLinearVelocity(new b2Vec2(param1.GetLinearVelocity().x * 0.5,param1.GetLinearVelocity().y * 0.5));
         userData(_loc4_.GetUserData()).name = "worm";
         userData(_loc4_.GetUserData()).trigger = new WormStaff();
         userData(_loc4_.GetUserData()).triggered = true;
         userData(_loc4_.GetUserData()).triggerPos = new b2Vec2();
         userData(_loc4_.GetUserData()).graphic.alpha = 0;
         userData(_loc4_.GetUserData()).triggerRadius = 10;
         userData(_loc4_.GetUserData()).triggerState = 1;
         userData(_loc4_.GetUserData()).saveable = false;
         if(this.sound)
         {
            sounds.play("tinygrowth",param1,pixelCenter,Math.random() * 0.2 + 0.2,false);
         }
         param2.triggerDuration -= TimeLord.speed;
         if(param2.resistBlighting || param2.triggerDuration <= 0)
         {
            param2.trigger.reset();
            return;
         }
         if(TimeLord.speed == 1 || Math.random() * TimeLord.speed < TimeLord.speed * 0.25)
         {
            param2.health -= param2.maxhealth * 0.001 + Math.random() * 2.4 + 1.2;
            if(this.particles && Math.random() > 0.95)
            {
               _loc5_ = Math.random() * param2.width - param2.width * 0.5;
               _loc6_ = Math.random() * param2.height - param2.height * 0.5;
               _loc7_ = bodyCenter.x * Physics.scale + _loc5_ * Math.cos(bodyAngle) - _loc6_ * Math.sin(bodyAngle);
               _loc8_ = bodyCenter.y * Physics.scale + _loc5_ * Math.sin(bodyAngle) + _loc6_ * Math.cos(bodyAngle);
               _loc9_ = bodyVel.x * 0.1 + Math.random() * Math.random() * Math.random() * Math.random() * (Math.random() * 50 - 25);
               _loc10_ = bodyVel.y * 0.1 + Math.random() * Math.random() * Math.random() * Math.random() * (Math.random() * 50 - 25);
               GameState.particles.addParticles(_loc7_,_loc8_,1,"blood",_loc9_,_loc10_,0,0);
            }
         }
      }
   }
}

