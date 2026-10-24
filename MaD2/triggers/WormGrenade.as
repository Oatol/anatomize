package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class WormGrenade extends Trigger
   {
      
      public function WormGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         super.trigger(param1,param2);
         Body.Destroy(param1,"functionality");
         sounds.play("splash",param1,pixelCenter);
         var _loc3_:int = 0;
         while(_loc3_ < 15)
         {
            _loc4_ = GameState.objects.spawnItem(O.getItem("circle").vertices,[1],0.5 * param2.size,"circle",pixelCenter.x + Math.random() * 10 - 5,pixelCenter.y + Math.random() * 10 - 5,0,["circle"]);
            _loc4_.SetBullet(true);
            _loc4_.SetLinearVelocity(new b2Vec2(bodyVel.x * 0.5,bodyVel.y * 0.5));
            _loc4_.ApplyImpulse(new b2Vec2((Math.random() * triggerForce - triggerForce * 0.5) * _loc4_.GetMass() * param2.size,(Math.random() * triggerForce - triggerForce * 0.5) * _loc4_.GetMass() * param2.size),_loc4_.GetPosition());
            userData(_loc4_.GetUserData()).trigger = new WormStaff();
            userData(_loc4_.GetUserData()).triggered = true;
            userData(_loc4_.GetUserData()).triggerPos = new b2Vec2();
            userData(_loc4_.GetUserData()).graphic.alpha = 0;
            userData(_loc4_.GetUserData()).triggerRadius = 40;
            userData(_loc4_.GetUserData()).triggerState = 1;
            userData(_loc4_.GetUserData()).saveable = false;
            _loc3_++;
         }
      }
   }
}

