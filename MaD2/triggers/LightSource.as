package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class LightSource extends Trigger
   {
      
      internal var light:Sprite;
      
      public function LightSource()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         var _loc3_:Vector.<Array> = new Vector.<Array>();
         _loc3_.push(["378711",param2.triggerColour]);
         this.light = O.getItem("softglow").updateGraphic(_loc3_);
         this.light.name = "light";
         ud.graphic.addChild(this.light);
         if(!ud.triggered)
         {
            this.light.visible = false;
         }
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = triggerPos;
         _loc3_.Multiply(param2.size);
         if(param2.flipped)
         {
            _loc3_.x *= -1;
         }
         this.light.visible = true;
         this.light.scaleX = this.light.scaleY = param2.size * (triggerRadius / 100);
         this.light.x = _loc3_.x;
         this.light.y = _loc3_.y;
      }
      
      override public function onTrigger() : void
      {
         super.onTrigger();
         this.light.visible = true;
      }
      
      override public function onUntrigger() : void
      {
         super.onUntrigger();
         this.light.visible = false;
      }
   }
}

