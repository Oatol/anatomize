package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class NoisyBullet extends GenericBullet
   {
      
      public function NoisyBullet()
      {
         super("poof");
      }
      
      override protected function safeExplode() : void
      {
         super.safeExplode();
         Body.Destroy(body,"trigger");
         World.explode("noisy",pixelCenter,20000,200,false,10,"noisy");
         var _loc1_:Array = ["explosive","explosive","explosive","fire2","fire2","fire3","poof","smoke"];
         var _loc2_:int = 0;
         while(_loc2_ < 100)
         {
            GameState.particles.addParticles(pixelCenter.x + (Math.random() * 20 - 10) * ud.size,pixelCenter.y + (Math.random() * 20 - 10) * ud.size,1,_loc1_[Math.random() * _loc1_.length >> 0],bodyVel.x * 0.01,bodyVel.y * 0.01,_loc2_ * 5 * ud.size,_loc2_ * 5 * ud.size);
            _loc2_++;
         }
         sounds.random(["explosion","explosion2","explosion4"],null,pixelCenter);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         explode();
         return true;
      }
   }
}

