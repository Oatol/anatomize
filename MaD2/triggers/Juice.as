package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Juice extends Trigger
   {
      
      public function Juice()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         var _loc3_:String = param2.name;
         GameState.particles.addSimpleParticles(pixelCenter.x,pixelCenter.y,1,uint("0xFF" + _loc3_),bodyVel.x * 0.01,bodyVel.y * 0.01,0,0);
      }
   }
}

