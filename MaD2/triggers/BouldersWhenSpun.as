package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class BouldersWhenSpun extends ProjectilesWhenSpun
   {
      
      public function BouldersWhenSpun()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         param1.SetAngularVelocity(100 * Math.random() * param2.triggerForce - param2.triggerForce * 0.5);
         BoxUtils.randomParticlesOnBody(param1,"fire3",Math.abs(param1.GetAngularVelocity()) * 0.01);
         if(Math.random() > 0.99)
         {
            sounds.play("crash",param1,pixelCenter,Math.random());
         }
      }
   }
}

