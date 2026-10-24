package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class PlayRandomSound extends Trigger
   {
      
      public var sfx:Array;
      
      public var vol:Array;
      
      public function PlayRandomSound(param1:Array, param2:Array)
      {
         super();
         this.sfx = param1;
         this.vol = param2;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         var _loc3_:int = int(Math.random() * this.sfx.length);
         sounds.play(this.sfx[_loc3_],body,bodyCenter,this.vol[_loc3_],true);
         ud.triggered = false;
      }
   }
}

