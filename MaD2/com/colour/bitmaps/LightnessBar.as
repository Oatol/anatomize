package com.colour.bitmaps
{
   import com.colour.util.ColourUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class LightnessBar extends Sprite
   {
      
      public function LightnessBar(param1:Number = 100, param2:Number = 10, param3:Number = 360, param4:Number = 100)
      {
         var _loc8_:Number = NaN;
         var _loc9_:uint = 0;
         super();
         var _loc5_:BitmapData = new BitmapData(param1,param2,false);
         var _loc6_:Rectangle = new Rectangle(0,0,1,param2);
         var _loc7_:int = 0;
         while(_loc7_ < param1)
         {
            _loc6_.x = _loc7_;
            _loc8_ = 100 * _loc7_ / (param1 - 1);
            _loc9_ = ColourUtil.hsb2hex([param3,param4,_loc8_]);
            _loc5_.fillRect(_loc6_,_loc9_);
            _loc7_++;
         }
         addChild(new Bitmap(_loc5_));
      }
   }
}

