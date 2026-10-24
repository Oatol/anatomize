package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class SpeakerBox extends Trigger
   {
      
      public function SpeakerBox()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         sounds.play("basscannon_shoot",param1,pixelCenter,1);
         param2.triggered = false;
      }
   }
}

