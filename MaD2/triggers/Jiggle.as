package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import caurina.transitions.Tweener;
   import flash.display.Sprite;
   
   public class Jiggle extends Trigger
   {
      
      private var decals:Sprite;
      
      private var busy:Boolean = false;
      
      internal var ox:Number;
      
      internal var oy:Number;
      
      public function Jiggle()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(!this.decals)
         {
            this.decals = param2.graphic.getChildByName("decals") as Sprite;
            this.ox = this.decals.x;
            this.oy = this.decals.y;
         }
         if(!this.busy)
         {
            this.animate();
         }
      }
      
      private function animate() : void
      {
         if(GameState.paused)
         {
            return;
         }
         var _loc1_:Number = Math.random() * 12 - 6;
         var _loc2_:b2Vec2 = bodyVel;
         var _loc3_:Number = Math.min(1,Math.abs(_loc2_.x) * 0.1) + (Math.random() * 0.1 - 0.05);
         var _loc4_:Number = Math.min(1,Math.abs(_loc2_.y) * 0.1) + (Math.random() * 0.1 - 0.05);
         var _loc5_:* = this.ox - _loc3_ * 10;
         var _loc6_:* = this.oy - _loc4_ * 10;
         Tweener.addTween(this.decals,{
            "rotation":_loc1_,
            "x":_loc5_,
            "y":_loc6_,
            "scaleX":1 + _loc3_,
            "scaleY":1 + _loc4_,
            "time":0.025,
            "transition":"easeInOutQuint",
            "onComplete":this.wait
         });
      }
      
      private function wait() : void
      {
         this.busy = false;
      }
   }
}

