package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PFXAngular extends ParticleEffect
   {
      
      public function PFXAngular(param1:b2Body, param2:b2Vec2 = null)
      {
         super(param1,param2);
      }
      
      override protected function init() : void
      {
         initRadius();
      }
      
      override public function update() : void
      {
         var _loc2_:b2Vec2 = null;
         super.update();
         var _loc1_:Number = body.GetAngularVelocity() * size * 0.5;
         if(_loc1_ < 0)
         {
            _loc1_ *= -1;
         }
         if(_loc1_ < 1)
         {
            return;
         }
         _loc2_ = GeneralUtils.pointOnCircle(0,0,_loc1_,Math.random() * 360);
         _loc2_.x += body.GetPosition().x;
         _loc2_.y += body.GetPosition().y;
         addParticles(_loc2_.x * Physics.scale,_loc2_.y * Physics.scale,1,"sparkle",0,0,0,0);
      }
   }
}

