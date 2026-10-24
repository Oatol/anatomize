package com.colour.bitmaps
{
   import com.colour.util.ColourUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class HueBar extends Sprite
   {
      
      public function HueBar(param1:Number = 100, param2:Number = 10, param3:Number = 100, param4:Number = 100)
      {
         var _loc8_:uint = 0;
         super();
         var _loc5_:BitmapData = new BitmapData(param1,param2,false);
         var _loc6_:Rectangle = new Rectangle(0,0,1,param2);
         var _loc7_:int = 0;
         while(_loc7_ < param1)
         {
            _loc6_.x = _loc7_;
            _loc8_ = ColourUtil.hsb2hex([360 * _loc7_ / (param1 - 1),param3,param4]);
            _loc5_.fillRect(_loc6_,_loc8_);
            _loc7_++;
         }
         addChild(new Bitmap(_loc5_));
      }
   }
}

