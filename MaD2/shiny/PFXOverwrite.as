package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PFXOverwrite extends ParticleEffect
   {
      
      public function PFXOverwrite(param1:b2Body, param2:b2Vec2 = null)
      {
         super(param1,param2);
         replaceDefault = true;
      }
   }
}

