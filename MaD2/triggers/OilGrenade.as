package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class OilGrenade extends Trigger
   {
      
      public function OilGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Body = null;
         super.trigger(param1,param2);
         Body.Destroy(param1,"cluster");
         sounds.play("swish",param1,pixelCenter);
         var _loc3_:Number = param2.triggerForce;
         var _loc4_:int = 0;
         while(_loc4_ < 20)
         {
            _loc5_ = GameState.objects.delayedSpawnObject("oil",pixelCenter.x + Math.random() * 10 - 5,pixelCenter.y + Math.random() * 10 - 5,0,false,true);
            _loc5_.SetBullet(true);
            _loc5_.SetLinearVelocity(new b2Vec2(bodyVel.x * 0.5,bodyVel.y * 0.5));
            _loc5_.ApplyImpulse(new b2Vec2((Math.random() * _loc3_ - _loc3_ * 0.5) * _loc5_.GetMass() * param2.size,(Math.random() * _loc3_ - _loc3_ * 0.5) * _loc5_.GetMass() * param2.size),_loc5_.GetPosition());
            _loc4_++;
         }
      }
   }
}

