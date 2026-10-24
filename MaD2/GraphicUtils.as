package
{
   import Box2D.Common.b2Color;
   import flash.display.BitmapData;
   import flash.display.GradientType;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   
   public class GraphicUtils
   {
      
      public static var cam:Sprite;
      
      public function GraphicUtils()
      {
         super();
      }
      
      public static function scalehex(param1:uint, param2:Number) : uint
      {
         var _loc3_:int = param1 >> 16 & 0xFF;
         var _loc4_:int = param1 >> 8 & 0xFF;
         var _loc5_:int = param1 & 0xFF;
         _loc3_ = clampInt(_loc3_ * param2);
         _loc4_ = clampInt(_loc4_ * param2);
         _loc5_ = clampInt(_loc5_ * param2);
         return uint(_loc3_ << 16 | _loc4_ << 8 | _loc5_);
      }
      
      public static function camX(param1:Number) : Number
      {
         param1 *= cam.scaleX;
         return param1 + cam.x;
      }
      
      public static function camY(param1:Number) : Number
      {
         param1 *= cam.scaleY;
         return param1 + cam.y;
      }
      
      public static function clampInt(param1:Number, param2:int = 0, param3:int = 255) : int
      {
         if(param1 < param2)
         {
            return param2;
         }
         if(param1 > param3)
         {
            return param3;
         }
         return int(param1);
      }
      
      public static function clamp(param1:Number, param2:int = 0, param3:int = 255) : Number
      {
         if(param1 < param2)
         {
            return param2;
         }
         if(param1 > param3)
         {
            return param3;
         }
         return param1;
      }
      
      public static function LineGradient(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Array, param7:Array, param8:Array) : Sprite
      {
         var _loc9_:Sprite = new Sprite();
         var _loc10_:Number = Math.min(param1,param3);
         var _loc11_:Number = Math.min(param2,param4);
         var _loc12_:Matrix = new Matrix();
         _loc12_.createGradientBox(Math.abs(param3 - param1),Math.abs(param4 - param2),Math.atan2(param4 - param2,param3 - param1),_loc10_,_loc11_);
         _loc9_.graphics.lineStyle(param5);
         _loc9_.graphics.lineGradientStyle(GradientType.LINEAR,param6,param7,param8,_loc12_);
         _loc9_.graphics.moveTo(param1,param2);
         _loc9_.graphics.lineTo(param3,param4);
         return _loc9_;
      }
      
      public static function hexBrightness(param1:uint) : Number
      {
         var _loc2_:Array = hexToRGB(param1);
         var _loc3_:int = int(_loc2_[0]);
         var _loc4_:int = int(_loc2_[1]);
         var _loc5_:int = int(_loc2_[2]);
         return 0.241 * (_loc3_ * _loc3_) + 0.691 * (_loc4_ * _loc4_) + 0.068 * (_loc5_ * _loc5_);
      }
      
      public static function hexToRGB(param1:uint) : Array
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
      
      public static function hexToColour(param1:uint) : b2Color
      {
         var _loc2_:String = param1.toString(16);
         var _loc3_:* = parseInt(_loc2_.substr(0,2),16);
         var _loc4_:* = parseInt(_loc2_.substr(2,2),16);
         var _loc5_:* = parseInt(_loc2_.substr(4,2),16);
         return new b2Color((_loc5_ + 1) * (1 / 256),(_loc4_ + 1) * (1 / 256),(_loc3_ + 1) * (1 / 256));
      }
      
      public static function spectrum(param1:*, param2:*, param3:*, param4:*) : Sprite
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Matrix = null;
         var _loc12_:Matrix = null;
         var _loc13_:Number = NaN;
         var _loc14_:* = param4;
         var _loc15_:* = param3;
         var _loc16_:Sprite = new Sprite();
         _loc13_ = _loc15_ * 0.5;
         var _loc17_:int = 0;
         while(_loc17_ < _loc14_)
         {
            _loc5_ = _loc17_ / _loc14_;
            _loc6_ = -360 * _loc5_ * Vars.toRadians;
            _loc7_ = Math.cos(_loc6_) * 127 + 128 << 16;
            _loc8_ = Math.cos(_loc6_ + 2 * Vars.PI / 3) * 127 + 128 << 8;
            _loc9_ = Math.cos(_loc6_ + 4 * Vars.PI / 3) * 127 + 128;
            _loc10_ = _loc7_ | _loc8_ | _loc9_;
            _loc11_ = new Matrix();
            _loc11_.createGradientBox(1,_loc13_,Vars.PI * 0.5,param2,param1);
            _loc12_ = new Matrix();
            _loc12_.createGradientBox(1,_loc13_,Vars.PI * 0.5,param2,param1 + _loc13_);
            _loc16_.graphics.lineStyle(1,0,1);
            _loc16_.graphics.lineGradientStyle(GradientType.LINEAR,[16777215,_loc10_],[100,100],[0,255],_loc11_);
            _loc16_.graphics.moveTo(param2 + _loc17_,param1);
            _loc16_.graphics.lineTo(param2 + _loc17_,param1 + _loc13_);
            _loc16_.graphics.lineGradientStyle(GradientType.LINEAR,[_loc10_,0],[100,100],[0,255],_loc12_);
            _loc16_.graphics.moveTo(param2 + _loc17_,param1 + _loc13_);
            _loc16_.graphics.lineTo(param2 + _loc17_,param1 + _loc15_);
            _loc17_++;
         }
         return _loc16_;
      }
      
      public static function efla(param1:BitmapData, param2:int, param3:int, param4:int, param5:int, param6:uint, param7:Boolean = true) : void
      {
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Number = NaN;
         if(param7)
         {
            param2 = GraphicUtils.camX(param2);
            param4 = GraphicUtils.camX(param4);
            param3 = GraphicUtils.camY(param3);
            param5 = GraphicUtils.camY(param5);
         }
         var _loc8_:int = param5 - param3;
         var _loc9_:int = param4 - param2;
         if(!_loc9_)
         {
            if(!_loc8_)
            {
               return;
            }
         }
         param1.lock();
         if((_loc8_ ^ _loc8_ >> 31) - (_loc8_ >> 31) > (_loc9_ ^ _loc9_ >> 31) - (_loc9_ >> 31))
         {
            if(_loc8_ < 0)
            {
               _loc12_ = -1;
               _loc11_ = -_loc8_ % 4;
            }
            else
            {
               _loc12_ = 1;
               _loc11_ = _loc8_ % 4;
            }
            _loc13_ = !_loc8_ ? _loc9_ : _loc9_ / _loc8_;
            if(_loc11_)
            {
               param1.setPixel32(param2,param3,param6);
               _loc10_ += _loc12_;
               if(--_loc11_)
               {
                  param1.setPixel32(param2 + _loc10_ * _loc13_,param3 + _loc10_,param6);
                  _loc10_ += _loc12_;
                  if(--_loc11_)
                  {
                     param1.setPixel32(param2 + _loc10_ * _loc13_,param3 + _loc10_,param6);
                     _loc10_ += _loc12_;
                  }
               }
            }
            while(_loc10_ != _loc8_)
            {
               param1.setPixel32(param2 + _loc10_ * _loc13_,param3 + _loc10_,param6);
               _loc10_ += _loc12_;
               param1.setPixel32(param2 + _loc10_ * _loc13_,param3 + _loc10_,param6);
               _loc10_ += _loc12_;
               param1.setPixel32(param2 + _loc10_ * _loc13_,param3 + _loc10_,param6);
               _loc10_ += _loc12_;
               param1.setPixel32(param2 + _loc10_ * _loc13_,param3 + _loc10_,param6);
               _loc10_ += _loc12_;
            }
         }
         else
         {
            if(_loc9_ < 0)
            {
               _loc12_ = -1;
               _loc11_ = -_loc9_ % 4;
            }
            else
            {
               _loc12_ = 1;
               _loc11_ = _loc9_ % 4;
            }
            _loc13_ = !_loc9_ ? _loc8_ : _loc8_ / _loc9_;
            if(_loc11_)
            {
               param1.setPixel32(param2,param3,param6);
               _loc10_ += _loc12_;
               if(--_loc11_)
               {
                  param1.setPixel32(param2 + _loc10_,param3 + _loc10_ * _loc13_,param6);
                  _loc10_ += _loc12_;
                  if(--_loc11_)
                  {
                     param1.setPixel32(param2 + _loc10_,param3 + _loc10_ * _loc13_,param6);
                     _loc10_ += _loc12_;
                  }
               }
            }
            while(_loc10_ != _loc9_)
            {
               param1.setPixel32(param2 + _loc10_,param3 + _loc10_ * _loc13_,param6);
               _loc10_ += _loc12_;
               param1.setPixel32(param2 + _loc10_,param3 + _loc10_ * _loc13_,param6);
               _loc10_ += _loc12_;
               param1.setPixel32(param2 + _loc10_,param3 + _loc10_ * _loc13_,param6);
               _loc10_ += _loc12_;
               param1.setPixel32(param2 + _loc10_,param3 + _loc10_ * _loc13_,param6);
               _loc10_ += _loc12_;
            }
         }
         param1.unlock();
      }
      
      public static function addGraphicToLayer(param1:userData) : void
      {
         var _loc2_:Sprite = param1.graphic;
         if(!param1 || !_loc2_)
         {
            return;
         }
         if(param1.layer == 0)
         {
            Main.instance.backgroundSprite.addChild(_loc2_);
         }
         else if(param1.layer == 1)
         {
            Main.instance.itemSprite.addChild(_loc2_);
         }
         else if(param1.layer == 2)
         {
            Main.instance.foregroundSprite.addChild(_loc2_);
         }
      }
      
      public static function hexToString(param1:uint) : String
      {
         var _loc2_:String = param1.toString(16);
         while(_loc2_.length < 6)
         {
            _loc2_ = "0" + _loc2_;
         }
         return _loc2_;
      }
      
      private function colourToHex(param1:b2Color) : uint
      {
         var _loc2_:* = param1.color.toString(16);
         var _loc3_:* = parseInt(_loc2_.substr(0,2),16);
         var _loc4_:* = parseInt(_loc2_.substr(2,2),16);
         var _loc5_:* = parseInt(_loc2_.substr(4,2),16);
         return this.RGBToHex(_loc5_,_loc4_,_loc3_);
      }
      
      private function RGBToHex(param1:*, param2:*, param3:*) : uint
      {
         param1 = param1.toString(16);
         param2 = param2.toString(16);
         param3 = param3.toString(16);
         if(param1.length == 1)
         {
            param1 = "0" + param1;
         }
         if(param2.length == 1)
         {
            param2 = "0" + param2;
         }
         if(param3.length == 1)
         {
            param3 = "0" + param3;
         }
         return uint("0x" + (param3 + param2 + param1).toUpperCase());
      }
   }
}

