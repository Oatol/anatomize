package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PFXCircleRandom extends ParticleEffect
   {
      
      internal var loopdir:Number = 1;
      
      internal var loopy:Number = 0;
      
      public function PFXCircleRandom(param1:b2Body, param2:b2Vec2 = null)
      {
         super(param1,param2);
      }
      
      override protected function init() : void
      {
         initRadius();
      }
      
      override public function update() : void
      {
         super.update();
         this.loopy += this.loopdir;
         if(this.loopy > 100)
         {
            this.loopdir *= -1;
         }
         if(this.loopy < 0)
         {
            this.loopdir *= -1;
         }
         var _loc1_:b2Vec2 = GeneralUtils.pointOnCircle(0,0,radius * size - Math.random() * radius * size,Math.random() * 360);
         var _loc2_:b2Vec2 = GeneralUtils.pointOnCircle(0,0,radius * size,Math.random() * 360);
         addParticles(_loc1_.x + body.GetPosition().x * Physics.scale,_loc1_.y + body.GetPosition().y * Physics.scale,1,"sparkle",0,0,0,0);
         addParticles(_loc2_.x + body.GetPosition().x * Physics.scale,_loc2_.y + body.GetPosition().y * Physics.scale,1,"sparkle",0,0,0,0);
      }
   }
}

