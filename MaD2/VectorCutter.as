package
{
   import flash.display.GraphicsPath;
   import flash.display.GraphicsPathCommand;
   import flash.display.GraphicsPathWinding;
   import flash.display.GraphicsSolidFill;
   import flash.display.IGraphicsData;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class VectorCutter
   {
      
      public function VectorCutter()
      {
         super();
      }
      
      public function cut(param1:Sprite, param2:Point, param3:Point) : Vector.<Sprite>
      {
         var _loc10_:IGraphicsData = null;
         var _loc11_:Boolean = false;
         var _loc12_:Array = null;
         var _loc13_:GraphicsPath = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Point = null;
         var _loc20_:Point = null;
         var _loc21_:Point = null;
         var _loc22_:GraphicsPath = null;
         var _loc23_:int = 0;
         var _loc24_:Array = null;
         var _loc25_:Vector.<int> = null;
         var _loc26_:Vector.<Number> = null;
         var _loc27_:Point = null;
         if(!GameState.isCapable)
         {
            return null;
         }
         var _loc4_:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
         var _loc5_:Point = param1.globalToLocal(param2);
         var _loc6_:Point = param1.globalToLocal(param3);
         var _loc7_:int = 0;
         var _loc8_:Vector.<IGraphicsData> = param1.graphics.readGraphicsData();
         var _loc9_:int = 0;
         for each(_loc10_ in _loc8_)
         {
            _loc11_ = false;
            _loc12_ = [new Array(),new Array()];
            if(_loc10_ is GraphicsPath)
            {
               _loc13_ = _loc10_ as GraphicsPath;
               _loc14_ = int(_loc13_.commands.length);
               _loc7_ = 0;
               _loc15_ = 0;
               while(_loc15_ < _loc14_)
               {
                  _loc16_ = _loc13_.commands[_loc15_];
                  _loc17_ = _loc13_.data[_loc15_ * 2];
                  _loc18_ = _loc13_.data[_loc15_ * 2 + 1];
                  _loc19_ = new Point(_loc17_,_loc18_);
                  _loc20_ = _loc15_ + 1 < _loc14_ ? new Point(_loc13_.data[(_loc15_ + 1) * 2],_loc13_.data[(_loc15_ + 1) * 2 + 1]) : new Point(_loc13_.data[0],_loc13_.data[1]);
                  _loc21_ = this.crossPoint(_loc5_,_loc6_,_loc19_,_loc20_);
                  _loc12_[0].push(_loc19_);
                  if(_loc21_)
                  {
                     _loc12_[0].push(_loc21_);
                     _loc12_[1].push(_loc21_);
                     _loc12_.reverse();
                     _loc7_++;
                  }
                  _loc15_++;
               }
               if(_loc7_ == 2)
               {
                  _loc11_ = true;
               }
            }
            if(_loc11_)
            {
               _loc23_ = 0;
               while(_loc23_ < 2)
               {
                  _loc22_ = new GraphicsPath();
                  _loc24_ = _loc12_[_loc23_];
                  _loc25_ = new Vector.<int>();
                  _loc26_ = new Vector.<Number>();
                  _loc25_.push(GraphicsPathCommand.MOVE_TO);
                  for each(_loc27_ in _loc24_)
                  {
                     _loc25_.push(GraphicsPathCommand.LINE_TO);
                     _loc26_.push(_loc27_.x,_loc27_.y);
                  }
                  _loc25_ = _loc25_.slice(0,-1);
                  _loc22_.commands = _loc25_;
                  _loc22_.data = _loc26_;
                  _loc22_.winding = GraphicsPath(_loc10_).winding;
                  if(_loc23_ == 1)
                  {
                     _loc4_.push(_loc8_[_loc9_ - 1]);
                  }
                  _loc4_.push(_loc22_);
                  if(_loc23_ == 0)
                  {
                     _loc4_.push(_loc8_[_loc9_ + 1]);
                  }
                  _loc23_++;
               }
            }
            else
            {
               _loc4_.push(_loc10_);
            }
            _loc9_++;
         }
         return this.rebuild(_loc4_,_loc5_,_loc6_);
      }
      
      private function rebuild(param1:Vector.<IGraphicsData>, param2:Point, param3:Point) : Vector.<Sprite>
      {
         var _loc7_:IGraphicsData = null;
         var _loc8_:Vector.<Sprite> = null;
         var _loc9_:GraphicsPath = null;
         var _loc10_:Array = null;
         var _loc11_:int = 0;
         var _loc12_:Point = null;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc4_:Vector.<GraphicsPath> = new Vector.<GraphicsPath>();
         var _loc5_:Sprite = new Sprite();
         var _loc6_:Sprite = new Sprite();
         for each(_loc7_ in param1)
         {
            if(_loc7_ is GraphicsSolidFill)
            {
               _loc5_.graphics.beginFill(GraphicsSolidFill(_loc7_).color,GraphicsSolidFill(_loc7_).alpha);
               _loc6_.graphics.beginFill(GraphicsSolidFill(_loc7_).color,GraphicsSolidFill(_loc7_).alpha);
            }
            else
            {
               if(_loc7_ is GraphicsPath)
               {
                  _loc9_ = _loc7_ as GraphicsPath;
                  if(_loc9_.winding != GraphicsPathWinding.EVEN_ODD)
                  {
                     continue;
                  }
                  _loc10_ = [];
                  _loc11_ = 0;
                  while(_loc11_ < _loc9_.commands.length)
                  {
                     _loc13_ = _loc9_.data[_loc11_ * 2];
                     _loc14_ = _loc9_.data[_loc11_ * 2 + 1];
                     _loc10_.push(new Point(_loc13_,_loc14_));
                     _loc11_++;
                  }
                  _loc12_ = this.arrayCentroid(_loc10_);
                  if(this.isLeft(param2,param3,_loc12_))
                  {
                     _loc5_.graphics.drawPath(_loc9_.commands,_loc9_.data,_loc9_.winding);
                  }
                  else
                  {
                     _loc6_.graphics.drawPath(_loc9_.commands,_loc9_.data,_loc9_.winding);
                  }
               }
               _loc5_.graphics.endFill();
               _loc6_.graphics.endFill();
            }
         }
         _loc8_ = new Vector.<Sprite>();
         _loc8_.push(_loc5_);
         _loc8_.push(_loc6_);
         return _loc8_;
      }
      
      private function crossPoint(param1:Point, param2:Point, param3:Point, param4:Point) : Point
      {
         var _loc5_:Point = param2.subtract(param1);
         var _loc6_:Point = param4.subtract(param3);
         if(this.cross(_loc5_,_loc6_) == 0)
         {
            return null;
         }
         var _loc7_:Number = this.cross(_loc6_,param3.subtract(param1)) / this.cross(_loc6_,_loc5_);
         var _loc8_:Number = this.cross(_loc5_,param1.subtract(param3)) / this.cross(_loc5_,_loc6_);
         if(this.isCross(_loc7_) && this.isCross(_loc8_))
         {
            _loc5_.x *= _loc7_;
            _loc5_.y *= _loc7_;
            return param1.add(_loc5_);
         }
         return null;
      }
      
      private function cross(param1:Point, param2:Point) : Number
      {
         return param1.x * param2.y - param1.y * param2.x;
      }
      
      private function isCross(param1:Number) : Boolean
      {
         return 0 <= param1 && param1 <= 1;
      }
      
      private function isLeft(param1:Point, param2:Point, param3:Point) : Boolean
      {
         return (param2.x - param1.x) * (param3.y - param1.y) - (param2.y - param1.y) * (param3.x - param1.x) > 0;
      }
      
      private function arrayCentroid(param1:Array) : Point
      {
         var _loc2_:Point = new Point();
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
   }
}

