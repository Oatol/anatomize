package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class FogBullet extends GenericBullet
   {
      
      public function FogBullet()
      {
         super("fog");
         trail = true;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         param1.ApplyForce(new b2Vec2(0,-0.1),param1.GetPosition());
         super.trigger(param1,param2);
         var _loc3_:Number = param2.triggerRadius;
         if(TimeLord.speed == 1 || Math.random() * TimeLord.speed < TimeLord.speed * 0.25)
         {
            GameState.particles.addParticles(pixelCenter.x + Math.random() * _loc3_ - _loc3_ * 0.5,pixelCenter.y + Math.random() * _loc3_ - _loc3_ * 0.5,1,"poisongas",0,0,0,0);
         }
         if(TimeLord.speed == 1 || Math.random() * TimeLord.speed < TimeLord.speed * 0.25)
         {
            if(Math.random() > 0.99)
            {
               param2.dead = true;
            }
         }
      }
   }
}

