package com.bit101.components
{
   import flash.display.DisplayObjectContainer;
   import flash.text.TextFieldType;
   
   public class HUISlider extends UISlider
   {
      
      public function HUISlider(param1:DisplayObjectContainer = null, param2:Number = 0, param3:Number = 0, param4:String = "", param5:Function = null)
      {
         _sliderClass = HSlider;
         super(param1,param2,param3,param4,param5);
      }
      
      override protected function init() : void
      {
         super.init();
         setSize(50,18);
      }
      
      override protected function positionLabel() : void
      {
         if(_valueLabel.textField.type == TextFieldType.INPUT)
         {
            return;
         }
         _label.x = _slider.x;
         _label.y = _slider.y - _slider.height;
         var _loc1_:Number = _slider.width - _slider.height;
         _valueLabel.x = (_slider.value - _slider.minimum) / (_slider.maximum - _slider.minimum) * _loc1_;
      }
      
      override public function draw() : void
      {
         super.draw();
         _slider.x = 0;
         _slider.width = width;
         _slider.height = height;
         this.positionLabel();
      }
      
      public function toggleExactInput(param1:Boolean) : void
      {
         setExactInput(param1);
      }
   }
}

