package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class SandCastle extends Trigger
   {
      
      internal var spawned:Boolean = false;
      
      public function SandCastle()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         param2.triggered = false;
         if(param2.triggerState != 1)
         {
            return;
         }
         Body.Destroy(param1,"func");
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc7_:int = 0;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         GameState.particles.addParticles(param5.x,param5.y,1,"tinydust",param1.GetLinearVelocity().x * 0.1,param1.GetLinearVelocity().y * 0.1,1,1);
         BoxUtils.randomParticlesOnBody(body,"dust",1);
         BoxUtils.randomParticlesOnBody(body,"tinydust",1);
         if(param4 > ud.triggerForce)
         {
            _loc7_ = 0;
            while(_loc7_ < 50)
            {
               BoxUtils.randomParticlesOnBody(body,"dust",Math.random() * 5);
               BoxUtils.randomParticlesOnBody(body,"tinydust",Math.random() * 5);
               _loc7_++;
            }
            ud.triggerState = 1;
            ud.triggered = true;
         }
         return true;
      }
   }
}

