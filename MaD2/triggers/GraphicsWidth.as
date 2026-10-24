package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import caurina.transitions.Tweener;
   import flash.display.Sprite;
   
   public class GraphicsWidth extends Trigger
   {
      
      private var decals:Sprite;
      
      private var busy:Boolean = false;
      
      internal var ox:Number;
      
      internal var oy:Number;
      
      internal var startScaleX:Number = 1;
      
      internal var endScaleX:Number = 1;
      
      internal var startScaleY:Number = 1;
      
      internal var endScaleY:Number = 1;
      
      internal var tweenTime:Number = 1;
      
      internal var offsetX:Number = 0;
      
      internal var offsetY:Number = 0;
      
      public function GraphicsWidth()
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
         var _loc3_:Object = ud.ParseTriggerCustom();
         if(_loc3_["startX"])
         {
            this.startScaleX = _loc3_["startX"];
         }
         if(_loc3_["endX"])
         {
            this.endScaleX = _loc3_["endX"];
         }
         if(_loc3_["startY"])
         {
            this.startScaleY = _loc3_["startY"];
         }
         if(_loc3_["endY"])
         {
            this.endScaleY = _loc3_["endY"];
         }
         if(_loc3_["time"])
         {
            this.tweenTime = _loc3_["time"];
         }
         if(_loc3_["offsetX"])
         {
            this.offsetX = _loc3_["offsetX"];
         }
         if(_loc3_["offsetY"])
         {
            this.offsetY = _loc3_["offsetY"];
         }
         this.wait();
      }
      
      private function animate() : void
      {
         if(GameState.paused)
         {
            return;
         }
         if(this.busy)
         {
            return;
         }
         this.busy = true;
         var _loc1_:* = this.ox + this.endScaleX * this.offsetX;
         var _loc2_:* = this.oy + this.endScaleY * this.offsetY;
         Tweener.addTween(this.decals,{
            "x":_loc1_,
            "y":_loc2_,
            "scaleX":this.endScaleX,
            "scaleY":this.endScaleY,
            "time":this.tweenTime / TimeLord.timerSpeed,
            "transition":"easeInOutQuint",
            "onComplete":this.wait
         });
      }
      
      private function wait() : void
      {
         Tweener.addTween(this.decals,{
            "x":this.ox,
            "y":this.oy,
            "scaleX":this.startScaleX,
            "scaleY":this.startScaleY,
            "time":this.tweenTime / TimeLord.timerSpeed,
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
         this.animate();
         var _loc7_:b2Vec2 = body.GetWorldCenter();
         var _loc8_:b2Vec2 = param1.GetWorldCenter();
         var _loc9_:b2Vec2 = new b2Vec2(_loc7_.x - _loc8_.x,_loc7_.y - _loc8_.y);
         _loc9_.Multiply(-ud.triggerForce * param1.GetMass());
         param1.ApplyForce(_loc9_,_loc8_);
         return true;
      }
   }
}

