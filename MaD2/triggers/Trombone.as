package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Trombone extends Trigger
   {
      
      public function Trombone()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(!sounds.isPlaying("trombone"))
         {
            sounds.play("trombone",param1,pixelCenter);
         }
         param2.triggered = false;
      }
   }
}

