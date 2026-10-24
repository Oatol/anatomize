package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class DeepfryBullet extends GenericBullet
   {
      
      public function DeepfryBullet()
      {
         super("fried");
         trail = true;
      }
      
      override protected function safeExplode() : void
      {
         super.safeExplode();
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,2,"fried",bodyVel.x * 0.05,bodyVel.y * 0.05,2,2);
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
         var _loc7_:b2Vec2 = body.GetPosition().Copy();
         _loc7_.Multiply(Physics.scale);
         sounds.play("hiss",body,_loc7_,0.5);
         var _loc8_:int = 0;
         while(_loc8_ < 10)
         {
            Body.Damage(param1,Math.random() * 2 + 2,null,null,null,false);
            _loc8_++;
         }
         Body.Deepfry(param1);
         explode();
         return true;
      }
   }
}

