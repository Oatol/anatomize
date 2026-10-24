package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PFXCollisionExplosion extends ParticleEffect
   {
      
      internal var timer:Number = 0;
      
      public var collided:b2Vec2 = new b2Vec2();
      
      public function PFXCollisionExplosion(param1:b2Body, param2:b2Vec2 = null)
      {
         super(param1,param2);
         amount = 1;
         noAmount = true;
         noRadius = true;
         applyOffset = false;
      }
      
      override public function update() : void
      {
         super.update();
         this.timer -= TimeLord.speed;
         if(this.timer > 0)
         {
            this.collided.x = 0;
            this.collided.y = 0;
            return;
         }
         if(this.collided.x == 0 && this.collided.y == 0)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < 10 * amount)
         {
            addParticles(this.collided.x,this.collided.y,1,"sparkle",body.GetLinearVelocity().x * 0.05,1 + body.GetLinearVelocity().y * 0.05,1 + body.GetLinearVelocity().Length() * radius * 0.02,body.GetLinearVelocity().Length() * radius * 0.02);
            _loc1_++;
         }
         this.collided.x = 0;
         this.collided.y = 0;
         this.timer = 30;
      }
   }
}

