package
{
   import Box2D.Common.Math.b2Vec2;
   import flash.desktop.Clipboard;
   import flash.desktop.ClipboardFormats;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.system.System;
   
   public class GeneralUtils
   {
      
      public function GeneralUtils()
      {
         super();
      }
      
      public static function ObjValue(param1:*, param2:*) : *
      {
         if(param2)
         {
            return param2;
         }
         return param1;
      }
      
      public static function isStringVector(param1:String) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         if(param1.indexOf(",") == -1)
         {
            return false;
         }
         return true;
      }
      
      public static function toVec(param1:String) : b2Vec2
      {
         if(!isStringVector(param1))
         {
            return new b2Vec2();
         }
         var _loc2_:Array = param1.split(",");
         return new b2Vec2(Number(_loc2_[0]),Number(_loc2_[1]));
      }
      
      public static function toNumberArray(param1:String, param2:String = ",") : *
      {
         if(!param1)
         {
            return [];
         }
         var _loc3_:Array = param1.split(param2);
         var _loc4_:Array = [];
         for each(param1 in _loc3_)
         {
            _loc4_.push(Number(param1));
         }
         return _loc4_;
      }
      
      public static function toIntArray(param1:String, param2:String = ",") : *
      {
         if(!param1)
         {
            return [];
         }
         var _loc3_:Array = param1.split(param2);
         var _loc4_:Array = [];
         for each(param1 in _loc3_)
         {
            _loc4_.push(int(param1));
         }
         return _loc4_;
      }
      
      public static function toBool(param1:String) : Boolean
      {
         return param1 == "true" || param1 == "1" || param1 == "yes";
      }
      
      public static function isLocal() : Boolean
      {
         var _loc1_:* = false;
         if(Main.instance.stage.loaderInfo.url.search("file://") != -1)
         {
            _loc1_ = true;
         }
         if(Main.instance.stage.loaderInfo.url.search("app:/") != -1)
         {
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      public static function objectToName(param1:String) : String
      {
         var _loc2_:int = R.library_names.indexOf(param1);
         if(_loc2_ == -1)
         {
            return "";
         }
         var _loc3_:String = R.library_objects[_loc2_].label;
         if(!_loc3_)
         {
            return "Square";
         }
         return _loc3_;
      }
      
      public static function nameToObject(param1:String) : String
      {
         var _loc2_:int = int(R.library_objects.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(R.library_objects[_loc3_].label == param1)
            {
               break;
            }
            _loc3_++;
         }
         var _loc4_:String = R.library_names[_loc3_];
         if(!_loc4_)
         {
            return "";
         }
         return _loc4_;
      }
      
      public static function objectToTooltip(param1:String) : String
      {
         var _loc2_:int = R.library_names.indexOf(param1);
         if(_loc2_ == -1)
         {
            return "";
         }
         var _loc3_:String = R.library_objects[_loc2_].tooltip;
         if(!_loc3_)
         {
            return "";
         }
         return _loc3_;
      }
      
      public static function clamp(param1:Number, param2:Number, param3:Number) : Number
      {
         if(param1 > param3)
         {
            return param3;
         }
         if(param1 < param2)
         {
            return param2;
         }
         return param1;
      }
      
      public static function copyToClipboard(param1:String) : void
      {
         if(GameState.isCapable)
         {
            Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,param1);
         }
         else
         {
            System.setClipboard(param1);
         }
      }
      
      public static function arrayToSprite(param1:Array, param2:Number = 1) : Sprite
      {
         var _loc5_:int = 0;
         var _loc3_:Sprite = new Sprite();
         _loc3_.graphics.beginFill(16711680,0.2);
         _loc3_.graphics.lineStyle(1);
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc3_.graphics.moveTo(param1[_loc4_][0][0] * param2,param1[_loc4_][0][1] * param2);
            _loc5_ = 0;
            while(_loc5_ < param1[_loc4_].length)
            {
               _loc3_.graphics.lineTo(param1[_loc4_][_loc5_][0] * param2,param1[_loc4_][_loc5_][1] * param2);
               _loc5_++;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function flipArray(param1:Array) : Array
      {
         var _loc5_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:* = undefined;
         var _loc2_:Array = new Array();
         var _loc3_:* = -9000;
         var _loc4_:* = 9000;
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            _loc7_ = 0;
            while(_loc7_ < param1[_loc5_].length)
            {
               if(param1[_loc5_][_loc7_][0] > _loc3_)
               {
                  _loc3_ = param1[_loc5_][_loc7_][0];
               }
               if(param1[_loc5_][_loc7_][0] < _loc4_)
               {
                  _loc4_ = param1[_loc5_][_loc7_][0];
               }
               _loc7_++;
            }
            _loc5_++;
         }
         var _loc6_:* = (_loc3_ + _loc4_) * 0.5;
         _loc6_ = arrayCentroid(ItemToPoints(param1)).x;
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            _loc2_[_loc5_] = new Array();
            _loc7_ = 0;
            while(_loc7_ < param1[_loc5_].length)
            {
               _loc2_[_loc5_][_loc7_] = new Array();
               _loc8_ = Math.abs(param1[_loc5_][_loc7_][0] - _loc6_);
               if(param1[_loc5_][_loc7_][0] > _loc6_)
               {
                  _loc2_[_loc5_][_loc7_][0] = _loc6_ - _loc8_;
               }
               else
               {
                  _loc2_[_loc5_][_loc7_][0] = _loc6_ + _loc8_;
               }
               _loc2_[_loc5_][_loc7_][1] = param1[_loc5_][_loc7_][1];
               _loc7_++;
            }
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc2_[_loc5_] = _loc2_[_loc5_].reverse();
            _loc5_++;
         }
         return _loc2_;
      }
      
      public static function rotateArray(param1:Array, param2:Number) : Array
      {
         var _loc6_:Number = NaN;
         var _loc7_:* = undefined;
         var _loc3_:Array = new Array();
         var _loc4_:b2Vec2 = arrayCentroid(ItemToPoints(param1));
         var _loc5_:Number = 0;
         while(_loc5_ < param1.length)
         {
            _loc3_[_loc5_] = new Array();
            _loc6_ = 0;
            while(_loc6_ < param1[_loc5_].length)
            {
               _loc3_[_loc5_][_loc6_] = new Array();
               _loc7_ = BoxUtils.rotateVec(new b2Vec2(param1[_loc5_][_loc6_][0],param1[_loc5_][_loc6_][1]),param2 * Vars.toRadians);
               _loc3_[_loc5_][_loc6_][0] = _loc7_.x;
               _loc3_[_loc5_][_loc6_][1] = _loc7_.y;
               _loc6_++;
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public static function stringProperties(param1:Object) : String
      {
         var _loc3_:* = undefined;
         var _loc2_:String = "";
         for(_loc3_ in param1)
         {
            if(param1[_loc3_] is Boolean && param1[_loc3_] == true)
            {
               _loc2_ += _loc3_ + ",";
            }
         }
         return _loc2_.substr(0,-1);
      }
      
      public static function pointOnCircle(param1:Number, param2:Number, param3:Number, param4:Number) : b2Vec2
      {
         var _loc5_:Number = param3 * Math.cos(param4 * Vars.toRadians) + param1;
         var _loc6_:Number = param3 * Math.sin(param4 * Vars.toRadians) + param2;
         return new b2Vec2(_loc5_,_loc6_);
      }
      
      public static function repeatString(param1:String, param2:int) : *
      {
         var _loc3_:String = param1;
         var _loc4_:int = 0;
         while(_loc4_ < param2)
         {
            _loc3_ += param1;
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function getTime() : Number
      {
         return new Date().getTime();
      }
      
      public static function pointInPolygon(param1:Number, param2:Number, param3:Array) : Boolean
      {
         if(!param3)
         {
            return false;
         }
         var _loc4_:Boolean = false;
         var _loc5_:int = int(param3.length);
         var _loc6_:int = _loc5_ - 1;
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_)
         {
            if(param3[_loc7_].y < param2 && param3[_loc6_].y >= param2 || param3[_loc6_].y < param2 && param3[_loc7_].y >= param2)
            {
               if(param3[_loc7_].x + (param2 - param3[_loc7_].y) / (param3[_loc6_].y - param3[_loc7_].y) * (param3[_loc6_].x - param3[_loc7_].x) < param1)
               {
                  _loc4_ = !_loc4_;
               }
            }
            _loc6_ = _loc7_;
            _loc7_++;
         }
         return _loc4_;
      }
      
      public static function ItemToPoints(param1:Array) : Array
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            for each(_loc4_ in _loc3_)
            {
               _loc2_.push(new b2Vec2(_loc4_[0],_loc4_[1]));
            }
         }
         return _loc2_;
      }
      
      public static function arrayCentroid(param1:Array) : b2Vec2
      {
         var _loc2_:b2Vec2 = new b2Vec2();
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_.x += param1[_loc4_].x;
            _loc2_.y += param1[_loc4_].y;
            _loc4_++;
         }
         _loc2_.x /= _loc3_;
         _loc2_.y /= _loc3_;
         return _loc2_;
      }
      
      public static function arrayCentroid2(param1:Array) : Array
      {
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc2_:* = param1.length;
         var _loc3_:Number = -9000;
         var _loc4_:Number = 9000;
         var _loc5_:Number = -9000;
         var _loc6_:Number = 9000;
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         var _loc11_:int = 0;
         while(_loc11_ < _loc2_)
         {
            _loc9_ = Number(param1[_loc11_].x);
            _loc10_ = Number(param1[_loc11_].y);
            _loc7_ += _loc9_;
            _loc8_ += _loc10_;
            if(_loc9_ > _loc3_)
            {
               _loc3_ = _loc9_;
            }
            if(_loc9_ < _loc4_)
            {
               _loc4_ = _loc9_;
            }
            if(_loc10_ > _loc5_)
            {
               _loc5_ = _loc10_;
            }
            if(_loc10_ < _loc6_)
            {
               _loc6_ = _loc10_;
            }
            _loc11_++;
         }
         _loc7_ /= _loc2_;
         _loc8_ /= _loc2_;
         return [new Point(_loc4_,_loc6_),new Point(_loc3_,_loc5_),new Point(_loc7_,_loc8_)];
      }
      
      public static function determinant(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Number
      {
         return param1 * param4 + param3 * param6 + param5 * param2 - param2 * param3 - param4 * param5 - param6 * param1;
      }
      
      public static function interpolateColor(param1:uint, param2:uint, param3:Number) : uint
      {
         var _loc4_:Number = 1 - param3;
         var _loc5_:uint = uint(param1 >> 24 & 0xFF);
         var _loc6_:uint = uint(param1 >> 16 & 0xFF);
         var _loc7_:uint = uint(param1 >> 8 & 0xFF);
         var _loc8_:uint = uint(param1 & 0xFF);
         var _loc9_:uint = uint(param2 >> 24 & 0xFF);
         var _loc10_:uint = uint(param2 >> 16 & 0xFF);
         var _loc11_:uint = uint(param2 >> 8 & 0xFF);
         var _loc12_:uint = uint(param2 & 0xFF);
         var _loc13_:uint = _loc5_ * _loc4_ + _loc9_ * param3;
         var _loc14_:uint = _loc6_ * _loc4_ + _loc10_ * param3;
         var _loc15_:uint = _loc7_ * _loc4_ + _loc11_ * param3;
         var _loc16_:uint = _loc8_ * _loc4_ + _loc12_ * param3;
         return uint(_loc13_ << 24 | _loc14_ << 16 | _loc15_ << 8 | _loc16_);
      }
      
      public static function getYYMMDD() : String
      {
         var _loc1_:Date = new Date();
         var _loc2_:String = String(_loc1_.getFullYear());
         var _loc3_:String = String(_loc1_.getMonth() + 1);
         if(_loc3_.length == 1)
         {
            _loc3_ = "0" + _loc3_;
         }
         var _loc4_:String = String(_loc1_.getDate());
         if(_loc4_.length == 1)
         {
            _loc4_ = "0" + _loc4_;
         }
         return _loc2_ + _loc3_ + _loc4_;
      }
      
      public static function flipBMD(param1:BitmapData, param2:String = "x") : BitmapData
      {
         var _loc4_:Matrix = null;
         var _loc3_:BitmapData = new BitmapData(param1.width,param1.height,true,0);
         if(param2 == "x")
         {
            _loc4_ = new Matrix(-1,0,0,1,param1.width,0);
         }
         else
         {
            _loc4_ = new Matrix(1,0,0,-1,0,param1.height);
         }
         _loc3_.draw(param1,_loc4_,null,null,null,true);
         return _loc3_;
      }
      
      public static function scaleBMD(param1:BitmapData, param2:Number) : BitmapData
      {
         var width:int;
         var height:int;
         var transparent:Boolean;
         var result:BitmapData = null;
         var matrix:Matrix = null;
         var original:BitmapData = param1;
         var scale:Number = param2;
         if(scale < 0)
         {
            scale = -scale;
         }
         width = int(original.width * scale);
         height = int(original.height * scale);
         transparent = original.transparent;
         try
         {
            result = new BitmapData(width,height,transparent,0);
            matrix = new Matrix();
            matrix.scale(scale,scale);
            result.draw(original,matrix,null,null,null,false);
         }
         catch(e:*)
         {
            GameState.ui.showTooltip(GameState.ui.menuMain,"Effects layer failed to generate while scaling. The item may be too large. Try setting the item Stainless if effects aren\'t necessary.\n\n\n\n",0,5000,300);
            return original;
         }
         return result;
      }
      
      public static function lerp(param1:b2Vec2, param2:b2Vec2, param3:Number) : b2Vec2
      {
         return new b2Vec2(param1.x + param3 * (param2.x - param1.x),param1.y + param3 * (param2.y - param1.y));
      }
   }
}

