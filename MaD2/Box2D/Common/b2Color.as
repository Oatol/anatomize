package Box2D.Common
{
   import Box2D.Common.Math.*;
   
   public class b2Color
   {
      
      private var _r:uint = 0;
      
      private var _g:uint = 0;
      
      private var _b:uint = 0;
      
      public function b2Color(param1:Number, param2:Number, param3:Number)
      {
         super();
         this._r = uint(255 * b2Math.b2Clamp(param1,0,1));
         this._g = uint(255 * b2Math.b2Clamp(param2,0,1));
         this._b = uint(255 * b2Math.b2Clamp(param3,0,1));
      }
      
      public function Set(param1:Number, param2:Number, param3:Number) : void
      {
         this._r = uint(255 * b2Math.b2Clamp(param1,0,1));
         this._g = uint(255 * b2Math.b2Clamp(param2,0,1));
         this._b = uint(255 * b2Math.b2Clamp(param3,0,1));
      }
      
      public function set r(param1:Number) : void
      {
         this._r = uint(255 * b2Math.b2Clamp(param1,0,1));
      }
      
      public function set g(param1:Number) : void
      {
         this._g = uint(255 * b2Math.b2Clamp(param1,0,1));
      }
      
      public function set b(param1:Number) : void
      {
         this._b = uint(255 * b2Math.b2Clamp(param1,0,1));
      }
      
      public function get color() : uint
      {
         return this._r | this._g << 8 | this._b << 16;
      }
      
      public function get stringcolour() : String
      {
         var _loc1_:* = this._r.toString(16);
         var _loc2_:* = this._g.toString(16);
         var _loc3_:* = this._b.toString(16);
         if(_loc1_.length == 1)
         {
            _loc1_ = "0" + _loc1_;
         }
         if(_loc2_.length == 1)
         {
            _loc2_ = "0" + _loc2_;
         }
         if(_loc3_.length == 1)
         {
            _loc3_ = "0" + _loc3_;
         }
         return (_loc3_ + _loc2_ + _loc1_).toUpperCase();
      }
   }
}

