package com.colour.controls
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class HSlider extends Sprite
   {
      
      private var dragging:Boolean = false;
      
      protected var val:Number;
      
      protected var minVal:Number;
      
      protected var maxVal:Number;
      
      protected var slideWidth:Number;
      
      protected var _handle:Sprite;
      
      protected var lastX:Number;
      
      protected var perPixel:Number;
      
      public function HSlider(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number = 0)
      {
         super();
         this.handle = param1;
         this.slideWidth = param2;
         this.minVal = param3;
         this.maxVal = param4;
         this.perPixel = (param4 - param3) / param2;
         param1.y = 0;
         addChild(param1);
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouse);
         this.value = param5;
         buttonMode = true;
      }
      
      public function set value(param1:Number) : void
      {
         this.setValue(param1);
         this.handle.x = this.slideWidth * (this.val - this.minVal) / (this.maxVal - this.minVal);
      }
      
      public function setValueToScale(param1:Number) : void
      {
         this.setValue(this.perPixel * param1);
         this.handle.x = this.slideWidth * (this.val - this.minVal) / (this.maxVal - this.minVal);
      }
      
      public function setValue(param1:Number, param2:Boolean = true) : void
      {
         if(param1 < this.minVal)
         {
            param1 = this.minVal;
         }
         else if(param1 > this.maxVal)
         {
            param1 = this.maxVal;
         }
         if(this.val != param1)
         {
            this.val = param1;
            if(param2)
            {
               dispatchEvent(new SliderEvent());
            }
         }
         this.handle.x = this.slideWidth * (this.val - this.minVal) / (this.maxVal - this.minVal);
      }
      
      public function get value() : Number
      {
         return this.val;
      }
      
      public function get handle() : Sprite
      {
         return this._handle;
      }
      
      public function set handle(param1:Sprite) : void
      {
         var _loc2_:Number = 0;
         if(this.handle)
         {
            _loc2_ = this.handle.x;
            removeChild(this.handle);
         }
         this._handle = param1;
         addChild(this._handle);
         this._handle.x = _loc2_;
         if(this.dragging)
         {
            this.handle.startDrag(false,new Rectangle(0,0,this.slideWidth));
         }
         this._handle.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouse);
      }
      
      protected function onMouse(param1:MouseEvent) : void
      {
         switch(param1.type)
         {
            case MouseEvent.MOUSE_DOWN:
               this.dragging = true;
               this.handle.startDrag(false,new Rectangle(0,0,this.slideWidth));
               stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouse);
               stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouse);
               return;
            case MouseEvent.MOUSE_UP:
               this.dragging = false;
               this.handle.stopDrag();
               this.setValue(this.perPixel * this.handle.x);
               stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouse);
               stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouse);
               return;
            case MouseEvent.MOUSE_MOVE:
               this.setValue(this.perPixel * this.handle.x);
               return;
            default:
               return;
         }
      }
   }
}

