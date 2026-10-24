package com.anegmetex.Soundmanager
{
   public dynamic class ageMath
   {
      
      public function ageMath()
      {
         super();
      }
      
      public static function min3(param1:Number, param2:Number, param3:Number) : Number
      {
         return Math.min(param1,Math.min(param2,param3));
      }
      
      public static function max3(param1:Number, param2:Number, param3:Number) : Number
      {
         return Math.max(param1,Math.max(param2,param3));
      }
      
      public static function inRange(param1:Number, param2:Number, param3:Number) : Boolean
      {
         return param1 > param2 && param1 < param3;
      }
      
      public static function trimToRange(param1:Number, param2:Number, param3:Number) : Number
      {
         return param1 > param3 ? param3 : (param1 < param2 ? param2 : param1);
      }
      
      public static function getClosest(param1:Number, param2:Number, param3:Number) : Number
      {
         if(Math.abs(param1 - param2) < Math.abs(param1 - param3))
         {
            return param2;
         }
         return param3;
      }
      
      public static function Random(param1:Number, param2:Number) : Number
      {
         return Math.round(Math.random() * (param2 - param1)) + param1;
      }
      
      public static function RandomInt(param1:int, param2:int) : int
      {
         return Math.round(Random(param1,param2));
      }
      
      public static function aproxEqual(param1:Number, param2:Number, param3:Number = 0.00001) : Boolean
      {
         return Math.abs(param2 - param1) <= param3;
      }
      
      public static function RemapVal(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Number
      {
         return param4 + (param5 - param4) * (param1 - param2) / (param3 - param2);
      }
      
      public static function Lerp(param1:Number, param2:Number, param3:Number) : Number
      {
         return param1 + param3 * (param2 - param1);
      }
      
      public static function Distance(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return Math.sqrt((param1 - param3) * (param1 - param3) + (param2 - param4) * (param2 - param4));
      }
      
      public static function DistanceVec(param1:ageVector, param2:ageVector) : Number
      {
         return Distance(param1.x,param1.y,param2.x,param2.y);
      }
      
      public static function IsLinesCross(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Boolean
      {
         var _loc9_:Number = (param3 - param1) * (param6 - param8) - (param5 - param7) * (param4 - param2);
         if(_loc9_ == 0)
         {
            return false;
         }
         var _loc10_:Number = (param5 - param1) * (param6 - param8) - (param5 - param7) * (param6 - param2);
         var _loc11_:Number = (param3 - param1) * (param6 - param2) - (param5 - param1) * (param4 - param2);
         var _loc12_:Number = _loc10_ / _loc9_;
         var _loc13_:Number = _loc11_ / _loc9_;
         if(_loc12_ >= 0 && _loc12_ <= 1 && _loc13_ >= 0 && _loc13_ <= 1)
         {
            return true;
         }
         return false;
      }
      
      public static function getLinesCross(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : ageVector
      {
         var _loc14_:ageVector = null;
         var _loc9_:Number = (param3 - param1) * (param6 - param8) - (param5 - param7) * (param4 - param2);
         if(_loc9_ == 0)
         {
            return null;
         }
         var _loc10_:Number = (param5 - param1) * (param6 - param8) - (param5 - param7) * (param6 - param2);
         var _loc11_:Number = (param3 - param1) * (param6 - param2) - (param5 - param1) * (param4 - param2);
         var _loc12_:Number = _loc10_ / _loc9_;
         var _loc13_:Number = _loc11_ / _loc9_;
         if(_loc12_ >= 0 && _loc12_ <= 1 && _loc13_ >= 0 && _loc13_ <= 1)
         {
            _loc14_ = new ageVector();
            _loc14_.set(_loc12_ * param3 + (1 - _loc12_) * param1,_loc12_ * param4 + (1 - _loc12_) * param2);
            return _loc14_;
         }
         return null;
      }
      
      public static function getLineCrossRect(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : ageVector
      {
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:ageVector = null;
         var _loc11_:Number = 0;
         var _loc12_:Number = 1;
         _loc9_ = param3 - param1;
         _loc10_ = param4 - param2;
         _loc13_ = -_loc9_;
         _loc14_ = _loc9_;
         _loc15_ = -_loc10_;
         _loc16_ = _loc10_;
         _loc17_ = param1 - param5;
         _loc18_ = param7 - param1;
         _loc19_ = param2 - param6;
         _loc20_ = param8 - param2;
         if(_loc13_ == 0 && _loc17_ < 0 || _loc14_ == 0 && _loc18_ < 0 || _loc15_ == 0 && _loc19_ < 0 || _loc16_ == 0 && _loc20_ < 0)
         {
            return null;
         }
         if(_loc13_ < 0)
         {
            _loc21_ = _loc17_ / _loc13_;
            _loc11_ = Math.max(_loc11_,_loc21_);
         }
         if(_loc14_ < 0)
         {
            _loc22_ = _loc18_ / _loc14_;
            _loc11_ = Math.max(_loc11_,_loc22_);
         }
         if(_loc15_ < 0)
         {
            _loc23_ = _loc19_ / _loc15_;
            _loc11_ = Math.max(_loc11_,_loc23_);
         }
         if(_loc16_ < 0)
         {
            _loc24_ = _loc20_ / _loc16_;
            _loc11_ = Math.max(_loc11_,_loc24_);
         }
         if(_loc13_ > 0)
         {
            _loc21_ = _loc17_ / _loc13_;
            _loc12_ = Math.min(_loc12_,_loc21_);
         }
         if(_loc14_ > 0)
         {
            _loc22_ = _loc18_ / _loc14_;
            _loc12_ = Math.min(_loc12_,_loc22_);
         }
         if(_loc15_ > 0)
         {
            _loc23_ = _loc19_ / _loc15_;
            _loc12_ = Math.min(_loc12_,_loc23_);
         }
         if(_loc16_ > 0)
         {
            _loc24_ = _loc20_ / _loc16_;
            _loc12_ = Math.min(_loc12_,_loc24_);
         }
         if(_loc11_ > _loc12_)
         {
            return null;
         }
         if(_loc11_ == 0 && _loc12_ == 1)
         {
            return null;
         }
         if(_loc11_ < _loc12_ && _loc11_ != 0 && _loc12_ != 1)
         {
            _loc25_ = param1 + _loc9_ * _loc11_;
            _loc26_ = param2 + _loc10_ * _loc11_;
            _loc27_ = param1 + _loc9_ * _loc12_;
            _loc28_ = param2 + _loc10_ * _loc12_;
            _loc29_ = new ageVector();
            if(Distance(_loc25_,_loc26_,param1,param2) < Distance(_loc27_,_loc28_,param1,param2))
            {
               _loc29_.set(_loc25_,_loc26_);
               return _loc29_;
            }
            _loc29_.set(_loc27_,_loc28_);
            return _loc29_;
         }
         return null;
      }
   }
}

