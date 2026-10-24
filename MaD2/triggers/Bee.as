package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Bee extends Trigger
   {
      
      internal var pepe:MyLittleParticle;
      
      public function Bee()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:Vector.<MyLittleParticle> = null;
         super.trigger(param1,param2);
         if(!this.pepe)
         {
            _loc5_ = GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,"bees",bodyVel.x * 0.1,bodyVel.y * 0.1,bodyVel.x * 0.01,bodyVel.y * 0.01);
            if((Boolean(_loc5_)) && _loc5_.length > 0)
            {
               this.pepe = _loc5_[0];
            }
         }
         else
         {
            this.pepe.x = pixelCenter.x;
            this.pepe.y = pixelCenter.y;
         }
         var _loc3_:Number = 500;
         var _loc4_:b2Vec2 = new b2Vec2(Math.random() * _loc3_ - _loc3_ * 0.5,Math.random() * _loc3_ - _loc3_ * 0.5 - 2);
         _loc4_.Multiply(param1.GetMass());
         param1.ApplyForce(_loc4_,bodyCenter);
      }
      
      public function sting(param1:b2Body, param2:b2Vec2, param3:Number = 2) : *
      {
         Body.ApplyEffect(param1,"sting",param2,body);
      }
   }
}

