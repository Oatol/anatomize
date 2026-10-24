package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PFXCollision extends ParticleEffect
   {
      
      public var collided:b2Vec2 = new b2Vec2();
      
      public function PFXCollision(param1:b2Body, param2:b2Vec2 = null)
      {
         super(param1,param2);
         amount = 1;
         noAmount = true;
         noScale = true;
         noRadius = true;
         applyOffset = false;
      }
      
      override public function update() : void
      {
         super.update();
         if(this.collided.x == 0 && this.collided.y == 0)
         {
            return;
         }
         addParticles(this.collided.x,this.collided.y,1,"sparkle",body.GetLinearVelocity().x * 0.05,body.GetLinearVelocity().y * 0.05,0,0);
         this.collided.x = 0;
         this.collided.y = 0;
      }
   }
}

