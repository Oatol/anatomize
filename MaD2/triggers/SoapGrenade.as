package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class SoapGrenade extends Trigger
   {
      
      public function SoapGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:userData = null;
         super.trigger(param1,param2);
         Body.Destroy(param1,"functionality");
         sounds.play("explosion5",param1,pixelCenter,0.8);
         sounds.play("bubbles",param1,pixelCenter);
         var _loc3_:int = 0;
         while(_loc3_ < 20)
         {
            _loc4_ = GameState.objects.spawnItem(O.getItem("circle").vertices,[1],0.2 * param2.size,"bubble",pixelCenter.x + Math.random() * 10 - 5,pixelCenter.y + Math.random() * 10 - 5,0,["bubble"],"bubble");
            _loc4_.SetBullet(true);
            _loc4_.SetLinearVelocity(new b2Vec2(bodyVel.x * 0.5,bodyVel.y * 0.5));
            _loc4_.ApplyImpulse(new b2Vec2((Math.random() * triggerForce - triggerForce * 0.5) * _loc4_.GetMass() * param2.size,(Math.random() * triggerForce - triggerForce * 0.5) * _loc4_.GetMass() * param2.size),_loc4_.GetPosition());
            _loc5_ = _loc4_.GetUserData();
            _loc5_.trigger = new Bubble();
            _loc5_.triggered = true;
            _loc5_.zerograv = true;
            _loc5_.killOnContact = true;
            _loc5_.triggerRadius = 30;
            _loc3_++;
         }
      }
   }
}

