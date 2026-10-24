package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class StarDust extends UltraSharp
   {
      
      public function StarDust()
      {
         super(20,"42abe7");
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(bodyVel.Length() < 2)
         {
            return;
         }
         var _loc3_:String = "blink";
         if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
         {
            _loc3_ = ud.pfx.getParticle();
         }
         GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,_loc3_);
      }
   }
}

