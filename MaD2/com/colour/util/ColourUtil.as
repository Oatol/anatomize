package com.colour.util
{
   public class ColourUtil
   {
      
      public function ColourUtil()
      {
         super();
      }
      
      public static function getBrightness(param1:uint) : Number
      {
         var _loc2_:Array = hex2rgb(param1);
         var _loc3_:int = int(_loc2_[0]);
         var _loc4_:int = int(_loc2_[1]);
         var _loc5_:int = int(_loc2_[2]);
         return 0.241 * (_loc3_ * _loc3_) + 0.691 * (_loc4_ * _loc4_) + 0.068 * (_loc5_ * _loc5_);
      }
      
      public static function hex2rgb(param1:uint) : Array
      {
         var _loc2_:Array = new Array();
         _loc2_[0] = param1 >> 16;
         _loc2_[1] = param1 >> 8 & 0xFF;
         _loc2_[2] = param1 & 0xFF;
         if(_loc2_[0] < 0)
         {
            _loc2_[0] += 256;
         }
         return _loc2_;
      }
      
      public static function rgb2hex(param1:Array) : uint
      {
         return uint(param1[0] << 16 ^ param1[1] << 8 ^ param1[2]);
      }
      
      public static function hsb2rgb(param1:Array) : Array
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         param1[0] %= 360;
         if(param1[2] == 0)
         {
            return new Array(0,0,0);
         }
         param1[1] /= 100;
         param1[2] /= 100;
         param1[0] /= 60;
         _loc5_ = Math.floor(param1[0]);
         _loc6_ = param1[0] - _loc5_;
         _loc7_ = param1[2] * (1 - param1[1]);
         _loc8_ = param1[2] * (1 - param1[1] * _loc6_);
         _loc9_ = param1[2] * (1 - param1[1] * (1 - _loc6_));
         if(_loc5_ == 0)
         {
            _loc2_ = Number(param1[2]);
            _loc3_ = _loc9_;
            _loc4_ = _loc7_;
         }
         else if(_loc5_ == 1)
         {
            _loc2_ = _loc8_;
            _loc3_ = Number(param1[2]);
            _loc4_ = _loc7_;
         }
         else if(_loc5_ == 2)
         {
            _loc2_ = _loc7_;
            _loc3_ = Number(param1[2]);
            _loc4_ = _loc9_;
         }
         else if(_loc5_ == 3)
         {
            _loc2_ = _loc7_;
            _loc3_ = _loc8_;
            _loc4_ = Number(param1[2]);
         }
         else if(_loc5_ == 4)
         {
            _loc2_ = _loc9_;
            _loc3_ = _loc7_;
            _loc4_ = Number(param1[2]);
         }
         else if(_loc5_ == 5)
         {
            _loc2_ = Number(param1[2]);
            _loc3_ = _loc7_;
            _loc4_ = _loc8_;
         }
         _loc2_ = Math.floor(_loc2_ * 255);
         _loc3_ = Math.floor(_loc3_ * 255);
         _loc4_ = Math.floor(_loc4_ * 255);
         return new Array(_loc2_,_loc3_,_loc4_);
      }
      
      public static function rgb2hsb(param1:Array) : Array
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         param1[0] /= 255;
         param1[1] /= 255;
         param1[2] /= 255;
         _loc2_ = Math.min(param1[0],param1[1],param1[2]);
         _loc7_ = Math.max(param1[0],param1[1],param1[2]);
         if(_loc2_ == _loc7_)
         {
            return new Array(0,0,_loc7_ * 100);
         }
         _loc3_ = param1[0] == _loc2_ ? param1[1] - param1[2] : (param1[1] == _loc2_ ? param1[2] - param1[0] : param1[0] - param1[1]);
         _loc4_ = param1[0] == _loc2_ ? 3 : (param1[1] == _loc2_ ? 5 : 1);
         _loc5_ = Math.floor((_loc4_ - _loc3_ / (_loc7_ - _loc2_)) * 60) % 360;
         _loc6_ = Math.floor((_loc7_ - _loc2_) / _loc7_ * 100);
         _loc7_ = Math.floor(_loc7_ * 100);
         return new Array(_loc5_,_loc6_,_loc7_);
      }
      
      public static function hsb2hex(param1:Array) : uint
      {
         var _loc2_:Array = hsb2rgb(param1);
         return rgb2hex(_loc2_);
      }
      
      public static function hex2hsb(param1:uint) : Array
      {
         var _loc2_:Array = hex2rgb(param1);
         return rgb2hsb(_loc2_);
      }
      
      public static function hex2matrix(param1:uint, param2:Number) : Array
      {
         var _loc3_:Array = [];
         _loc3_ = _loc3_.concat([((param1 & 0xFF0000) >>> 16) / 255,0,0,0,0]);
         _loc3_ = _loc3_.concat([0,((param1 & 0xFF00) >>> 8) / 255,0,0,0]);
         _loc3_ = _loc3_.concat([0,0,(param1 & 0xFF) / 255,0,0]);
         return _loc3_.concat([0,0,0,param2 / 100,0]);
      }
   }
}

