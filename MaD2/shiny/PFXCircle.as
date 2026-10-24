package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PFXCircle extends ParticleEffect
   {
      
      public function PFXCircle(param1:b2Body, param2:b2Vec2 = null)
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
         var _loc1_:b2Vec2 = GeneralUtils.pointOnCircle(0,0,radius * size,Math.random() * 360);
         addParticles(_loc1_.x + body.GetPosition().x * Physics.scale,_loc1_.y + body.GetPosition().y * Physics.scale,1,"sparkle",0,0,0,0);
      }
   }
}

