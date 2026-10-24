package
{
   import Box2D.Common.Math.b2Vec2;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class ConvexHull
   {
      
      public function ConvexHull()
      {
         super();
      }
      
      public function convert(param1:Array, param2:Number = 1) : Array
      {
         var _loc6_:* = undefined;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         var _loc5_:int = int(param1.length);
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1[_loc4_];
            _loc7_ = 0;
            _loc8_ = int(_loc6_.length);
            while(_loc7_ < _loc8_)
            {
               _loc3_.push(new Point(_loc6_[_loc7_][0] * param2,_loc6_[_loc7_][1] * param2));
               _loc7_++;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function drawHull(param1:Array, param2:Number, param3:Number, param4:Number, param5:Number, param6:BitmapData, param7:uint = 4294967295) : void
      {
         var _loc8_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:b2Vec2 = null;
         var _loc17_:b2Vec2 = null;
         var _loc18_:uint = 0;
         var _loc9_:int = int(param1.length);
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            _loc10_ = _loc8_ == 0 ? int(_loc9_ - 1) : int(_loc8_ - 1);
            _loc11_ = _loc8_;
            _loc12_ = param1[_loc10_].x / Physics.scale;
            _loc13_ = param1[_loc11_].x / Physics.scale;
            _loc14_ = param1[_loc10_].y / Physics.scale;
            _loc15_ = param1[_loc11_].y / Physics.scale;
            _loc12_ *= param4;
            _loc14_ *= param4;
            _loc13_ *= param4;
            _loc15_ *= param4;
            _loc16_ = BoxUtils.rotateVec(new b2Vec2(_loc12_,_loc14_),param5);
            _loc17_ = BoxUtils.rotateVec(new b2Vec2(_loc13_,_loc15_),param5);
            _loc16_.x = (param2 + _loc16_.x) * Physics.scale;
            _loc16_.y = (param3 + _loc16_.y) * Physics.scale;
            _loc17_.x = (param2 + _loc17_.x) * Physics.scale;
            _loc17_.y = (param3 + _loc17_.y) * Physics.scale;
            _loc18_ = param7;
            GraphicUtils.efla(param6,_loc16_.x,_loc16_.y,_loc17_.x,_loc17_.y,_loc18_);
            _loc8_++;
         }
      }
      
      public function drawHullFilled(param1:Array, param2:Number, param3:Number, param4:Number, param5:uint = 16777215) : Sprite
      {
         var _loc6_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:b2Vec2 = null;
         var _loc14_:b2Vec2 = null;
         var _loc7_:int = int(param1.length);
         param2 += Main.instance.m_sprite.x / Physics.scale;
         param3 += Main.instance.m_sprite.y / Physics.scale;
         var _loc13_:Sprite = new Sprite();
         _loc13_.graphics.beginFill(param5);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc8_ = _loc6_ == 0 ? int(_loc7_ - 1) : int(_loc6_ - 1);
            _loc9_ = _loc6_;
            _loc10_ = Number(param1[_loc8_].x);
            _loc11_ = Number(param1[_loc8_].y);
            _loc10_ *= param4;
            _loc11_ *= param4;
            if(_loc6_ == 0)
            {
               _loc14_ = new b2Vec2(_loc10_,_loc11_);
               _loc13_.graphics.moveTo(_loc10_,_loc11_);
            }
            else
            {
               _loc13_.graphics.lineTo(_loc10_,_loc11_);
            }
            _loc6_++;
         }
         _loc13_.graphics.lineTo(_loc14_.x,_loc14_.y);
         _loc13_.graphics.endFill();
         return _loc13_;
      }
      
      public function convexHull(param1:Array) : Array
      {
         return this.findHull(this.order(param1));
      }
      
      private function order(param1:Array) : Array
      {
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc2_:* = param1[0];
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 1;
         while(_loc4_ < _loc3_)
         {
            if(param1[_loc4_].y < _loc2_.y)
            {
               _loc2_ = param1[_loc4_];
            }
            else if(param1[_loc4_].y == _loc2_.y && param1[_loc4_].x < _loc2_.x)
            {
               _loc2_ = param1[_loc4_];
            }
            _loc4_++;
         }
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         var _loc7_:Array = new Array();
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc9_ = param1[_loc4_].x - _loc2_.x;
            _loc10_ = param1[_loc4_].y - _loc2_.y;
            _loc11_ = _loc10_ / _loc9_;
            if(_loc11_ < 0)
            {
               _loc7_.push({
                  "point":param1[_loc4_],
                  "cotangent":_loc11_
               });
            }
            else
            {
               _loc6_.push({
                  "point":param1[_loc4_],
                  "cotangent":_loc11_
               });
            }
            _loc4_++;
         }
         _loc6_.sortOn("cotangent",Array.NUMERIC | Array.DESCENDING);
         _loc7_.sortOn("cotangent",Array.NUMERIC | Array.DESCENDING);
         _loc5_ = _loc7_.concat(_loc6_);
         var _loc8_:Array = new Array();
         _loc8_.push(_loc2_);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            if(_loc2_ != _loc5_[_loc4_].point)
            {
               _loc8_.push(_loc5_[_loc4_].point);
            }
            _loc4_++;
         }
         return _loc8_;
      }
      
      private function findHull(param1:Array) : Array
      {
         var _loc2_:int = int(param1.length);
         var _loc3_:Array = new Array();
         _loc3_.push(param1[0]);
         _loc3_.push(param1[1]);
         var _loc4_:int = 2;
         while(_loc4_ < _loc2_)
         {
            while(this.direction(_loc3_[_loc3_.length - 2],_loc3_[_loc3_.length - 1],param1[_loc4_]) >= 0)
            {
               _loc3_.pop();
               if(_loc3_.length < 2)
               {
                  break;
               }
            }
            _loc3_.push(param1[_loc4_]);
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function direction(param1:*, param2:*, param3:*) : Number
      {
         return (param2.x - param1.x) * (param3.y - param1.y) - (param2.y - param1.y) * (param3.x - param1.x);
      }
   }
}

