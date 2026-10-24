package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PFXSpiral extends ParticleEffect
   {
      
      internal var loopdir:Number = 1;
      
      internal var loopdir2:Number = 10;
      
      internal var loopy:Number = 0;
      
      internal var loopy2:Number = 0;
      
      public function PFXSpiral(param1:b2Body, param2:b2Vec2 = null)
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
         this.loopy += this.loopdir * speed;
         this.loopy2 += this.loopdir2 * speed;
         if(this.loopy2 > 360)
         {
            this.loopy2 = 0;
         }
         if(this.loopy > 100)
         {
            this.loopdir *= -1;
         }
         if(this.loopy < 0)
         {
            this.loopdir *= -1;
         }
         var _loc1_:b2Vec2 = GeneralUtils.pointOnCircle(0,0,this.loopy * 0.01 * radius * size,this.loopy2);
         addParticles(_loc1_.x + body.GetPosition().x * Physics.scale,_loc1_.y + body.GetPosition().y * Physics.scale,1,"sparkle",0,0,0,0);
      }
   }
}

