package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class CryoBullet extends GenericBullet
   {
      
      public function CryoBullet()
      {
         super("crystal");
         trail = true;
      }
      
      override protected function safeExplode() : void
      {
         super.safeExplode();
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,2,"crystal",bodyVel.x * 0.05,bodyVel.y * 0.05,bodyVel.x * 0.01,bodyVel.y * 0.01);
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
         explode();
         var _loc7_:userData = userData(param1.GetUserData());
         if(!param1.IsStatic())
         {
            userData(param1.GetUserData()).temperature = userData(param1.GetUserData()).temperature - 50;
         }
         if(_loc7_.temperature < 0 && _loc7_.temperature > -40)
         {
            Body.Freeze(param1);
         }
         return true;
      }
   }
}

