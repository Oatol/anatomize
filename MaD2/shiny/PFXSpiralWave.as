package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PFXSpiralWave extends ParticleEffect
   {
      
      internal var loopy:Number = 0;
      
      public function PFXSpiralWave(param1:b2Body, param2:b2Vec2 = null)
      {
         super(param1,param2);
      }
      
      override protected function init() : void
      {
         initRadius();
      }
      
      override public function update() : void
      {
         var _loc1_:b2Vec2 = null;
         super.update();
         this.loopy += speed * speed;
         if(this.loopy > 360)
         {
            this.loopy = 0;
         }
         _loc1_ = GeneralUtils.pointOnCircle(0,0,radius * size,this.loopy);
         _loc1_.x += Math.sin(this.loopy) * 10;
         _loc1_.y -= Math.cos(this.loopy) * 10;
         addParticles(_loc1_.x + body.GetPosition().x * Physics.scale,_loc1_.y + body.GetPosition().y * Physics.scale,1,"sparkle",0,0,0,0);
      }
   }
}

