package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class SassageBullet extends GenericBullet
   {
      
      public function SassageBullet()
      {
         super("steak");
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
         var _loc2_:b2Body = null;
         super.safeExplode();
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            _loc2_ = GameState.objects.spawnObject("sausage",pixelCenter.x + Math.random() * 40 - 20,pixelCenter.y + Math.random() * 40 - 20,Math.random() * 360,false,true);
            _loc2_.ApplyImpulse(new b2Vec2(Math.random() * 60 - 30,Math.random() * 60 - 30),_loc2_.GetPosition());
            userData(_loc2_.GetUserData()).trigger = new TempProjectile(Math.random() * 60 + 30);
            userData(_loc2_.GetUserData()).ignore = "sausage";
            userData(_loc2_.GetUserData()).triggerOnContact = true;
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

