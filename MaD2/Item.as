package
{
   import Box2D.Common.Math.b2Vec2;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   
   public class Item
   {
      
      public var name:String;
      
      public var creator:String;
      
      public var scale:Number;
      
      public var vertices:Array;
      
      public var colours:Array;
      
      public var alphas:Array;
      
      public var hull:Array;
      
      public var graphic:Sprite;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var left:Number;
      
      private var right:Number;
      
      private var top:Number;
      
      private var bottom:Number;
      
      private var _centroid:b2Vec2;
      
      private var convexhull:ConvexHull;
      
      public var processed:Boolean = false;
      
      public function Item(param1:String, param2:Number, param3:Array, param4:Array, param5:Array)
      {
         super();
         this.name = param1;
         this.scale = param2;
         this.vertices = param3;
         this.colours = param4;
         this.alphas = param5;
      }
      
      public function ProcessData() : *
      {
         var _loc4_:Array = null;
         if(this.processed)
         {
            return;
         }
         this.processed = true;
         this.convexhull = new ConvexHull();
         this.hull = this.convexhull.convexHull(this.convexhull.convert(this.vertices));
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         for(; _loc2_ < this.vertices.length; _loc2_++)
         {
            if(this.colours[_loc2_] is ShapeUserData)
            {
               if(ShapeUserData(this.colours[_loc2_]).decorative)
               {
                  continue;
               }
            }
            for each(_loc4_ in this.vertices[_loc2_])
            {
               _loc1_.push(new b2Vec2(_loc4_[0],_loc4_[1]));
            }
         }
         var _loc3_:Array = BoxUtils.verticeDimensions(_loc1_);
         this.width = _loc3_[0] * this.scale;
         this.height = _loc3_[1] * this.scale;
         this.left = Point(_loc3_[2]).x * this.scale;
         this.top = Point(_loc3_[2]).y * this.scale;
         this.right = Point(_loc3_[3]).x * this.scale;
         this.bottom = Point(_loc3_[3]).y * this.scale;
         this.centroid = GeneralUtils.arrayCentroid(_loc1_);
      }
      
      public function updateGraphic(param1:Vector.<Array> = null, param2:* = false) : Sprite
      {
         var _loc6_:uint = 0;
         var _loc8_:* = undefined;
         var _loc9_:String = null;
         var _loc10_:Number = NaN;
         var _loc11_:Array = null;
         var _loc12_:DropShadowFilter = null;
         if(!this.processed)
         {
            this.ProcessData();
         }
         var _loc3_:Sprite = new Sprite();
         var _loc4_:int = 0;
         var _loc5_:Array = this.vertices.slice();
         if(param2)
         {
            _loc5_ = GeneralUtils.flipArray(_loc5_);
         }
         _loc3_.graphics.moveTo(_loc5_[0][0][0] * this.scale,_loc5_[0][0][1] * this.scale);
         if(!param1)
         {
            param1 = new Vector.<Array>();
         }
         var _loc7_:* = int(_loc5_.length - 1);
         for(; _loc7_ >= 0; _loc7_--)
         {
            _loc8_ = _loc5_[_loc7_];
            if(this.colours[_loc7_] is userData || this.colours[_loc7_] is ShapeUserData)
            {
               _loc9_ = this.colours[_loc7_].name;
               if(this.colours[_loc7_] is ShapeUserData)
               {
                  if(ShapeUserData(this.colours[_loc7_]).invisible)
                  {
                     continue;
                  }
               }
            }
            else
            {
               _loc9_ = this.colours[_loc7_];
            }
            _loc6_ = BoxUtils.shapeNameToColour(_loc9_,param1);
            _loc10_ = Tweak.FillAlpha;
            if(Boolean(this.alphas) && this.alphas.length > 0)
            {
               _loc10_ = Number(this.alphas[_loc7_]);
            }
            _loc3_.graphics.beginFill(_loc6_,_loc10_);
            _loc3_.graphics.moveTo(_loc8_[0][0] * this.scale,_loc8_[0][1] * this.scale);
            for each(_loc11_ in _loc8_)
            {
               _loc3_.graphics.lineTo(_loc11_[0] * this.scale,_loc11_[1] * this.scale);
            }
            _loc3_.graphics.lineTo(_loc8_[0][0] * this.scale,_loc8_[0][1] * this.scale);
            _loc3_.graphics.endFill();
         }
         if(!World.toggleSpawnBG)
         {
            _loc12_ = new DropShadowFilter(2,45,3355443,1,2,2);
            _loc3_.filters = [_loc12_];
         }
         _loc3_.x = this.width >> 1;
         _loc3_.y = this.height >> 1;
         return _loc3_;
      }
      
      public function get width() : Number
      {
         return this._width;
      }
      
      public function set width(param1:Number) : void
      {
         this._width = param1;
      }
      
      public function get height() : Number
      {
         return this._height;
      }
      
      public function set height(param1:Number) : void
      {
         this._height = param1;
      }
      
      public function get centroid() : b2Vec2
      {
         return this._centroid;
      }
      
      public function set centroid(param1:b2Vec2) : void
      {
         this._centroid = param1;
      }
   }
}

