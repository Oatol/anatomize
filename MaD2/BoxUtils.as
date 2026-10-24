package
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.Joints.b2JointEdge;
   import Box2D.Dynamics.b2Body;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import triggers.Concussion;
   import triggers.Electrified;
   
   public class BoxUtils
   {
      
      private static var physScale:Number = Physics.scale;
      
      public function BoxUtils()
      {
         super();
      }
      
      public static function AlignSelectedBodies(param1:b2Body, param2:Vector.<b2Body>, param3:String) : void
      {
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Body = null;
         if(!param1 || param2.length < 2)
         {
            return;
         }
         var _loc4_:b2Vec2 = param1.GetPosition();
         for each(_loc6_ in param2)
         {
            if(param3 == "X")
            {
               _loc5_ = new b2Vec2(_loc4_.x,_loc6_.GetPosition().y);
            }
            else
            {
               _loc5_ = new b2Vec2(_loc6_.GetPosition().x,_loc4_.y);
            }
            _loc6_.SetXForm(_loc5_,_loc6_.GetAngle());
         }
      }
      
      public static function bodyDimensions(param1:b2Body) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc9_:b2CircleShape = null;
         var _loc10_:Number = NaN;
         var _loc11_:b2PolygonShape = null;
         var _loc12_:int = 0;
         var _loc4_:Number = -9000;
         var _loc5_:Number = 9000;
         var _loc6_:Number = -9000;
         var _loc7_:Number = 9000;
         var _loc8_:b2Shape = param1.GetShapeList();
         while(_loc8_)
         {
            if(_loc8_.GetType() == 0)
            {
               _loc9_ = _loc8_ as b2CircleShape;
               _loc10_ = _loc9_.GetRadius();
               if(_loc10_ > _loc4_)
               {
                  _loc4_ = _loc10_;
               }
               if(_loc10_ < _loc5_)
               {
                  _loc5_ = _loc10_;
               }
               if(_loc10_ > _loc6_)
               {
                  _loc6_ = _loc10_;
               }
               if(_loc10_ < _loc7_)
               {
                  _loc7_ = _loc10_;
               }
            }
            else
            {
               _loc11_ = _loc8_ as b2PolygonShape;
               _loc2_ = _loc11_.GetVertexCount();
               _loc3_ = _loc11_.GetVertices();
               _loc12_ = 0;
               while(_loc12_ < _loc2_)
               {
                  if(_loc3_[_loc12_].x > _loc4_)
                  {
                     _loc4_ = Number(_loc3_[_loc12_].x);
                  }
                  if(_loc3_[_loc12_].x < _loc5_)
                  {
                     _loc5_ = Number(_loc3_[_loc12_].x);
                  }
                  if(_loc3_[_loc12_].y > _loc6_)
                  {
                     _loc6_ = Number(_loc3_[_loc12_].y);
                  }
                  if(_loc3_[_loc12_].y < _loc7_)
                  {
                     _loc7_ = Number(_loc3_[_loc12_].y);
                  }
                  _loc12_++;
               }
            }
            _loc8_ = _loc8_.GetNext();
         }
         return [(_loc4_ - _loc5_) * physScale,(_loc6_ - _loc7_) * physScale];
      }
      
      public static function verticeDimensions(param1:Array) : Array
      {
         var _loc2_:* = param1.length;
         var _loc3_:Number = -9000;
         var _loc4_:Number = 9000;
         var _loc5_:Number = -9000;
         var _loc6_:Number = 9000;
         var _loc7_:int = 0;
         while(_loc7_ < _loc2_)
         {
            if(param1[_loc7_].x > _loc3_)
            {
               _loc3_ = Number(param1[_loc7_].x);
            }
            if(param1[_loc7_].x < _loc4_)
            {
               _loc4_ = Number(param1[_loc7_].x);
            }
            if(param1[_loc7_].y > _loc5_)
            {
               _loc5_ = Number(param1[_loc7_].y);
            }
            if(param1[_loc7_].y < _loc6_)
            {
               _loc6_ = Number(param1[_loc7_].y);
            }
            _loc7_++;
         }
         return [_loc3_ - _loc4_,_loc5_ - _loc6_,new Point(_loc4_,_loc6_),new Point(_loc3_,_loc5_)];
      }
      
      public static function arrayDimensions(param1:Array) : Array
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
         return verticeDimensions(_loc2_);
      }
      
      public static function verticeArea(param1:Array) : Number
      {
         var _loc2_:Number = param1.length;
         var _loc3_:Number = 0;
         var _loc4_:* = 0;
         while(_loc4_ < _loc2_)
         {
            if(_loc4_ == _loc2_ - 1)
            {
               _loc3_ += param1[_loc4_].x * param1[0].y - param1[0].x * param1[_loc4_].y;
            }
            else
            {
               _loc3_ += param1[_loc4_].x * param1[_loc4_ + 1].y - param1[_loc4_ + 1].x * param1[_loc4_].y;
            }
            _loc4_++;
         }
         return _loc3_ * 0.5;
      }
      
      public static function selectCompound(param1:b2Body, param2:Boolean = true) : Array
      {
         var _loc4_:b2Body = null;
         var _loc6_:b2Body = null;
         var _loc7_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc3_:Array = [param1];
         var _loc5_:Array = [];
         var _loc8_:int = 0;
         while(_loc8_ < _loc3_.length)
         {
            _loc4_ = _loc3_[_loc8_];
            _loc7_ = 9000;
            while(_loc7_ > 0)
            {
               _loc5_ = connections(_loc4_,param2);
               _loc9_ = int(_loc5_.length);
               _loc7_ = 0;
               _loc10_ = 0;
               while(_loc10_ < _loc9_)
               {
                  _loc6_ = _loc5_[_loc10_];
                  if(_loc3_.indexOf(_loc6_) == -1)
                  {
                     _loc3_.push(_loc6_);
                     _loc7_++;
                  }
                  _loc10_++;
               }
            }
            _loc8_++;
         }
         return _loc3_;
      }
      
      public static function connections(param1:b2Body, param2:Boolean = true) : Array
      {
         var _loc5_:b2Body = null;
         var _loc6_:b2Body = null;
         var _loc3_:Array = [];
         var _loc4_:b2JointEdge = param1.GetJointList();
         while(_loc4_)
         {
            if(_loc4_.joint.GetUserData().name != "mouse")
            {
               if(_loc4_.joint.GetUserData().name != "weak")
               {
                  if(_loc4_.joint.GetUserData().name != "snarejoint")
                  {
                     if(_loc4_.joint.GetUserData().name != "grapplejoint")
                     {
                        if(_loc4_.joint.GetUserData().name != "stabjoint")
                        {
                           if(!(!param2 && _loc4_.joint.GetUserData().name == "equip"))
                           {
                              _loc5_ = _loc4_.joint.GetBody1();
                              _loc6_ = _loc4_.joint.GetBody2();
                              if(!(_loc5_ == Physics.world.GetGroundBody() || _loc6_ == Physics.world.GetGroundBody()))
                              {
                                 if(_loc3_.indexOf(_loc5_) == -1 && _loc5_ != param1)
                                 {
                                    _loc3_.push(_loc5_);
                                 }
                                 if(_loc3_.indexOf(_loc6_) == -1 && _loc6_ != param1)
                                 {
                                    _loc3_.push(_loc6_);
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
            _loc4_ = _loc4_.next;
         }
         return _loc3_;
      }
      
      public static function rectangleArray(param1:Number, param2:Number) : Array
      {
         return [[[-param1 / 2,-param2 / 2],[param1 / 2,-param2 / 2],[param1 / 2,param2 / 2],[-param1 / 2,param2 / 2]]];
      }
      
      public static function bodyCentroid(param1:b2Body) : b2Vec2
      {
         var _loc3_:int = 0;
         var _loc5_:Array = null;
         var _loc7_:b2PolygonShape = null;
         var _loc8_:int = 0;
         var _loc2_:b2Vec2 = new b2Vec2();
         var _loc4_:int = 0;
         var _loc6_:b2Shape = param1.GetShapeList();
         while(_loc6_)
         {
            _loc7_ = _loc6_ as b2PolygonShape;
            _loc5_ = _loc7_.GetVertices();
            _loc3_ = _loc7_.GetVertexCount();
            _loc4_ += _loc3_;
            _loc8_ = 0;
            while(_loc8_ < _loc3_)
            {
               _loc2_.x += _loc5_[_loc8_].x;
               _loc2_.y += _loc5_[_loc8_].y;
               _loc8_++;
            }
            _loc6_ = _loc6_.GetNext();
         }
         _loc2_.x /= _loc4_;
         _loc2_.y /= _loc4_;
         return _loc2_;
      }
      
      public static function checkLineCollision2(param1:b2Vec2, param2:b2Vec2, param3:b2Vec2, param4:b2Vec2) : Boolean
      {
         var _loc5_:Number = (param2.x - param1.x) * (param4.y - param3.y) - (param2.y - param1.y) * (param4.x - param3.x);
         var _loc6_:Number = (param1.y - param3.y) * (param4.x - param3.x) - (param1.x - param3.x) * (param4.y - param3.y);
         var _loc7_:Number = (param1.y - param3.y) * (param2.x - param1.x) - (param1.x - param3.x) * (param2.y - param1.y);
         if(_loc5_ == 0)
         {
            return false;
         }
         var _loc8_:Number = _loc6_ / _loc5_;
         var _loc9_:Number = _loc7_ / _loc5_;
         return _loc8_ >= 0 && _loc8_ <= 1 && (_loc9_ >= 0 && _loc9_ <= 1);
      }
      
      public static function checkLineCollision(param1:b2Vec2, param2:b2Vec2, param3:b2Vec2, param4:b2Vec2) : Boolean
      {
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc5_:Number = param1.x;
         var _loc6_:Number = param1.y;
         var _loc7_:Number = param2.x;
         var _loc8_:Number = param2.y;
         var _loc9_:Number = param3.x;
         var _loc10_:Number = param3.y;
         var _loc11_:Number = param4.x;
         var _loc12_:Number = param4.y;
         if(_loc5_ != _loc7_)
         {
            _loc13_ = (_loc8_ - _loc6_) / (_loc7_ - _loc5_);
         }
         if(_loc9_ != _loc11_)
         {
            _loc15_ = (_loc12_ - _loc10_) / (_loc11_ - _loc9_);
         }
         if(_loc13_ == _loc15_)
         {
            return false;
         }
         _loc14_ = -_loc13_ * _loc5_ + _loc6_;
         _loc16_ = -_loc15_ * _loc9_ + _loc10_;
         var _loc17_:* = (_loc16_ - _loc14_) / (_loc13_ - _loc15_);
         var _loc18_:* = _loc13_ * _loc17_ + _loc14_;
         if(_loc5_ == _loc7_)
         {
            _loc17_ = _loc5_;
         }
         if(_loc9_ == _loc11_)
         {
            _loc17_ = _loc9_;
         }
         if(_loc5_ >= _loc17_ && _loc7_ <= _loc17_ || _loc5_ <= _loc17_ && _loc7_ >= _loc17_ && (_loc6_ >= _loc18_ && _loc8_ <= _loc18_) || _loc6_ <= _loc18_ && _loc8_ >= _loc18_)
         {
            _loc18_ = _loc15_ * _loc17_ + _loc16_;
            if(_loc9_ >= _loc17_ && _loc11_ <= _loc17_ || _loc9_ <= _loc17_ && _loc11_ >= _loc17_ && (_loc10_ >= _loc18_ && _loc12_ <= _loc18_) || _loc10_ <= _loc18_ && _loc12_ >= _loc18_)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function vectorDist(param1:b2Vec2, param2:b2Vec2) : Number
      {
         return (param1.x - param2.x) * (param1.x - param2.x) + (param1.y - param2.y) * (param1.y - param2.y);
      }
      
      public static function closerVector(param1:b2Vec2, param2:b2Vec2, param3:b2Vec2) : Boolean
      {
         return vectorDist(param1,param2) < vectorDist(param1,param3);
      }
      
      public static function rotateAroundPoint(param1:b2Vec2, param2:Number, param3:*) : *
      {
         var _loc6_:b2Body = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:* = undefined;
         var _loc4_:Number = Math.cos(param2);
         var _loc5_:Number = Math.sin(param2);
         for each(_loc6_ in param3)
         {
            _loc7_ = _loc6_.GetPosition().x - param1.x;
            _loc8_ = _loc6_.GetPosition().y - param1.y;
            _loc9_ = new b2Vec2(_loc4_ * _loc7_ - _loc5_ * _loc8_ + param1.x,_loc4_ * _loc8_ + _loc5_ * _loc7_ + param1.y);
            _loc6_.SetXForm(_loc9_,param2);
         }
      }
      
      public static function scaleVectorArray(param1:Array, param2:Number) : Array
      {
         var _loc3_:int = int(param1.length);
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_[_loc5_] = new b2Vec2(param1[_loc5_].x * param2,param1[_loc5_].y * param2);
            _loc5_++;
         }
         return _loc4_;
      }
      
      public static function shiftVectorArray(param1:Array, param2:b2Vec2) : Array
      {
         var _loc3_:int = int(param1.length);
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_[_loc5_] = new b2Vec2(param1[_loc5_].x + param2.x,param1[_loc5_].y + param2.y);
            _loc5_++;
         }
         return _loc4_;
      }
      
      public static function arrangeClockwise(param1:Array) : Array
      {
         var _loc3_:Number = NaN;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         var _loc2_:int = int(param1.length);
         var _loc4_:* = 1;
         var _loc5_:* = int(_loc2_ - 1);
         var _loc6_:Array = new Array(_loc2_);
         param1.sort(clockwiseSort);
         _loc6_[0] = param1[0];
         _loc7_ = param1[0];
         _loc8_ = param1[_loc2_ - 1];
         var _loc9_:* = 1;
         while(_loc9_ < _loc2_ - 1)
         {
            _loc3_ = GeneralUtils.determinant(_loc7_.x,_loc7_.y,_loc8_.x,_loc8_.y,param1[_loc9_].x,param1[_loc9_].y);
            if(_loc3_ < 0)
            {
               var _loc10_:Number;
               _loc6_[_loc10_ = _loc4_++] = param1[_loc9_];
            }
            else
            {
               _loc6_[_loc10_ = _loc5_--] = param1[_loc9_];
            }
            _loc9_++;
         }
         _loc6_[_loc4_] = param1[_loc2_ - 1];
         return _loc6_;
      }
      
      private static function clockwiseSort(param1:b2Vec2, param2:b2Vec2) : Number
      {
         if(param1.x > param2.x)
         {
            return 1;
         }
         if(param1.x < param2.x)
         {
            return -1;
         }
         return 0;
      }
      
      public static function bodyToVertices(param1:b2Body) : Array
      {
         var _loc2_:Array = null;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:b2Vec2 = null;
         var _loc3_:Array = [];
         var _loc5_:b2Shape = param1.GetShapeList();
         while(_loc5_)
         {
            if(_loc5_.GetType() == b2Shape.e_polygonShape)
            {
               _loc2_ = b2PolygonShape(_loc5_).GetVertices();
               _loc4_ = b2PolygonShape(_loc5_).GetVertexCount();
               _loc6_ = 0;
               while(_loc6_ < _loc4_)
               {
                  if(_loc2_[_loc6_])
                  {
                     _loc7_ = b2Vec2(_loc2_[_loc6_]).Copy();
                     _loc7_.Multiply(Physics.scale);
                     _loc3_.push(_loc7_);
                  }
                  _loc6_++;
               }
            }
            _loc5_ = _loc5_.GetNext();
         }
         return _loc3_;
      }
      
      public static function bodyToSprite(param1:b2Body, param2:Number) : Sprite
      {
         var itemPic:Sprite;
         var arr:Array;
         var s:b2Shape;
         var stainsEnabled:Boolean;
         var vertices:Array = null;
         var l:int = 0;
         var bud:userData = null;
         var col:uint = 0;
         var skin:Vector.<Array> = null;
         var sud:ShapeUserData = null;
         var invis:Boolean = false;
         var fillA:Number = NaN;
         var lineA:Number = NaN;
         var i:int = 0;
         var dim:Array = null;
         var arrc:Array = null;
         var bmdw:int = 0;
         var bmdh:int = 0;
         var effectHolder:Bitmap = null;
         var body:b2Body = param1;
         var size:Number = param2;
         var spr:Sprite = new Sprite();
         bud = userData(body.GetUserData());
         if(bud.graphic)
         {
            spr = bud.graphic;
         }
         itemPic = new Sprite();
         itemPic.name = "item";
         arr = [];
         if(bud.skin)
         {
            skin = bud.skin;
         }
         else
         {
            skin = new Vector.<Array>();
         }
         s = body.GetShapeList();
         while(s)
         {
            if(s.GetType() == b2Shape.e_polygonShape)
            {
               sud = ShapeUserData(s.GetUserData());
               vertices = b2PolygonShape(s).GetVertices();
               l = b2PolygonShape(s).GetVertexCount();
               invis = false;
               if(Boolean(sud) && sud.invisible)
               {
                  invis = true;
               }
               col = shapeNameToColour(sud.name,skin);
               fillA = 1;
               lineA = 1;
               fillA = sud.alpha;
               if(fillA < 1)
               {
                  lineA = 0;
               }
               if(invis)
               {
                  fillA = 0.01;
                  lineA = 0;
               }
               if(!invis)
               {
                  itemPic.graphics.beginFill(col,fillA);
               }
               if(!invis)
               {
                  itemPic.graphics.moveTo(vertices[0].x * Physics.scale,vertices[0].y * Physics.scale);
               }
               i = 0;
               while(i < l)
               {
                  if(vertices[i])
                  {
                     arr.push(new b2Vec2(vertices[i].x * Physics.scale,vertices[i].y * Physics.scale));
                     if(!invis)
                     {
                        itemPic.graphics.lineTo(vertices[i].x * Physics.scale,vertices[i].y * Physics.scale);
                     }
                  }
                  i++;
               }
               if(!invis)
               {
                  itemPic.graphics.lineTo(vertices[0].x * Physics.scale,vertices[0].y * Physics.scale);
               }
               itemPic.graphics.endFill();
               itemPic.graphics.lineStyle();
            }
            s = s.GetNext();
         }
         spr.addChild(itemPic);
         stainsEnabled = true;
         if(bud.stainless)
         {
            stainsEnabled = false;
         }
         if(Boolean(bud && bud.width > 0 && bud.height > 0) && Boolean(World.toggleEffects == 1) && stainsEnabled)
         {
            dim = BoxUtils.bodyDimensions(body);
            arrc = GeneralUtils.arrayCentroid2(arr);
            updateBodyDimensions(body);
            bmdw = int(bud.width + 2);
            bmdh = int(bud.height + 2);
            effectHolder = new Bitmap();
            effectHolder.name = "effects";
            try
            {
               effectHolder.bitmapData = new BitmapData(bmdw,bmdh,true,0);
               effectHolder.cacheAsBitmap = true;
               effectHolder.x += arrc[0].x - 1;
               effectHolder.y += arrc[0].y - 1;
            }
            catch(e:*)
            {
               GameState.ui.showTooltip(GameState.ui.menuMain,"Effects layer failed to generate for " + bud.name + ". It may be too large.\n\n",0,2000,200);
            }
            spr.addChild(effectHolder);
         }
         spr.mouseChildren = false;
         spr.mouseEnabled = false;
         return spr;
      }
      
      public static function getEffectBMD(param1:b2Body) : BitmapData
      {
         if(World.toggleEffects == 0)
         {
            return null;
         }
         if(!param1)
         {
            return null;
         }
         if(!userData(param1.GetUserData()))
         {
            return null;
         }
         if(userData(param1.GetUserData()).stainless)
         {
            return null;
         }
         if(!userData(param1.GetUserData()).graphic)
         {
            return null;
         }
         if(!userData(param1.GetUserData()).graphic.getChildByName("effects"))
         {
            return null;
         }
         return Bitmap(userData(param1.GetUserData()).graphic.getChildByName("effects")).bitmapData;
      }
      
      public static function getEffectBM(param1:b2Body) : Bitmap
      {
         if(World.toggleEffects == 0)
         {
            return null;
         }
         if(!userData(param1.GetUserData()))
         {
            return null;
         }
         if(!userData(param1.GetUserData()).graphic)
         {
            return null;
         }
         if(!userData(param1.GetUserData()).graphic.getChildByName("effects"))
         {
            return null;
         }
         return Bitmap(userData(param1.GetUserData()).graphic.getChildByName("effects"));
      }
      
      public static function shapeNameToColour(param1:String, param2:Vector.<Array> = null) : uint
      {
         var _loc3_:uint = 0;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(!param1)
         {
            return 16711935;
         }
         var _loc4_:RegExp = /^[A-Fa-f0-9]*$/;
         if(!_loc4_.test(param1))
         {
            _loc3_ = 7829367;
         }
         else
         {
            _loc3_ = uint("0x" + param1);
         }
         if(Boolean(param2) && param2.length > 0)
         {
            _loc5_ = [];
            _loc6_ = [];
            _loc7_ = 0;
            while(_loc7_ < param2.length)
            {
               _loc5_.push(uint("0x" + param2[_loc7_][0]));
               _loc6_.push(uint("0x" + param2[_loc7_][1]));
               _loc7_++;
            }
            _loc8_ = _loc5_.indexOf(_loc3_);
            if(_loc8_ != -1)
            {
               _loc3_ = uint(_loc6_[_loc8_]);
            }
         }
         return _loc3_;
      }
      
      public static function rotateVec(param1:b2Vec2, param2:Number) : b2Vec2
      {
         var _loc3_:Number = param1.x;
         var _loc4_:Number = param1.y;
         var _loc5_:Number = Math.cos(param2);
         var _loc6_:Number = Math.sin(param2);
         return new b2Vec2(_loc3_ * _loc5_ - _loc4_ * _loc6_,_loc3_ * _loc6_ + _loc4_ * _loc5_);
      }
      
      public static function rotateVecAroundPoint(param1:b2Vec2, param2:Number, param3:b2Vec2) : *
      {
         var _loc4_:Number = param1.x - param3.x;
         var _loc5_:Number = param1.y - param3.y;
         var _loc6_:Number = Math.cos(param2);
         var _loc7_:Number = Math.sin(param2);
         return new b2Vec2(_loc6_ * _loc4_ - _loc7_ * _loc5_ + param3.x,_loc6_ * _loc5_ + _loc7_ * _loc4_ + param3.y);
      }
      
      public static function pixelPosition(param1:b2Body) : b2Vec2
      {
         var _loc2_:b2Vec2 = param1.GetPosition().Copy();
         _loc2_.Multiply(Physics.scale);
         return _loc2_;
      }
      
      public static function pixelPos(param1:b2Vec2) : b2Vec2
      {
         var _loc2_:b2Vec2 = param1.Copy();
         _loc2_.Multiply(Physics.scale);
         return _loc2_;
      }
      
      public static function updateBodyDimensions(param1:b2Body) : void
      {
         var _loc2_:Array = BoxUtils.bodyDimensions(param1);
         userData(param1.GetUserData()).width = _loc2_[0];
         userData(param1.GetUserData()).height = _loc2_[1];
      }
      
      public static function drawCompoundHealthBar(param1:b2Body) : void
      {
         var _loc3_:userData = null;
         var _loc6_:b2Body = null;
         var _loc8_:b2Body = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:userData = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:int = 0;
         var _loc15_:uint = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc2_:Array = BoxUtils.selectCompound(param1);
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc7_:b2Vec2 = new b2Vec2(Main.instance.m_sprite.x,Main.instance.m_sprite.y);
         for each(_loc8_ in _loc2_)
         {
            _loc3_ = userData(_loc8_.GetUserData());
            if(_loc3_.alive)
            {
               if(!_loc3_.hasBeenCut)
               {
                  _loc4_ += _loc3_.health;
                  if(_loc3_.parentmaxhealth)
                  {
                     _loc5_ += _loc3_.parentmaxhealth;
                     _loc9_ = _loc3_.parentmaxhealth;
                  }
                  else
                  {
                     _loc5_ += _loc3_.maxhealth;
                     _loc9_ = _loc3_.maxhealth;
                  }
                  if(_loc3_.name == "doll_head")
                  {
                     _loc6_ = _loc8_;
                  }
                  if(World.toggleDollicons == 1)
                  {
                     drawStatus(_loc8_,_loc3_.health / _loc9_);
                  }
               }
            }
         }
         if(_loc6_)
         {
            _loc10_ = _loc4_ / _loc5_;
            _loc11_ = userData(_loc6_.GetUserData());
            if(World.toggleDollbars)
            {
               _loc12_ = _loc6_.GetPosition().x * Physics.scale;
               _loc13_ = _loc6_.GetPosition().y * Physics.scale;
               _loc14_ = 80 * Vars.barscale * Main.instance.cam.scaleX;
               _loc15_ = 4278255360;
               _loc16_ = 0;
               while(_loc16_ < _loc14_)
               {
                  if(_loc16_ / _loc14_ > _loc10_)
                  {
                     _loc15_ = 4294901760;
                  }
                  _loc17_ = 19 * Main.instance.cam.scaleX;
                  Main.instance.particlesBMD.setPixel32(GraphicUtils.camX(_loc12_) - (_loc14_ >> 1) + _loc16_ + _loc7_.x,GraphicUtils.camY(_loc13_) + _loc7_.y - _loc17_,_loc15_);
                  Main.instance.particlesBMD.setPixel32(GraphicUtils.camX(_loc12_) - (_loc14_ >> 1) + _loc16_ + _loc7_.x,GraphicUtils.camY(_loc13_) + _loc7_.y - _loc17_ + 1,_loc15_);
                  Main.instance.particlesBMD.setPixel32(GraphicUtils.camX(_loc12_) - (_loc14_ >> 1) + _loc16_ + _loc7_.x,GraphicUtils.camY(_loc13_) + _loc7_.y - _loc17_ + 2,_loc15_);
                  _loc16_++;
               }
            }
            if(World.toggleDollicons == 1)
            {
               drawStatus(_loc6_,_loc10_);
            }
         }
      }
      
      private static function drawStatus(param1:b2Body, param2:Number) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:b2Vec2 = null;
         var _loc8_:* = undefined;
         var _loc9_:BitmapData = null;
         var _loc3_:String = "";
         var _loc4_:userData = param1.GetUserData() as userData;
         if(_loc4_.name == "doll_head")
         {
            if(param2 < 0.2)
            {
               _loc3_ = "status_dead";
            }
            else if(param2 < 0.5)
            {
               _loc3_ = "status_halfdead";
            }
         }
         else if(param2 < 0.5)
         {
            _loc3_ = "status_crippled";
         }
         if(_loc3_ == "")
         {
            if(_loc4_.trigger is Concussion)
            {
               _loc3_ = "status_concussed";
            }
            else if(_loc4_.trigger is Electrified)
            {
               _loc3_ = "status_shocked";
            }
         }
         if(_loc3_ != "")
         {
            _loc5_ = param1.GetPosition().x * Physics.scale;
            _loc6_ = param1.GetPosition().y * Physics.scale;
            _loc7_ = new b2Vec2(Main.instance.m_sprite.x,Main.instance.m_sprite.y);
            _loc8_ = 0;
            if(World.toggleHealthbars == 1)
            {
               _loc8_ = 4;
            }
            _loc9_ = R.getSprite(_loc3_);
            Main.instance.particlesBMD.draw(_loc9_,new Matrix(1,0,0,1,GraphicUtils.camX(_loc5_) + _loc7_.x - _loc9_.width * 0.5,GraphicUtils.camY(_loc6_) + _loc7_.y - _loc9_.height * 0.5 - _loc8_));
         }
      }
      
      public static function drawHealthBar(param1:b2Body) : void
      {
         var _loc2_:userData = userData(param1.GetUserData());
         if(Boolean(_loc2_.armour) && World.toggleArmourbars == 0)
         {
            return;
         }
         if(_loc2_.armoured && World.toggleArmourbars == 1)
         {
            return;
         }
         if(_loc2_.armour)
         {
            param1 = _loc2_.armour.attachedBody;
            if(!param1 || userData(param1.GetUserData()).dead)
            {
               return;
            }
         }
         var _loc3_:b2Vec2 = param1.GetPosition().Copy();
         _loc3_.Multiply(Physics.scale);
         var _loc4_:int = 20 * Vars.barscale * Main.instance.cam.scaleX;
         var _loc5_:Number = _loc2_.health;
         if(_loc2_.parentmaxhealth != 0)
         {
            _loc5_ /= _loc2_.parentmaxhealth;
         }
         else
         {
            _loc5_ /= _loc2_.maxhealth;
         }
         var _loc6_:int = _loc3_.x >> 0;
         var _loc7_:int = _loc3_.y >> 0;
         var _loc8_:b2Vec2 = new b2Vec2(Main.instance.m_sprite.x,Main.instance.m_sprite.y);
         var _loc9_:uint = 4278255360;
         var _loc10_:* = 0;
         if(_loc2_.armour)
         {
            _loc9_ = 4278229503;
            _loc10_ = 0;
         }
         if(World.toggleDollicons == 1)
         {
            _loc10_ = 6;
         }
         var _loc11_:int = 0;
         while(_loc11_ < _loc4_)
         {
            if(_loc11_ / _loc4_ > _loc5_)
            {
               _loc9_ = 4294901760;
            }
            Main.instance.particlesBMD.setPixel32(GraphicUtils.camX(_loc6_) - (_loc4_ >> 1) + _loc11_ + _loc8_.x,GraphicUtils.camY(_loc7_) + _loc8_.y + _loc10_,_loc9_);
            Main.instance.particlesBMD.setPixel32(GraphicUtils.camX(_loc6_) - (_loc4_ >> 1) + _loc11_ + _loc8_.x,GraphicUtils.camY(_loc7_) + _loc8_.y + 1 + _loc10_,_loc9_);
            _loc11_++;
         }
      }
      
      public static function replaceSkinColour(param1:Vector.<Array>, param2:String, param3:String) : Vector.<Array>
      {
         var _loc4_:Vector.<Array> = param1.slice();
         var _loc5_:* = _loc4_.length;
         var _loc6_:Boolean = true;
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_)
         {
            if(String(param1[_loc7_][0]).toLowerCase() == param2.toLowerCase())
            {
               _loc6_ = false;
               break;
            }
            _loc7_++;
         }
         if(_loc6_)
         {
            return param1;
         }
         _loc4_.splice(_loc7_,1);
         _loc4_.push([param2,param3]);
         return _loc4_;
      }
      
      public static function getSkinColour(param1:Vector.<Array>, param2:String) : uint
      {
         var _loc5_:String = null;
         if(!param1)
         {
            return uint("0x" + param2);
         }
         var _loc3_:* = param1.length;
         if(_loc3_ == 0)
         {
            return uint("0x" + param2);
         }
         param2 = param2.toLowerCase();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = String(param1[_loc4_][0]).toLowerCase();
            if(_loc5_ == param2 || param2.indexOf(_loc5_) != -1)
            {
               return uint("0x" + param1[_loc4_][1]);
            }
            _loc4_++;
         }
         return 16711935;
      }
      
      public static function setSkinColour(param1:Vector.<Array>, param2:String, param3:String) : void
      {
         if(param3 == "FF00FF")
         {
            return;
         }
         var _loc4_:* = param1.length;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            if(String(param1[_loc6_][0]).toLowerCase() == param2.toLowerCase())
            {
               param1[_loc6_][1] = param3;
               _loc5_ = true;
            }
            _loc6_++;
         }
         if(!_loc5_)
         {
            param1.push([param2,param3]);
         }
      }
      
      public static function AoEParticles(param1:b2Body, param2:String, param3:Number = 1, param4:Boolean = false) : Vector.<MyLittleParticle>
      {
         var _loc10_:b2Vec2 = null;
         var _loc11_:Vector.<MyLittleParticle> = null;
         var _loc5_:userData = param1.GetUserData();
         var _loc6_:Number = _loc5_.triggerRadius;
         if(param4)
         {
            _loc6_ *= Math.random();
         }
         var _loc7_:b2Vec2 = param1.GetPosition();
         var _loc8_:Vector.<MyLittleParticle> = new Vector.<MyLittleParticle>();
         var _loc9_:int = 0;
         while(_loc9_ < param3)
         {
            _loc10_ = GeneralUtils.pointOnCircle(_loc7_.x * Physics.scale,_loc7_.y * Physics.scale,_loc6_,Math.random() * 360);
            _loc11_ = GameState.particles.addParticles(_loc10_.x,_loc10_.y,1,param2,0,0,2,2);
            if((Boolean(_loc11_)) && Boolean(_loc11_[0]))
            {
               _loc8_.push(_loc11_[0]);
            }
            _loc9_++;
         }
         return _loc8_;
      }
      
      public static function randomSlopeParticles(param1:String, param2:b2Vec2, param3:b2Vec2, param4:Number = 20, param5:Number = 2, param6:Number = 0.05) : Vector.<MyLittleParticle>
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Vector.<MyLittleParticle> = null;
         var _loc7_:Number = (param3.y - param2.y) / (param3.x - param2.x);
         if(param4 > 100)
         {
            param4 = 100;
         }
         var _loc8_:Vector.<MyLittleParticle> = new Vector.<MyLittleParticle>();
         var _loc9_:int = 0;
         while(_loc9_ < param4)
         {
            _loc10_ = param2.x + _loc9_ / param4 * (param3.x - param2.x);
            _loc11_ = param2.y + _loc7_ * (_loc10_ - param2.x);
            _loc12_ = GameState.particles.addParticles(_loc10_,_loc11_,1,param1,(-param2.x + _loc10_) * param6,(-param2.y + _loc11_) * param6,param5,param5);
            if((Boolean(_loc12_)) && Boolean(_loc12_[0]))
            {
               _loc8_.push(_loc12_[0]);
            }
            _loc9_++;
         }
         return _loc8_;
      }
      
      public static function randomPointOnBody(param1:b2Body, param2:Boolean = false) : b2Vec2
      {
         if(!param1.GetUserData() || !param1.GetUserData().hull)
         {
            return new b2Vec2();
         }
         var _loc3_:userData = userData(param1.GetUserData());
         var _loc4_:Number = Math.random() * param1.GetUserData().width - param1.GetUserData().width * 0.5;
         var _loc5_:Number = Math.random() * param1.GetUserData().height - param1.GetUserData().height * 0.5;
         var _loc6_:int = 0;
         while(!GeneralUtils.pointInPolygon(_loc4_,_loc5_,param1.GetUserData().hull) && _loc6_ < 10)
         {
            _loc4_ = Math.random() * _loc3_.width - _loc3_.width * 0.5;
            _loc5_ = Math.random() * _loc3_.height - _loc3_.height * 0.5;
            _loc6_++;
         }
         var _loc7_:Number = param1.GetPosition().x * Physics.scale + _loc4_ * Math.cos(param1.GetAngle()) - _loc5_ * Math.sin(param1.GetAngle());
         var _loc8_:Number = param1.GetPosition().y * Physics.scale + _loc4_ * Math.sin(param1.GetAngle()) + _loc5_ * Math.cos(param1.GetAngle());
         if(param2)
         {
            return new b2Vec2(_loc7_,_loc8_);
         }
         return new b2Vec2(_loc7_ / Physics.scale,_loc8_ / Physics.scale);
      }
      
      public static function randomParticlesOnBody(param1:b2Body, param2:String, param3:Number = 2) : Vector.<MyLittleParticle>
      {
         if(!param1.GetUserData() || !param1.GetUserData().hull)
         {
            return new Vector.<MyLittleParticle>();
         }
         var _loc4_:userData = userData(param1.GetUserData());
         if(Boolean(_loc4_.pfx) && _loc4_.pfx.replaceDefault)
         {
            param2 = _loc4_.pfx.getParticle();
         }
         var _loc5_:Number = Math.random() * param1.GetUserData().width - param1.GetUserData().width * 0.5;
         var _loc6_:Number = Math.random() * param1.GetUserData().height - param1.GetUserData().height * 0.5;
         var _loc7_:int = 0;
         while(!GeneralUtils.pointInPolygon(_loc5_,_loc6_,param1.GetUserData().hull) && _loc7_ < 10)
         {
            _loc5_ = Math.random() * _loc4_.width - _loc4_.width * 0.5;
            _loc6_ = Math.random() * _loc4_.height - _loc4_.height * 0.5;
            _loc7_++;
         }
         var _loc8_:Number = param1.GetPosition().x * Physics.scale + _loc5_ * Math.cos(param1.GetAngle()) - _loc6_ * Math.sin(param1.GetAngle());
         var _loc9_:Number = param1.GetPosition().y * Physics.scale + _loc5_ * Math.sin(param1.GetAngle()) + _loc6_ * Math.cos(param1.GetAngle());
         var _loc10_:Number = param1.GetLinearVelocity().x * 0.1;
         var _loc11_:Number = param1.GetLinearVelocity().y * 0.1;
         return GameState.particles.addParticles(_loc8_,_loc9_,1,param2,_loc10_,_loc11_,param3,param3);
      }
      
      public static function RemoveJoints(param1:b2Body) : void
      {
         var _loc5_:b2Joint = null;
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = param1.GetUserData();
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:Array = [];
         var _loc4_:b2JointEdge = param1.GetJointList();
         while(_loc4_)
         {
            _loc3_.push(_loc4_.joint);
            _loc4_ = _loc4_.next;
         }
         for each(_loc5_ in _loc3_)
         {
            Joints.DestroyJoint(_loc5_);
         }
      }
      
      public static function InvisibleJoints(param1:b2Body) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = param1.GetUserData();
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:b2JointEdge = param1.GetJointList();
         while(_loc3_)
         {
            if(jointUserData(_loc3_.joint.GetUserData()))
            {
               jointUserData(_loc3_.joint.GetUserData()).lineVisible = false;
            }
            _loc3_ = _loc3_.next;
         }
      }
      
      public static function RemoveLinks(param1:b2Body) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = param1.GetUserData();
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:Vector.<b2Body> = _loc2_.connected;
         _loc2_.connected = new Vector.<b2Body>();
      }
      
      public static function RemoveIgnores(param1:b2Body) : void
      {
         var _loc4_:b2Body = null;
         if(!param1)
         {
            return;
         }
         var _loc2_:userData = param1.GetUserData();
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:Vector.<b2Body> = _loc2_.ignored;
         for each(_loc4_ in _loc3_)
         {
            userData(_loc4_.GetUserData()).unignore(param1);
         }
         _loc2_.ignored = new Vector.<b2Body>();
      }
      
      public static function ReplaceGraphic(param1:userData, param2:Sprite) : void
      {
         if(!param1.graphic)
         {
            return;
         }
         var _loc3_:Number = Vars.objSize;
         Vars.objSize = 1;
         var _loc4_:b2Body = GameState.objects.spawnObject(param1.name,-100,-100,0,false,true);
         Vars.objSize = _loc3_;
         if(!_loc4_)
         {
            return;
         }
         var _loc5_:DisplayObjectContainer = param1.getParent();
         var _loc6_:int = _loc5_.getChildIndex(param1.graphic);
         _loc5_.removeChild(param1.graphic);
         param1.graphic = userData(_loc4_.GetUserData()).graphic;
         param1.graphic.scaleY = param1.size;
         if(param1.flipped)
         {
            param1.graphic.scaleX = -param1.size;
         }
         else
         {
            param1.graphic.scaleX = param1.size;
         }
         userData(_loc4_.GetUserData()).graphic = null;
         _loc5_.addChildAt(param1.graphic,_loc6_);
         Body.Destroy(_loc4_,"replacegraphic");
      }
   }
}

