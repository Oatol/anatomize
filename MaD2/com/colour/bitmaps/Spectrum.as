package com.colour.bitmaps
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.CapsStyle;
   import flash.display.GradientType;
   import flash.display.JointStyle;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   
   public class Spectrum extends Sprite
   {
      
      public var bmd:BitmapData;
      
      public function Spectrum(param1:Number = 0, param2:Number = 0, param3:Number = 100, param4:Number = 100)
      {
         super();
         this.name = "colourSpectrum";
         this.drawSpectrum(param1,param2,param3,param4);
         this.bmd = new BitmapData(this.width,this.height,false);
         this.bmd.draw(this);
         this.graphics.clear();
         this.addChild(new Bitmap(this.bmd));
      }
      
      public function drawSpectrum(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Matrix = null;
         var _loc12_:Matrix = null;
         var _loc13_:Number = param3;
         var _loc14_:Number = param4;
         var _loc15_:Number = _loc14_ * 0.5;
         var _loc16_:int = 0;
         while(_loc16_ < _loc13_)
         {
            _loc5_ = _loc16_ / _loc13_;
            _loc6_ = -360 * _loc5_ * 0.017453292519943295;
            _loc7_ = Math.cos(_loc6_) * 127 + 128 << 16;
            _loc8_ = Math.cos(_loc6_ + 2 * 3.141592653589793 / 3) * 127 + 128 << 8;
            _loc9_ = Math.cos(_loc6_ + 4 * 3.141592653589793 / 3) * 127 + 128;
            _loc10_ = _loc7_ | _loc8_ | _loc9_;
            _loc11_ = new Matrix();
            _loc11_.createGradientBox(1,_loc15_,3.141592653589793 * 0.5,param1,param2);
            _loc12_ = new Matrix();
            _loc12_.createGradientBox(1,_loc15_,3.141592653589793 * 0.5,param1,param2 + _loc15_);
            this.graphics.lineStyle(1,0,1,true,"normal",CapsStyle.SQUARE,JointStyle.MITER,4);
            this.graphics.lineGradientStyle(GradientType.LINEAR,[16777215,_loc10_],[100,100],[0,255],_loc11_);
            this.graphics.moveTo(param1 + _loc16_,param2);
            this.graphics.lineTo(param1 + _loc16_,param2 + _loc15_);
            this.graphics.lineGradientStyle(GradientType.LINEAR,[_loc10_,0],[100,100],[0,255],_loc12_);
            this.graphics.moveTo(param1 + _loc16_,param2 + _loc15_);
            this.graphics.lineTo(param1 + _loc16_,param2 + _loc14_);
            _loc16_++;
         }
      }
   }
}

