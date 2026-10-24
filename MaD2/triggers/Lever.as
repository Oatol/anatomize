package triggers
{
   import Box2D.Dynamics.b2Body;
   import caurina.transitions.Tweener;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.Sprite;
   
   public class Lever extends Trigger
   {
      
      internal var busy:Boolean = false;
      
      public function Lever()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         this.triggerconnected(true);
         if(this.busy)
         {
            return;
         }
         param2.triggerState *= -1;
         param2.triggered = false;
         sounds.play("launch",param1,pixelCenter,0.3);
         this.animate();
      }
      
      private function animate() : void
      {
         var _loc1_:Sprite = ud.graphic.getChildByName("decals") as Sprite;
         Tweener.addTween(_loc1_,{
            "rotation":(ud.triggerState == 1 ? 30 : -30),
            "time":ud.triggerDuration * 0.01,
            "onComplete":this.trigg,
            "transition":"easeInExpo"
         });
         this.busy = true;
      }
      
      override public function onUntrigger() : void
      {
         super.onUntrigger();
         this.animate();
      }
      
      private function trigg() : void
      {
         this.busy = false;
         this.triggerconnected(false);
      }
      
      private function triggerconnected(param1:Boolean) : void
      {
         var _loc3_:b2Body = null;
         var _loc5_:userData = null;
         if(ud.connected.length == 0)
         {
            return;
         }
         var _loc2_:int = int(ud.connected.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = ud.connected[_loc4_];
            if(_loc3_)
            {
               _loc5_ = userData(_loc3_.GetUserData());
               _loc5_.triggered = param1;
            }
            _loc4_++;
         }
      }
   }
}

