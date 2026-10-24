package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PFXFirefly extends ParticleEffect
   {
      
      internal var xp:Number = 0;
      
      internal var yp:Number = 0;
      
      internal var xv:Number = 0;
      
      internal var yv:Number = 0;
      
      public function PFXFirefly(param1:b2Body, param2:b2Vec2 = null)
      {
         applyOffset = false;
         super(param1,param2);
      }
      
      override protected function init() : void
      {
         initRadius();
         this.xv = Math.random() * 10 - 5;
         this.yv = Math.random() * 10 - 5;
      }
      
      override public function update() : void
      {
         super.update();
         this.xv += (-1.2 + Math.random() * 2.4) * speed;
         this.yv += (-1.2 + Math.random() * 2.4) * speed;
         if(this.xp > radius * size)
         {
            this.xv -= 1 * speed;
            this.xp = radius * size;
         }
         if(this.xp < -radius * size)
         {
            this.xv += 1 * speed;
            this.xp = -radius * size;
         }
         if(this.yp > radius * size)
         {
            this.yv -= 1 * speed;
            this.yp = radius * size;
         }
         if(this.yp < -radius * size)
         {
            this.yv += 1 * speed;
            this.yp = -radius * size;
         }
         this.xv *= 0.99;
         this.yv *= 0.99;
         this.xp += this.xv;
         this.yp += this.yv;
         addParticles(this.xp + body.GetPosition().x * Physics.scale,this.yp + body.GetPosition().y * Physics.scale,1,"sparkle",0,0,0,0);
      }
   }
}

