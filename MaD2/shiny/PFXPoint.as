package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PFXPoint extends ParticleEffect
   {
      
      public function PFXPoint(param1:b2Body, param2:b2Vec2 = null)
      {
         super(param1,param2);
      }
      
      override public function update() : void
      {
         super.update();
         addParticles(body.GetPosition().x * Physics.scale,body.GetPosition().y * Physics.scale,1,"sparkle",0,0,0,0);
      }
   }
}

