package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import caurina.transitions.Tweener;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.Sprite;
   
   public class DuelButton extends Trigger
   {
      
      private var decals:Sprite;
      
      private var busy:Boolean = false;
      
      internal var ox:Number;
      
      internal var oy:Number;
      
      public function DuelButton()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         if(!this.decals)
         {
            this.decals = param2.graphic.getChildByName("decals") as Sprite;
            this.ox = this.decals.x;
            this.oy = this.decals.y;
         }
      }
      
      private function animate() : void
      {
         if(GameState.paused)
         {
            return;
         }
         var _loc1_:Number = 0.5;
         var _loc2_:* = this.oy + _loc1_ * 12;
         Tweener.addTween(this.decals,{
            "y":_loc2_,
            "scaleY":_loc1_,
            "time":0.1 / TimeLord.timerSpeed,
            "transition":"easeInOutQuint",
            "onComplete":this.wait
         });
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(!sounds.isPlaying("whaawhaa"))
         {
            ud.triggered = false;
         }
         var _loc3_:Number = (Math.random() > 0.5 ? -10 : 10) * ud.size;
         var _loc4_:Number = pixelCenter.y;
         GameState.particles.addParticles(pixelCenter.x + _loc3_,_loc4_,1,"water",Math.random() * _loc3_,Math.random() * -5 - 2);
         body.ApplyForce(new b2Vec2(Math.random() * 1000 - 500,Math.random() * 1000 - 500),bodyCenter);
      }
      
      private function wait() : void
      {
         var _loc1_:b2Body = null;
         sounds.play("whaawhaa",body,pixelCenter);
         for each(_loc1_ in ud.connected)
         {
            userData(_loc1_.GetUserData()).triggered = true;
         }
         ud.triggered = true;
         Tweener.addTween(this.decals,{
            "y":this.oy,
            "scaleY":1,
            "time":2.5,
            "transition":"easeInOutQuint"
         });
         this.busy = false;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param1.IsStatic())
         {
            return true;
         }
         if(sounds.isPlaying("whaawhaa"))
         {
            return true;
         }
         if(param3.name == "b72d2d")
         {
            this.animate();
         }
         return true;
      }
   }
}

