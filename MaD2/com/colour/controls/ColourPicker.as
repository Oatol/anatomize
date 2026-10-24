package com.colour.controls
{
   import com.colour.bitmaps.HueBar;
   import com.colour.bitmaps.LightnessBar;
   import com.colour.bitmaps.SaturationBar;
   import com.colour.util.ColourUtil;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ColourPicker extends Sprite
   {
      
      public var colour:uint = 3355443;
      
      protected var hueBar:HueBar = null;
      
      protected var satBar:SaturationBar = null;
      
      protected var valBar:LightnessBar = null;
      
      protected var hueSlider:HSlider;
      
      protected var satSlider:HSlider;
      
      protected var valSlider:HSlider;
      
      protected var hueTab:Handle;
      
      protected var satTab:Handle;
      
      protected var valTab:Handle;
      
      protected var barWidth:Number;
      
      protected var barHeight:Number;
      
      protected var barBorder:Number;
      
      protected var tabWidth:Number;
      
      protected var tabHeight:Number;
      
      protected var gutterHeight:Number;
      
      private var lightHandles:Boolean = false;
      
      public function ColourPicker(param1:uint, param2:Number, param3:Number = 8, param4:Number = 2, param5:Number = 10, param6:Number = 20, param7:Number = 2)
      {
         super();
         this.name = "colourPicker";
         this.barWidth = param2;
         this.barHeight = param3;
         this.barBorder = param4;
         this.tabWidth = param5;
         this.tabHeight = param6;
         this.gutterHeight = param7;
         this.hueTab = new Handle(1118481,param5,param6,param4);
         this.satTab = new Handle(1118481,param5,param6,param4);
         this.valTab = new Handle(1118481,param5,param6,param4);
         this.hueSlider = new HSlider(this.hueTab,param2,0,360,180);
         this.hueSlider.y = 0;
         this.satSlider = new HSlider(this.satTab,param2,0,100,50);
         this.satSlider.y = Math.ceil(this.hueSlider.y + this.hueSlider.height * 0.5 + param3 * 0.5 + param7);
         this.valSlider = new HSlider(this.valTab,param2,0,100,100);
         this.valSlider.y = Math.ceil(this.satSlider.y + this.satSlider.height * 0.5 + param3 * 0.5 + param7);
         addChild(this.hueSlider);
         addChild(this.satSlider);
         addChild(this.valSlider);
         this.hueSlider.addEventListener(SliderEvent.SLIDER_EVENT,this.onSlider);
         this.satSlider.addEventListener(SliderEvent.SLIDER_EVENT,this.onSlider);
         this.valSlider.addEventListener(SliderEvent.SLIDER_EVENT,this.onSlider);
      }
      
      public function setColour(param1:uint) : void
      {
         var _loc2_:Array = ColourUtil.hex2hsb(param1);
         this.hueSlider.setValue(_loc2_[0],false);
         this.satSlider.setValue(_loc2_[1],false);
         this.valSlider.setValue(_loc2_[2],false);
         this.colour = param1;
         this.drawHues();
         this.drawSats();
         this.drawVals();
      }
      
      protected function drawHues() : void
      {
         if(this.hueBar != null)
         {
            removeChild(this.hueBar);
         }
         this.hueBar = new HueBar(this.barWidth,this.barHeight,this.satSlider.value,this.valSlider.value);
         this.hueBar.y = this.hueSlider.y + this.hueTab.height * 0.5 - this.barHeight * 0.5;
         this.hueBar.x = Math.ceil(this.hueSlider.x + this.hueTab.width * 0.5);
         this.hueBar.addEventListener(MouseEvent.MOUSE_DOWN,this.moveHue);
         addChildAt(this.hueBar,0);
      }
      
      protected function drawSats() : void
      {
         if(this.satBar != null)
         {
            removeChild(this.satBar);
         }
         this.satBar = new SaturationBar(this.barWidth,this.barHeight,this.hueSlider.value,this.valSlider.value);
         this.satBar.y = this.satSlider.y + this.satTab.height * 0.5 - this.barHeight * 0.5;
         this.satBar.x = Math.ceil(this.satSlider.x + this.satTab.width * 0.5);
         addChildAt(this.satBar,0);
         this.satBar.addEventListener(MouseEvent.MOUSE_DOWN,this.moveSat);
      }
      
      protected function drawVals() : void
      {
         if(this.valBar != null)
         {
            removeChild(this.valBar);
         }
         this.valBar = new LightnessBar(this.barWidth,this.barHeight,this.hueSlider.value,this.satSlider.value);
         this.valBar.y = this.valSlider.y + this.valTab.height * 0.5 - this.barHeight * 0.5;
         this.valBar.x = Math.ceil(this.valSlider.x + this.valTab.width * 0.5);
         addChildAt(this.valBar,0);
         this.valBar.addEventListener(MouseEvent.MOUSE_DOWN,this.moveVal);
      }
      
      protected function moveHue(param1:MouseEvent) : void
      {
         this.hueSlider.setValueToScale(mouseX - this.hueTab.width * 0.5);
      }
      
      protected function moveSat(param1:MouseEvent) : void
      {
         this.satSlider.setValueToScale(mouseX - this.satTab.width * 0.5);
      }
      
      protected function moveVal(param1:MouseEvent) : void
      {
         this.valSlider.setValueToScale(mouseX - this.valTab.width * 0.5);
      }
      
      protected function onSlider(param1:SliderEvent) : void
      {
         var _loc3_:uint = 0;
         switch(param1.target)
         {
            case this.hueSlider:
               this.drawSats();
               this.drawVals();
               break;
            case this.satSlider:
               this.drawHues();
               this.drawVals();
               break;
            case this.valSlider:
               this.drawHues();
               this.drawSats();
         }
         var _loc2_:Boolean = this.lightHandles;
         this.colour = ColourUtil.hsb2hex([this.hueSlider.value,this.satSlider.value,this.valSlider.value]);
         if(ColourUtil.getBrightness(this.colour) < 18000)
         {
            this.lightHandles = true;
         }
         else
         {
            this.lightHandles = false;
         }
         if(this.lightHandles != _loc2_)
         {
            if(this.lightHandles)
            {
               _loc3_ = 16448250;
            }
            else
            {
               _loc3_ = 1118481;
            }
            this.hueTab = new Handle(_loc3_,this.tabWidth,this.tabHeight,this.barBorder);
            this.satTab = new Handle(_loc3_,this.tabWidth,this.tabHeight,this.barBorder);
            this.valTab = new Handle(_loc3_,this.tabWidth,this.tabHeight,this.barBorder);
            this.hueSlider.handle = this.hueTab;
            this.satSlider.handle = this.satTab;
            this.valSlider.handle = this.valTab;
         }
         dispatchEvent(new ColourPickerEvent());
      }
   }
}

