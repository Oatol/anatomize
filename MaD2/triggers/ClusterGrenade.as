package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class ClusterGrenade extends Trigger
   {
      
      public function ClusterGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         super.trigger(param1,param2);
         Body.Destroy(param1,"cluster");
         World.explode("cluster",pixelCenter,200 * param2.size,param2.triggerRadius * param2.size,false);
         sounds.play("explosion5",param1,pixelCenter);
         var _loc3_:int = 0;
         while(_loc3_ < 20)
         {
            _loc4_ = GameState.objects.spawnItem(O.getItem("circle").vertices,[1],0.2 * param2.size,"clustershrapnel",pixelCenter.x,pixelCenter.y,0,["clustershrapnel"]);
            _loc4_.SetBullet(true);
            _loc4_.SetLinearVelocity(new b2Vec2(bodyVel.x * 0.5,bodyVel.y * 0.5));
            _loc4_.ApplyImpulse(new b2Vec2((Math.random() * 80 - 40) * _loc4_.GetMass() * param2.size,(Math.random() * 80 - 40) * _loc4_.GetMass() * param2.size),_loc4_.GetPosition());
            _loc3_++;
         }
      }
   }
}

