package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import caurina.transitions.Tweener;
   import flash.display.Sprite;
   
   public class Goop extends Trigger
   {
      
      private var decals:Sprite;
      
      private var busy:Boolean = false;
      
      internal var ox:Number;
      
      internal var oy:Number;
      
      public function Goop()
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
         var _loc1_:Number = Math.random() * 4 - 2;
         var _loc2_:b2Vec2 = bodyVel;
         var _loc3_:Number = Math.min(1,Math.abs(_loc2_.x) * 0.05) + (Math.random() * 0.6 - 0.03);
         var _loc4_:Number = Math.min(1,Math.abs(_loc2_.y) * 0.05) + (Math.random() * 0.6 - 0.03);
         var _loc5_:* = this.ox - _loc3_ * 4;
         var _loc6_:* = this.oy - _loc4_ * 4;
         Tweener.addTween(this.decals,{
            "rotation":_loc1_,
            "x":_loc5_,
            "y":_loc6_,
            "scaleX":1 + _loc3_,
            "scaleY":1 + _loc4_,
            "time":0.1,
            "transition":"easeInOutQuint",
            "onComplete":this.wait
         });
      }
      
      private function wait() : void
      {
         this.busy = false;
      }
      
      override public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
         super.OnSharp(param1,param2);
         Body.Damage(body,9999);
      }
      
      override public function OnStick(param1:b2Body) : void
      {
         super.OnStick(param1);
         Body.Damage(body,9999);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         Body.Damage(body,9999);
         return true;
      }
   }
}

