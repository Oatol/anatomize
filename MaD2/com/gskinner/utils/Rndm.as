package com.gskinner.utils
{
   public class Rndm
   {
      
      protected static var _instance:Rndm;
      
      protected var _seed:uint = 0;
      
      protected var _currentSeed:uint = 0;
      
      public function Rndm(param1:uint = 1)
      {
         super();
         this._seed = this._currentSeed = param1;
      }
      
      public static function get instance() : Rndm
      {
         if(_instance == null)
         {
            _instance = new Rndm();
         }
         return _instance;
      }
      
      public static function get seed() : uint
      {
         return instance.seed;
      }
      
      public static function set seed(param1:uint) : void
      {
         instance.seed = param1;
      }
      
      public static function get currentSeed() : uint
      {
         return instance.currentSeed;
      }
      
      public static function random() : Number
      {
         return instance.random();
      }
      
      public static function float(param1:Number, param2:Number = NaN) : Number
      {
         return instance.float(param1,param2);
      }
      
      public static function boolean(param1:Number = 0.5) : Boolean
      {
         return instance.boolean(param1);
      }
      
      public static function sign(param1:Number = 0.5) : int
      {
         return instance.sign(param1);
      }
      
      public static function bit(param1:Number = 0.5) : int
      {
         return instance.bit(param1);
      }
      
      public static function integer(param1:Number, param2:Number = NaN) : int
      {
         return instance.integer(param1,param2);
      }
      
      public static function reset() : void
      {
         instance.reset();
      }
      
      public function get seed() : uint
      {
         return this._seed;
      }
      
      public function set seed(param1:uint) : void
      {
         this._seed = this._currentSeed = param1;
      }
      
      public function get currentSeed() : uint
      {
         return this._currentSeed;
      }
      
      public function random() : Number
      {
         return (this._currentSeed = this._currentSeed * 16807 % 2147483647) / 2147483647 + 2.33e-10;
      }
      
      public function float(param1:Number, param2:Number = NaN) : Number
      {
         if(isNaN(param2))
         {
            param2 = param1;
            param1 = 0;
         }
         return this.random() * (param2 - param1) + param1;
      }
      
      public function boolean(param1:Number = 0.5) : Boolean
      {
         return this.random() < param1;
      }
      
      public function sign(param1:Number = 0.5) : int
      {
         return this.random() < param1 ? 1 : -1;
      }
      
      public function bit(param1:Number = 0.5) : int
      {
         return this.random() < param1 ? 1 : 0;
      }
      
      public function integer(param1:Number, param2:Number = NaN) : int
      {
         if(isNaN(param2))
         {
            param2 = param1;
            param1 = 0;
         }
         return Math.floor(this.float(param1,param2));
      }
      
      public function reset() : void
      {
         this._seed = this._currentSeed;
      }
   }
}

