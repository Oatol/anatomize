package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   import shiny.PFXOverwrite;
   
   public class NeuroGrenade extends Trigger
   {
      
      public function NeuroGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         super.trigger(param1,param2);
         Body.Destroy(param1,"cluster");
         sounds.play("explosion",param1,pixelCenter,0.8);
         sounds.play("acidburn",param1,pixelCenter);
         var _loc3_:int = 0;
         while(_loc3_ < 10)
         {
            _loc4_ = GameState.objects.spawnItem(O.getItem("circle").vertices,[1],0.2 * param2.size,"neurogas",pixelCenter.x,pixelCenter.y,0,["clustershrapnel"]);
            if(_loc4_)
            {
               userData(_loc4_.GetUserData()).trigger = new NeuroBullet();
               if(param2.pfx is PFXOverwrite)
               {
                  NeuroBullet(userData(_loc4_.GetUserData()).trigger).setParticle(PFXOverwrite(param2.pfx).getParticle());
               }
               userData(_loc4_.GetUserData()).triggered = true;
               userData(_loc4_.GetUserData()).ghost = true;
               userData(_loc4_.GetUserData()).triggerRadius = 100;
               _loc4_.SetLinearVelocity(new b2Vec2(bodyVel.x * 0.5,bodyVel.y * 0.5));
               _loc4_.ApplyImpulse(new b2Vec2((Math.random() * 80 - 40) * _loc4_.GetMass() * param2.size,(Math.random() * 80 - 40) * _loc4_.GetMass() * param2.size),_loc4_.GetPosition());
            }
            _loc3_++;
         }
      }
   }
}

