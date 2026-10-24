package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class FlareBullet extends GenericBullet
   {
      
      public function FlareBullet()
      {
         super("flare");
         trail = true;
         trailParticle = "fire3";
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         var _loc3_:Number = 0.01 + 0.1 * Math.random();
         var _loc4_:int = Math.floor(Math.random() * 200) + 55;
         GameState.particles.addSimpleParticles(pixelCenter.x * Physics.scale,pixelCenter.y * Physics.scale,1,uint(255 << 24 | _loc4_ << 16),_loc3_,_loc3_,2,2);
      }
      
      override protected function safeExplode() : void
      {
         var _loc3_:Vector.<MyLittleParticle> = null;
         var _loc4_:MyLittleParticle = null;
         super.safeExplode();
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,2,"fire3",bodyVel.x * 0.05,bodyVel.y * 0.05,bodyVel.x * 0.01,bodyVel.y * 0.01);
            _loc1_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ < 5)
         {
            _loc3_ = GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,2,"flare",bodyVel.x * 0.05,bodyVel.y * 0.05,bodyVel.x * 0.01 + 4,bodyVel.y * 0.01 + 4);
            if(_loc3_)
            {
               for each(_loc4_ in _loc3_)
               {
                  _loc4_.friction = 0.95;
                  _loc4_.fade = Math.random() * 10;
               }
            }
            _loc2_++;
         }
         Body.Destroy(body,"trigger");
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(!param1.IsStatic())
         {
            userData(param1.GetUserData()).temperature = userData(param1.GetUserData()).temperature + 200;
         }
         Body.Damage(param1,50,param5,new b2Vec2(),new b2Vec2(2,2),false);
         explode();
         return true;
      }
   }
}

