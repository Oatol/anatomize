package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class AerosolCan extends Trigger
   {
      
      public function AerosolCan()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         Body.Destroy(param1,"aerosol");
         World.explode("gas",pixelCenter,triggerForce * param2.size,param2.triggerRadius * param2.size,false,0);
         var _loc3_:String = "gas";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc3_ = param2.pfx.getParticle();
         }
         var _loc4_:int = 0;
         while(_loc4_ < 200 * param2.size)
         {
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,_loc3_,0,0,10 * param2.size,10 * param2.size);
            _loc4_++;
         }
      }
   }
}

