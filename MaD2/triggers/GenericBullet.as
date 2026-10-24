package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class GenericBullet extends Trigger
   {
      
      protected var needsExploding:Boolean = false;
      
      protected var particle:String;
      
      protected var trail:Boolean = false;
      
      protected var trailParticle:String;
      
      protected var pepe:MyLittleParticle;
      
      public function GenericBullet(param1:String)
      {
         super();
         this.setParticle(param1);
      }
      
      public function explode() : void
      {
         this.needsExploding = true;
         if(ud)
         {
            ud.triggered = true;
         }
         if(this.pepe)
         {
            this.pepe.health = 0;
         }
      }
      
      public function setParticle(param1:String) : *
      {
         this.particle = param1;
      }
      
      protected function safeExplode() : void
      {
         if(this.pepe)
         {
            this.pepe.health = 0;
            this.pepe.vx = 0;
            this.pepe.vy = 0;
         }
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Vector.<MyLittleParticle> = null;
         super.trigger(param1,param2);
         if(this.needsExploding)
         {
            this.safeExplode();
         }
         if(this.particle)
         {
            if(this.pepe)
            {
               this.pepe.x = pixelCenter.x;
               this.pepe.y = pixelCenter.y;
               this.pepe.vx = bodyVel.x * 0.1;
               this.pepe.vy = bodyVel.y * 0.1;
               if(!this.trail)
               {
                  return;
               }
            }
            if(Boolean(param2) && Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               this.particle = param2.pfx.getParticle();
            }
            if(Boolean(this.pepe) && Boolean(this.trail) && Boolean(this.trailParticle))
            {
               this.particle = this.trailParticle;
            }
            _loc3_ = GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,this.particle,bodyVel.x * 0.05,bodyVel.y * 0.05,bodyVel.x * 0.01,bodyVel.y * 0.01);
            if(!this.pepe)
            {
               if(Boolean(_loc3_) && _loc3_.length > 0)
               {
                  this.pepe = _loc3_[0];
                  this.pepe.health = 360;
                  this.pepe.fade = 0;
               }
            }
         }
      }
   }
}

