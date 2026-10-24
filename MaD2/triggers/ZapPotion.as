package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class ZapPotion extends Trigger
   {
      
      public function ZapPotion()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(param2.triggerDuration == param2.originalTriggerDuration)
         {
            sounds.play("thunder",param1,pixelCenter,1.5);
         }
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration <= 0)
         {
            param2.trigger = new Disintegrate("shock",100,20);
         }
         var _loc3_:Array = GameState.cutter.CustomRaycast(new b2Vec2(pixelCenter.x,pixelCenter.y - 50),600,new b2Vec2(pixelCenter.x,0),false,"laser");
         var _loc4_:b2Vec2 = b2Vec2(_loc3_[1]).Copy();
         _loc4_.Multiply(Physics.scale);
         var _loc5_:b2Vec2 = new b2Vec2(pixelCenter.x,_loc4_.y + Math.random() * (-_loc4_.y + pixelCenter.y));
         var _loc6_:b2Body = Spawn.circle(_loc5_.x,_loc5_.y,5,Properties.objectProperties("pulse"),[0.01,1,1]);
         userData(_loc6_.GetUserData()).ghost = true;
         userData(_loc6_.GetUserData()).killOnContact = true;
         userData(_loc6_.GetUserData()).trigger = new Tesla();
         userData(_loc6_.GetUserData()).triggerRadius = 50;
         userData(_loc6_.GetUserData()).triggered = true;
         userData(_loc6_.GetUserData()).triggerLock = true;
         if(Math.random() > 0.9)
         {
            GameState.particles.addParticles(pixelCenter.x + Math.random() * 60 - 30,_loc4_.y,1,"shinysliver",0,Math.random() * 20,0,0);
         }
         GameState.particles.addParticles(_loc4_.x + Math.random() * 80 - 40,_loc4_.y + Math.random() * 50,1,"thundercloud",0,0,0,0);
      }
   }
}

