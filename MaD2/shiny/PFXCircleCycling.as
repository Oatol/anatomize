package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PFXCircleCycling extends ParticleEffect
   {
      
      internal var loopy:Number = 0;
      
      public function PFXCircleCycling(param1:b2Body, param2:b2Vec2 = null)
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
         this.loopy += 10 * speed;
         if(this.loopy > 359)
         {
            this.loopy = 0;
         }
         var _loc1_:b2Vec2 = GeneralUtils.pointOnCircle(0,0,radius * size,this.loopy);
         addParticles(_loc1_.x + body.GetPosition().x * Physics.scale,_loc1_.y + body.GetPosition().y * Physics.scale,1,"sparkle",0,0,0,0);
      }
   }
}

