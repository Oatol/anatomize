package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class FrostfireBullet extends GenericBullet
   {
      
      public function FrostfireBullet()
      {
         super("frostfire");
      }
      
      override protected function safeExplode() : void
      {
         super.safeExplode();
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,2,"frostfire",bodyVel.x * 0.05,bodyVel.y * 0.05,2,2);
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,2,"fire3",bodyVel.x * 0.05,bodyVel.y * 0.05,2,2);
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,2,"crystal",bodyVel.x * 0.05,bodyVel.y * 0.05,8,8);
            _loc1_++;
         }
         Body.Destroy(body,"trigger");
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         Body.Frostfire(param1);
         explode();
         return true;
      }
   }
}

