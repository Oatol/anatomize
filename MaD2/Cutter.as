package
{
   import Box2D.Collision.Shapes.b2PolygonDef;
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Collision.Shapes.b2ShapeDef;
   import Box2D.Collision.b2Segment;
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.Math.b2XForm;
   import Box2D.Common.b2Settings;
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.Joints.b2JointEdge;
   import Box2D.Dynamics.Joints.b2RevoluteJoint;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.geom.Point;
   import triggers.AerosolCan;
   import triggers.Disintegrate;
   import triggers.Invincible;
   import triggers.Poisoned;
   import triggers.Sanded;
   import triggers.TempProjectile;
   
   public class Cutter
   {
      
      public static var cutLimit:int = 12;
      
      private var vectorCutter:VectorCutter = new VectorCutter();
      
      private var prevCutParams:Array = [];
      
      private var cutShapesLeft:int = 0;
      
      private var cutCurrent:int = 0;
      
      private var cutShapes:Array = [];
      
      private var cutSegment:b2Segment = new b2Segment();
      
      public var maxRaycasts:int = 64;
      
      public function Cutter()
      {
         super();
      }
      
      public function CustomCut(param1:b2Vec2, param2:b2Vec2, param3:Number, param4:Number, param5:Number = 0) : void
      {
         this.Cut(param3,param1,param2,param4,param5);
         GameState.madeby = "none";
      }
      
      public function CustomRaycast(param1:b2Vec2, param2:Number, param3:b2Vec2, param4:Boolean = false, param5:String = "normal") : Array
      {
         var _loc6_:Number = Math.atan2(param3.y - param1.y,param3.x - param1.x);
         var _loc7_:Number = param1.x / Physics.scale;
         var _loc8_:Number = param1.y / Physics.scale;
         var _loc9_:Number = (param1.x + Math.cos(_loc6_) * param2) / Physics.scale;
         var _loc10_:Number = (param1.y + Math.sin(_loc6_) * param2) / Physics.scale;
         var _loc11_:b2Segment = new b2Segment();
         _loc11_.p1.SetV(new b2Vec2(_loc7_,_loc8_));
         _loc11_.p2.SetV(new b2Vec2(_loc9_,_loc10_));
         _loc11_.p2.Add(new b2Vec2(0.1,0.1));
         var _loc12_:b2Vec2 = new b2Vec2(-1,-1);
         var _loc13_:* = [1];
         var _loc14_:b2Vec2 = new b2Vec2();
         var _loc15_:* = GameState.madeby;
         GameState.madeby = "customraycast_" + param5;
         var _loc16_:b2Shape = Physics.world.RaycastOne(_loc11_,_loc13_,_loc14_,param4,null);
         GameState.madeby = _loc15_;
         _loc13_ = _loc13_[0];
         _loc12_ = new b2Vec2(_loc11_.p2.x * _loc13_ + (1 - _loc13_) * _loc11_.p1.x,_loc11_.p2.y * _loc13_ + (1 - _loc13_) * _loc11_.p1.y);
         if(_loc16_)
         {
            return [_loc16_.GetBody(),_loc12_];
         }
         return [null,_loc12_];
      }
      
      public function Cut(param1:int, param2:b2Vec2, param3:b2Vec2, param4:Number, param5:Number = 0) : void
      {
         var _loc9_:Number = NaN;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:b2Vec2 = null;
         var _loc13_:b2Vec2 = null;
         var _loc14_:b2Segment = null;
         var _loc6_:Number = param2.x;
         var _loc7_:Number = param2.y;
         this.prevCutParams = [_loc6_,_loc7_,param1,param4,param3,param5];
         var _loc8_:* = 0;
         while(_loc8_ < param1)
         {
            _loc9_ = Math.atan2(param3.y - _loc7_,param3.x - _loc6_) + Math.random() * param5 - param5 * 0.5;
            _loc10_ = _loc6_ + Math.cos(_loc9_) * param4;
            _loc11_ = _loc7_ + Math.sin(_loc9_) * param4;
            _loc12_ = new b2Vec2();
            _loc13_ = new b2Vec2();
            _loc12_.x = _loc6_ / Physics.scale;
            _loc12_.y = _loc7_ / Physics.scale;
            _loc13_.x = _loc10_ / Physics.scale;
            _loc13_.y = _loc11_ / Physics.scale;
            _loc14_ = new b2Segment();
            _loc14_.p1 = new b2Vec2(_loc12_.x,_loc12_.y);
            _loc14_.p2 = new b2Vec2(_loc13_.x - _loc12_.x,_loc13_.y - _loc12_.y);
            _loc14_.p2 = b2Math.AddVV(_loc14_.p2,_loc14_.p1);
            if(GameState.madeby == "cut" || GameState.madeby == "scissors")
            {
               this.CutJoints(_loc14_);
            }
            this.MakeCut(_loc14_);
            _loc8_++;
         }
      }
      
      public function CutJoints(param1:b2Segment) : *
      {
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:userData = null;
         var _loc9_:userData = null;
         var _loc2_:b2Vec2 = new b2Vec2(param1.p1.x,param1.p1.y);
         var _loc3_:b2Vec2 = new b2Vec2(param1.p2.x,param1.p2.y);
         var _loc4_:Boolean = false;
         var _loc5_:b2Joint = Physics.world.GetJointList();
         for(; _loc5_; _loc5_ = _loc5_.GetNext())
         {
            if(_loc5_.GetUserData())
            {
               if(!(!_loc5_.GetUserData().cuttable && TimeLord.speed != 0))
               {
                  _loc6_ = new b2Vec2(_loc5_.GetAnchor1().x,_loc5_.GetAnchor1().y);
                  _loc7_ = new b2Vec2(_loc5_.GetAnchor2().x,_loc5_.GetAnchor2().y);
                  if(jointUserData(_loc5_.GetUserData()).name == "rag")
                  {
                     if(BoxUtils.vectorDist(_loc6_,_loc7_) < 0.2)
                     {
                        continue;
                     }
                  }
                  _loc8_ = userData(_loc5_.GetBody1().GetUserData());
                  _loc9_ = userData(_loc5_.GetBody2().GetUserData());
                  if(BoxUtils.checkLineCollision2(_loc2_,_loc3_,_loc6_,_loc7_))
                  {
                     _loc4_ = true;
                     break;
                  }
                  if(BoxUtils.checkLineCollision2(_loc3_,_loc2_,_loc6_,_loc7_))
                  {
                     _loc4_ = true;
                     break;
                  }
               }
            }
         }
         if(_loc4_)
         {
            if(Boolean(_loc8_) && Boolean(_loc8_.trigger))
            {
               _loc8_.trigger.OnJointDelete(_loc5_);
            }
            if(Boolean(_loc9_) && Boolean(_loc9_.trigger))
            {
               _loc9_.trigger.OnJointDelete(_loc5_);
            }
            if(Boolean(_loc8_) && Boolean(_loc8_.armour))
            {
               _loc8_.armour.OnJointDelete(_loc5_);
            }
            if(Boolean(_loc9_) && Boolean(_loc9_.armour))
            {
               _loc9_.armour.OnJointDelete(_loc5_);
            }
            Physics.world.DestroyJoint(_loc5_);
            return;
         }
      }
      
      public function Include(param1:Vector.<b2Body>) : void
      {
         Physics.contactFilter.cutInclude = param1;
      }
      
      public function Exclude(param1:Vector.<b2Body>) : void
      {
         Physics.contactFilter.cutExclude = param1;
      }
      
      public function IncludeSingle(param1:b2Body) : void
      {
         var _loc2_:Vector.<b2Body> = new Vector.<b2Body>();
         _loc2_.push(param1);
         Physics.contactFilter.cutInclude = _loc2_;
      }
      
      public function ExcludeSingle(param1:b2Body) : void
      {
         var _loc2_:Vector.<b2Body> = new Vector.<b2Body>();
         _loc2_.push(param1);
         Physics.contactFilter.cutExclude = _loc2_;
      }
      
      private function MakeCut(param1:b2Segment) : void
      {
         var segment:b2Segment = param1;
         var madeby:String = GameState.madeby;
         if(madeby == "none")
         {
            return;
         }
         if(cutLimit <= 0)
         {
            return;
         }
         GameState.cutting = true;
         this.cutSegment = segment;
         if(!this.cutSegment || !this.cutSegment.p1 || !this.cutSegment.p2)
         {
            return;
         }
         try
         {
            this.cutShapesLeft = Physics.world.Raycast(this.cutSegment,[],this.maxRaycasts,true,null);
         }
         catch(e:TypeError)
         {
            return;
         }
         if(this.cutShapesLeft > 0)
         {
            this.cutCurrent = -1;
            this.NextCut();
         }
         GameState.cutting = false;
         this.cutShapesLeft = 0;
      }
      
      private function NextCut() : void
      {
         var _loc4_:userData = null;
         var _loc11_:b2Body = null;
         var _loc12_:b2Body = null;
         var _loc13_:userData = null;
         var _loc14_:userData = null;
         var _loc16_:int = 0;
         var _loc21_:b2BodyDef = null;
         var _loc22_:b2BodyDef = null;
         var _loc23_:Array = null;
         var _loc24_:Array = null;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Array = null;
         var _loc28_:Array = null;
         var _loc29_:ShapeUserData = null;
         var _loc30_:ShapeUserData = null;
         var _loc31_:String = null;
         var _loc32_:b2Shape = null;
         var _loc33_:Vector.<b2PolygonDef> = null;
         var _loc34_:Vector.<b2PolygonDef> = null;
         var _loc35_:b2PolygonDef = null;
         var _loc36_:DisplayObjectContainer = null;
         var _loc37_:BitmapData = null;
         var _loc38_:Array = null;
         var _loc39_:Array = null;
         var _loc40_:b2Body = null;
         var _loc41_:b2Body = null;
         var _loc42_:b2JointEdge = null;
         var _loc43_:b2PolygonShape = null;
         var _loc44_:b2Vec2 = null;
         var _loc45_:b2Vec2 = null;
         var _loc46_:Number = NaN;
         var _loc47_:ShapeUserData = null;
         var _loc48_:b2PolygonDef = null;
         var _loc49_:Array = null;
         var _loc50_:b2Vec2 = null;
         var _loc51_:Number = NaN;
         var _loc52_:Number = NaN;
         var _loc53_:Number = NaN;
         var _loc54_:Number = NaN;
         var _loc55_:Number = NaN;
         var _loc56_:Number = NaN;
         var _loc57_:Bitmap = null;
         var _loc58_:Bitmap = null;
         var _loc59_:Bitmap = null;
         var _loc60_:Point = null;
         var _loc61_:Point = null;
         var _loc62_:Vector.<Sprite> = null;
         var _loc63_:Bitmap = null;
         var _loc64_:Sprite = null;
         var _loc65_:Sprite = null;
         var _loc66_:b2Vec2 = null;
         var _loc67_:b2Vec2 = null;
         var _loc68_:Number = NaN;
         var _loc69_:b2RevoluteJoint = null;
         var _loc70_:Bitmap = null;
         var _loc71_:Bitmap = null;
         var _loc72_:b2Vec2 = null;
         var _loc73_:b2Vec2 = null;
         var _loc74_:uint = 0;
         var _loc75_:Boolean = false;
         var _loc76_:int = 0;
         var _loc77_:Sprite = null;
         var _loc78_:Sprite = null;
         var _loc79_:BitmapData = null;
         var _loc80_:BitmapData = null;
         var _loc81_:b2Vec2 = null;
         var _loc82_:b2Vec2 = null;
         var _loc83_:* = undefined;
         var _loc84_:* = undefined;
         var _loc85_:b2Vec2 = null;
         var _loc86_:b2Vec2 = null;
         var _loc87_:* = undefined;
         var _loc88_:* = undefined;
         var _loc89_:b2Vec2 = null;
         var _loc90_:b2Vec2 = null;
         if(cutLimit <= 0)
         {
            this.cutShapesLeft = 0;
         }
         if(this.cutShapesLeft <= 0)
         {
            Physics.contactFilter.cutExclude = new Vector.<b2Body>();
            Physics.contactFilter.cutInclude = new Vector.<b2Body>();
            return;
         }
         --this.cutShapesLeft;
         ++this.cutCurrent;
         var _loc1_:String = GameState.madeby;
         GameState.madeby = "customraycast_cutter";
         Physics.world.Raycast(this.cutSegment,this.cutShapes,1,true,null);
         GameState.madeby = _loc1_;
         var _loc2_:b2Shape = this.cutShapes[0];
         var _loc3_:b2Body = _loc2_.GetBody();
         _loc4_ = userData(_loc3_.GetUserData());
         var _loc5_:String = _loc4_.name;
         if(_loc5_ == "deleted")
         {
            this.NextCut();
            return;
         }
         if(GameState.madeby == "explosion" && _loc4_.name == "boomstaff")
         {
            this.NextCut();
            return;
         }
         if(Boolean(_loc4_.trigger) || Boolean(_loc4_.armour))
         {
            if(_loc4_.triggerOnCut)
            {
               _loc4_.triggered = true;
            }
            if(_loc4_.trigger)
            {
               _loc4_.trigger.OnCutDamage(this.cutSegment.p1.Copy(),this.cutSegment.p2.Copy());
            }
            if(_loc4_.armour)
            {
               _loc4_.armour.OnCutDamage(this.cutSegment.p1.Copy(),this.cutSegment.p2.Copy());
            }
            if(Boolean(_loc4_.trigger) && Boolean(_loc4_.trigger.OnCut()) || Boolean(_loc4_.armour) && Boolean(_loc4_.armour.OnCut()))
            {
               Physics.contactFilter.cutExclude.push(_loc3_);
               this.NextCut();
               return;
            }
         }
         if(_loc4_.unbreakable)
         {
            return;
         }
         if(_loc4_.resistCutting)
         {
            return;
         }
         if(Boolean(_loc4_.trigger) && _loc4_.trigger is Invincible)
         {
            return;
         }
         if(GameState.madeby == "bullet" && (_loc4_.alive && _loc4_.health > 25))
         {
            return;
         }
         if(_loc4_.name == "portal1" || _loc4_.name == "portal2" || _loc4_.name == "blackhole" || _loc4_.name == "darknesstear")
         {
            return;
         }
         if(World.toggleRagdollBreak == 0 && _loc4_.alive)
         {
            this.NextCut();
            return;
         }
         if(_loc2_.GetType() != b2Shape.e_polygonShape)
         {
            this.NextCut();
            return;
         }
         --cutLimit;
         if(_loc3_.IsStatic())
         {
            if(GameState.madeby == "laser")
            {
               return;
            }
            this.NextCut();
            return;
         }
         if(_loc4_.triggerOnCut)
         {
            if(_loc4_.name == "aerosol")
            {
               _loc4_.trigger = new AerosolCan();
            }
            _loc4_.triggered = true;
            Physics.contactFilter.cutExclude.push(_loc3_);
            return;
         }
         var _loc6_:b2PolygonDef = new b2PolygonDef();
         var _loc7_:b2PolygonDef = new b2PolygonDef();
         var _loc8_:b2Vec2 = new b2Vec2();
         var _loc9_:b2Vec2 = new b2Vec2();
         var _loc10_:* = 0;
         var _loc15_:int = this.SplitShape(_loc2_ as b2PolygonShape,this.cutSegment,_loc10_,[_loc6_,_loc7_],[_loc8_,_loc9_]);
         if(_loc15_ == 0)
         {
            _loc21_ = new b2BodyDef();
            _loc22_ = new b2BodyDef();
            _loc21_.userData = new userData("temp",_loc4_.id);
            _loc22_.userData = new userData("temp",_loc4_.id);
            _loc23_ = _loc6_.vertices;
            _loc24_ = _loc7_.vertices;
            _loc23_.splice(_loc6_.vertexCount,_loc23_.length - _loc6_.vertexCount);
            _loc24_.splice(_loc7_.vertexCount,_loc24_.length - _loc7_.vertexCount);
            _loc25_ = BoxUtils.verticeArea(_loc23_);
            _loc26_ = BoxUtils.verticeArea(_loc24_);
            _loc27_ = BoxUtils.verticeDimensions(_loc23_);
            _loc28_ = BoxUtils.verticeDimensions(_loc24_);
            _loc29_ = Properties.shapeProperties(ShapeUserData(_loc2_.GetUserData()).name);
            _loc30_ = Properties.shapeProperties(ShapeUserData(_loc2_.GetUserData()).name);
            _loc29_.copyProperties(ShapeUserData(_loc2_.GetUserData()));
            _loc30_.copyProperties(ShapeUserData(_loc2_.GetUserData()));
            _loc6_.density = _loc3_.GetShapeList().m_density * (_loc25_ / (_loc25_ + _loc26_));
            _loc6_.restitution = _loc3_.GetShapeList().m_restitution;
            _loc6_.friction = _loc3_.GetShapeList().m_friction;
            _loc6_.userData = _loc29_;
            _loc7_.density = _loc3_.GetShapeList().m_density * (_loc26_ / (_loc25_ + _loc26_));
            _loc7_.restitution = _loc3_.GetShapeList().m_restitution;
            _loc7_.friction = _loc3_.GetShapeList().m_friction;
            _loc7_.userData = _loc30_;
            _loc6_.userData.alpha = ShapeUserData(_loc2_.GetUserData()).alpha;
            _loc7_.userData.alpha = ShapeUserData(_loc2_.GetUserData()).alpha;
            _loc31_ = "shrapnel";
            if(_loc5_ == "doll_head")
            {
               _loc31_ = "doll_head";
               if(Math.abs(_loc8_.Length() - _loc9_.Length()) > _loc4_.size)
               {
                  _loc31_ = "corpse_head";
               }
            }
            _loc4_.saveable = false;
            _loc4_.name = _loc31_;
            userData(_loc21_.userData).copyProperties(_loc4_,_loc3_);
            userData(_loc22_.userData).copyProperties(_loc4_,_loc3_);
            _loc21_.userData.connected = _loc4_.connected.slice();
            _loc22_.userData.connected = _loc4_.connected.slice();
            _loc11_ = Physics.world.CreateBody(_loc21_);
            _loc12_ = Physics.world.CreateBody(_loc22_);
            if(!_loc11_ || !_loc12_)
            {
               return;
            }
            _loc13_ = userData(_loc11_.GetUserData());
            _loc14_ = userData(_loc12_.GetUserData());
            _loc13_.body = _loc11_;
            _loc14_.body = _loc12_;
            if(_loc4_.alive)
            {
               _loc13_.triggerCustom = _loc4_.triggerCustom;
               _loc14_.triggerCustom = _loc4_.triggerCustom;
            }
            if(Boolean(_loc4_.trigger) && _loc4_.trigger.temporary)
            {
               if(_loc3_.GetMass() > 3)
               {
                  _loc13_.trigger = _loc4_.trigger;
                  _loc14_.trigger = _loc4_.trigger;
               }
            }
            else
            {
               _loc13_.trigger = null;
               _loc13_.triggered = false;
               _loc14_.trigger = null;
               _loc14_.triggered = false;
            }
            _loc32_ = _loc3_.GetShapeList();
            _loc13_.saveable = false;
            _loc14_.saveable = false;
            _loc13_.name = _loc31_;
            _loc14_.name = _loc31_;
            _loc33_ = new Vector.<b2PolygonDef>();
            _loc34_ = new Vector.<b2PolygonDef>();
            while(_loc32_)
            {
               if(!ShapeUserData(_loc32_.GetUserData()).sensor)
               {
                  _loc43_ = _loc32_ as b2PolygonShape;
                  if(_loc43_ != _loc2_)
                  {
                     _loc44_ = _loc43_.GetCentroid();
                     _loc45_ = _loc3_.GetWorldPoint(_loc44_);
                     _loc46_ = GeneralUtils.determinant(_loc8_.x,_loc8_.y,_loc9_.x,_loc9_.y,_loc45_.x,_loc45_.y);
                     _loc47_ = Properties.shapeProperties(ShapeUserData(_loc43_.GetUserData()).name);
                     _loc47_.copyProperties(ShapeUserData(_loc43_.GetUserData()));
                     _loc48_ = new b2PolygonDef();
                     _loc48_.density = _loc43_.GetDensity();
                     _loc48_.friction = _loc43_.GetFriction();
                     _loc48_.restitution = _loc43_.GetRestitution();
                     _loc48_.vertexCount = _loc43_.GetVertexCount();
                     _loc48_.vertices = _loc43_.GetVertices();
                     _loc48_.userData = _loc47_;
                     _loc48_.filter.categoryBits = _loc2_.m_filter.categoryBits;
                     _loc48_.filter.maskBits = _loc2_.m_filter.maskBits;
                     if(_loc46_ < 0)
                     {
                        _loc33_.unshift(_loc48_);
                     }
                     else
                     {
                        _loc34_.unshift(_loc48_);
                     }
                  }
               }
               _loc32_ = _loc32_.GetNext();
            }
            for each(_loc35_ in _loc33_)
            {
               _loc11_.CreateShape(_loc35_);
            }
            for each(_loc35_ in _loc34_)
            {
               _loc12_.CreateShape(_loc35_);
            }
            _loc16_ = 0;
            while(_loc16_ < 2)
            {
               _loc49_ = _loc16_ == 0 ? _loc6_.vertices : _loc7_.vertices;
               _loc50_ = GeneralUtils.arrayCentroid(_loc49_);
               _loc51_ = Math.sin(_loc3_.GetAngle());
               _loc52_ = Math.cos(_loc3_.GetAngle());
               _loc53_ = _loc3_.GetPosition().x;
               _loc54_ = _loc3_.GetPosition().y;
               _loc55_ = _loc50_.x;
               _loc56_ = _loc50_.y;
               _loc45_ = new b2Vec2(_loc52_ * _loc55_ - _loc51_ * _loc56_ + _loc53_,_loc52_ * _loc56_ + _loc51_ * _loc55_ + _loc54_);
               _loc46_ = GeneralUtils.determinant(_loc8_.x,_loc8_.y,_loc9_.x,_loc9_.y,_loc45_.x,_loc45_.y);
               if(_loc46_ < 0)
               {
                  _loc11_.CreateShape(_loc16_ == 0 ? _loc6_ : _loc7_);
               }
               else
               {
                  _loc12_.CreateShape(_loc16_ == 0 ? _loc6_ : _loc7_);
               }
               _loc16_++;
            }
            BoxUtils.rotateAroundPoint(_loc3_.GetPosition(),_loc3_.GetAngle(),[_loc11_,_loc12_]);
            _loc11_.SetXForm(_loc3_.GetPosition(),_loc3_.GetAngle());
            _loc12_.SetXForm(_loc3_.GetPosition(),_loc3_.GetAngle());
            _loc11_.SetMassFromShapes();
            _loc12_.SetMassFromShapes();
            _loc11_.SetAngularVelocity(_loc3_.GetAngularVelocity());
            _loc11_.SetLinearVelocity(_loc3_.GetLinearVelocity());
            _loc12_.SetAngularVelocity(_loc3_.GetAngularVelocity());
            _loc12_.SetLinearVelocity(_loc3_.GetLinearVelocity());
            _loc13_.hasBeenCut = true;
            _loc14_.hasBeenCut = true;
            BoxUtils.updateBodyDimensions(_loc11_);
            BoxUtils.updateBodyDimensions(_loc12_);
            _loc13_.health = _loc4_.health * (_loc25_ / (_loc25_ + _loc26_));
            _loc14_.health = _loc4_.health * (_loc26_ / (_loc25_ + _loc26_));
            _loc13_.maxhealth = _loc13_.health;
            _loc14_.maxhealth = _loc14_.health;
            if(_loc4_.parentmaxhealth)
            {
               _loc13_.parentmaxhealth = _loc4_.parentmaxhealth;
               _loc14_.parentmaxhealth = _loc4_.parentmaxhealth;
            }
            else
            {
               _loc13_.parentmaxhealth = _loc4_.maxhealth;
               _loc14_.parentmaxhealth = _loc4_.maxhealth;
            }
            _loc13_.graphic = BoxUtils.bodyToSprite(_loc11_,_loc13_.size);
            Sprite(_loc13_.graphic).x = _loc11_.GetPosition().x * Physics.scale;
            Sprite(_loc13_.graphic).y = _loc11_.GetPosition().y * Physics.scale;
            Sprite(_loc13_.graphic).rotation = _loc11_.GetAngle() * Vars.toDegrees;
            _loc36_ = _loc4_.getParent();
            if(_loc36_)
            {
               _loc36_.addChild(_loc13_.graphic);
            }
            _loc14_.graphic = BoxUtils.bodyToSprite(_loc12_,_loc14_.size);
            Sprite(_loc14_.graphic).x = _loc12_.GetPosition().x * Physics.scale;
            Sprite(_loc14_.graphic).y = _loc12_.GetPosition().y * Physics.scale;
            Sprite(_loc14_.graphic).rotation = _loc12_.GetAngle() * Vars.toDegrees;
            _loc36_ = _loc4_.getParent();
            if(_loc36_)
            {
               _loc36_.addChild(_loc14_.graphic);
            }
            if(_loc4_.invisible)
            {
               _loc14_.graphic.alpha = 0;
               _loc13_.graphic.alpha = 0;
            }
            if(_loc4_.alpha)
            {
               _loc13_.alpha = _loc4_.alpha;
               _loc14_.alpha = _loc4_.alpha;
            }
            _loc37_ = BoxUtils.getEffectBMD(_loc3_);
            if(_loc37_)
            {
               _loc57_ = BoxUtils.getEffectBM(_loc11_);
               _loc58_ = BoxUtils.getEffectBM(_loc12_);
               _loc59_ = BoxUtils.getEffectBM(_loc3_);
               BoxUtils.getEffectBMD(_loc11_).copyPixels(_loc37_,_loc37_.rect,new Point(_loc59_.x - _loc57_.x,_loc59_.y - _loc57_.y));
               BoxUtils.getEffectBMD(_loc12_).copyPixels(_loc37_,_loc37_.rect,new Point(_loc59_.x - _loc58_.x,_loc59_.y - _loc58_.y));
            }
            if(GameState.isCapable && Boolean(_loc4_.graphic.getChildByName("decals")))
            {
               _loc4_.graphic.scaleY = 1;
               _loc4_.graphic.scaleX = 1;
               _loc60_ = new Point(GraphicUtils.camX(this.cutSegment.p1.x * Physics.scale),GraphicUtils.camY(this.cutSegment.p1.y * Physics.scale));
               _loc61_ = new Point(GraphicUtils.camX(this.cutSegment.p2.x * Physics.scale),GraphicUtils.camY(this.cutSegment.p2.y * Physics.scale));
               _loc62_ = this.vectorCutter.cut(Sprite(_loc4_.graphic.getChildByName("decals")),_loc60_,_loc61_);
               _loc62_[1].name = "decals";
               _loc62_[0].name = "decals";
               _loc13_.graphic.addChild(_loc62_[1]);
               _loc14_.graphic.addChild(_loc62_[0]);
               _loc63_ = BoxUtils.getEffectBM(_loc11_);
               if(_loc63_)
               {
                  _loc13_.graphic.addChild(_loc13_.graphic.getChildByName("effects"));
               }
               _loc63_ = BoxUtils.getEffectBM(_loc12_);
               if(_loc63_)
               {
                  _loc14_.graphic.addChild(_loc14_.graphic.getChildByName("effects"));
               }
            }
            if(GameState.isCapable && World.togglePreciseEffects == 1)
            {
               _loc64_ = new Sprite();
               _loc64_.name = "mask";
               if(_loc13_.graphic.getChildByName("decals"))
               {
                  _loc64_.graphics.drawGraphicsData(Sprite(_loc13_.graphic.getChildByName("decals")).graphics.readGraphicsData(false));
               }
               if(_loc13_.graphic.getChildByName("item"))
               {
                  _loc64_.graphics.drawGraphicsData(Sprite(_loc13_.graphic.getChildByName("item")).graphics.readGraphicsData(false));
               }
               _loc65_ = new Sprite();
               _loc65_.name = "mask";
               if(_loc14_.graphic.getChildByName("decals"))
               {
                  _loc65_.graphics.drawGraphicsData(Sprite(_loc14_.graphic.getChildByName("decals")).graphics.readGraphicsData(false));
               }
               if(_loc14_.graphic.getChildByName("item"))
               {
                  _loc65_.graphics.drawGraphicsData(Sprite(_loc14_.graphic.getChildByName("item")).graphics.readGraphicsData(false));
               }
               _loc13_.graphic.addChild(_loc64_);
               _loc14_.graphic.addChild(_loc65_);
               if(_loc13_.graphic.getChildByName("effects"))
               {
                  _loc13_.graphic.getChildByName("effects").mask = _loc64_;
               }
               if(_loc14_.graphic.getChildByName("effects"))
               {
                  _loc14_.graphic.getChildByName("effects").mask = _loc65_;
               }
            }
            _loc38_ = BoxUtils.bodyToVertices(_loc11_);
            _loc39_ = BoxUtils.bodyToVertices(_loc12_);
            _loc13_.hull = GameState.hullHandler.convexHull(_loc38_);
            _loc14_.hull = GameState.hullHandler.convexHull(_loc39_);
            _loc13_.ignored = _loc4_.ignored.slice();
            _loc14_.ignored = _loc4_.ignored.slice();
            _loc42_ = _loc3_.GetJointList();
            while(_loc42_)
            {
               if(!(_loc42_.joint.m_body1.GetUserData().name == "ground" || _loc42_.joint.m_body2.GetUserData().name == "ground"))
               {
                  if(!(jointUserData(_loc42_.joint.GetUserData()).name != "rag" && jointUserData(_loc42_.joint.GetUserData()).name != "ana"))
                  {
                     if(_loc42_.joint.m_body1 == _loc3_)
                     {
                        _loc40_ = _loc42_.joint.m_body2;
                     }
                     else
                     {
                        _loc40_ = _loc42_.joint.m_body1;
                     }
                     _loc66_ = _loc11_.GetWorldPoint(BoxUtils.bodyCentroid(_loc11_));
                     _loc67_ = _loc12_.GetWorldPoint(BoxUtils.bodyCentroid(_loc12_));
                     if(BoxUtils.closerVector(_loc40_.GetPosition(),_loc66_,_loc67_))
                     {
                        _loc41_ = _loc11_;
                     }
                     else
                     {
                        _loc41_ = _loc12_;
                     }
                     _loc27_ = BoxUtils.bodyDimensions(_loc40_);
                     _loc28_ = BoxUtils.bodyDimensions(_loc41_);
                     _loc68_ = BoxUtils.vectorDist(_loc40_.GetPosition().Copy(),_loc41_.GetPosition().Copy());
                     if(_loc27_[0] > 5 && _loc27_[1] > 5 && _loc28_[0] > 5 && _loc28_[1] > 5)
                     {
                        _loc69_ = Joints.Revolution("rag",_loc40_,_loc41_,_loc42_.joint.GetAnchor1().x * Physics.scale,_loc42_.joint.GetAnchor1().y * Physics.scale,_loc42_.joint.GetUserData().lowerAngle,_loc42_.joint.GetUserData().upperAngle);
                        if(_loc69_)
                        {
                           jointUserData(_loc69_.GetUserData()).defaultLA = _loc42_.joint.GetUserData().defaultLA;
                           jointUserData(_loc69_.GetUserData()).defaultUA = _loc42_.joint.GetUserData().defaultUA;
                           jointUserData(_loc69_.GetUserData()).defaultFL = _loc42_.joint.GetUserData().defaultFL;
                           jointUserData(_loc69_.GetUserData()).forceLimit = _loc42_.joint.GetUserData().forceLimit;
                        }
                     }
                  }
               }
               _loc42_ = _loc42_.next;
            }
            if(_loc4_.burning)
            {
               if(_loc11_.GetMass() < 0.5)
               {
                  _loc13_.trigger = new Disintegrate("smoke",20,0.1);
                  _loc13_.triggered = true;
               }
               if(_loc12_.GetMass() < 0.5)
               {
                  _loc14_.trigger = new Disintegrate("smoke",20,0.1);
                  _loc14_.triggered = true;
               }
            }
            if(World.toggleShrapnel == 1)
            {
               if(!_loc13_.alive && _loc11_.GetMass() < 0.2)
               {
                  _loc13_.trigger = new TempProjectile(Math.random() * 30 + 30);
                  _loc13_.triggered = true;
                  _loc13_.triggerLock = true;
               }
               if(!_loc14_.alive && _loc12_.GetMass() < 0.2)
               {
                  _loc14_.trigger = new TempProjectile(Math.random() * 30 + 30);
                  _loc14_.triggered = true;
                  _loc14_.triggerLock = true;
               }
            }
            Body.Destroy(_loc3_,"cut");
            if(this.cutShapesLeft != 0)
            {
               this.NextCut();
            }
         }
         if(_loc8_.x == 0 && _loc8_.y == 0)
         {
            _loc8_ = this.cutSegment.p1.Copy();
         }
         if(_loc9_.x == 0 && _loc9_.y == 0)
         {
            _loc9_ = this.cutSegment.p2.Copy();
         }
         _loc16_ = 10 + Math.abs(_loc8_.Length() - _loc9_.Length());
         if(_loc16_ > 100)
         {
            _loc16_ = 100;
         }
         var _loc17_:Number = (_loc9_.x - _loc8_.x) / (_loc16_ * _loc4_.size);
         var _loc18_:Number = (_loc9_.y - _loc8_.y) / (_loc16_ * _loc4_.size);
         var _loc19_:Number = (_loc9_.x - _loc8_.x) * 20;
         var _loc20_:Number = (_loc9_.y - _loc8_.y) * 20;
         if(_loc4_.alive && _loc3_.GetMass() > 0.1)
         {
            if(GameState.madeby != "bullet" && GameState.madeby != "brittle")
            {
               if(_loc4_.temperature > 0)
               {
                  sounds.random(["cut1","cut2","cut3","cut5","cut6","cut7"],null,new b2Vec2(_loc9_.x + _loc8_.x >> 1,_loc9_.y + _loc8_.y >> 1),0.5 + 0.5 * Math.random() * Math.max(1,Math.abs(_loc8_.Length() - _loc9_.Length())),false);
               }
            }
            if(World.toggleGore == 0)
            {
               return;
            }
            if(!_loc11_ && !_loc12_)
            {
               _loc11_ = _loc3_;
               _loc12_ = _loc3_;
            }
            _loc70_ = BoxUtils.getEffectBM(_loc11_);
            _loc71_ = BoxUtils.getEffectBM(_loc12_);
            if(Boolean(_loc70_) && Boolean(_loc71_))
            {
               _loc79_ = _loc70_.bitmapData;
               _loc80_ = _loc71_.bitmapData;
               if(_loc79_)
               {
                  _loc79_.lock();
               }
               if(_loc80_)
               {
                  _loc80_.lock();
               }
            }
            _loc75_ = true;
            if(GameState.madeby == "lightsaber")
            {
               _loc75_ = false;
            }
            if(GameState.madeby == "brittle")
            {
               _loc75_ = false;
            }
            if(Boolean(_loc4_.trigger) && _loc4_.trigger is Poisoned)
            {
               _loc75_ = false;
            }
            if(Boolean(_loc4_.trigger) && _loc4_.trigger is Sanded)
            {
               _loc75_ = false;
            }
            if(_loc4_.burning)
            {
               _loc75_ = false;
            }
            if(_loc4_.temperature <= 0)
            {
               _loc75_ = false;
            }
            if(_loc16_ > 10 && World.toggleSlomo == 1 && !GameState.slomo)
            {
               TimeLord.slowTo(50);
            }
            _loc76_ = 0;
            while(_loc76_ < _loc16_)
            {
               _loc73_ = _loc3_.GetLinearVelocity().Copy();
               _loc73_.Multiply(0.5);
               _loc73_.x += _loc19_ * 0.5 + Math.random() * _loc19_ * 0.5;
               _loc73_.y += _loc20_ * 0.5 + Math.random() * _loc20_ * 0.5;
               _loc72_ = new b2Vec2(_loc8_.x + _loc17_ * _loc76_,_loc8_.y + _loc18_ * _loc76_);
               Body.Damage(_loc3_,10 * _loc4_.multiSharpDamage,_loc72_,_loc73_,new b2Vec2(0.5,0.5),_loc75_);
               _loc76_++;
            }
            _loc16_ = (10 + Math.abs(_loc8_.Length() - _loc9_.Length())) * _loc4_.size * _loc4_.multiSharpDamage;
            if(_loc16_ > 100)
            {
               _loc16_ = 100;
            }
            _loc77_ = new Sprite();
            _loc78_ = new Sprite();
            if(World.toggleGore == 1)
            {
               _loc76_ = 0;
               while(_loc76_ < _loc16_)
               {
                  if(!_loc4_.resistBleed)
                  {
                     if(_loc4_.temperature > 0)
                     {
                        if(Boolean(_loc79_) && Boolean(_loc80_))
                        {
                           _loc72_ = new b2Vec2(_loc8_.x + _loc17_ * _loc76_,_loc8_.y + _loc18_ * _loc76_);
                           _loc81_ = _loc11_.GetLocalPoint(_loc72_).Copy();
                           _loc82_ = _loc12_.GetLocalPoint(_loc72_).Copy();
                           _loc81_.Multiply(Physics.scale);
                           _loc81_.x -= _loc70_.x;
                           _loc81_.y -= _loc70_.y;
                           _loc82_.Multiply(Physics.scale);
                           _loc82_.x -= _loc71_.x;
                           _loc82_.y -= _loc71_.y;
                           _loc74_ = this.goreColour(_loc4_);
                           _loc77_.graphics.beginFill(Math.random() * 255 << 24 | _loc74_);
                           _loc77_.graphics.drawCircle(_loc81_.x,_loc81_.y,2 + Math.random() * 2);
                           _loc77_.graphics.endFill();
                           _loc78_.graphics.beginFill(Math.random() * 255 << 24 | _loc74_);
                           _loc78_.graphics.drawCircle(_loc82_.x,_loc82_.y,2 + Math.random() * 2);
                           _loc78_.graphics.endFill();
                        }
                     }
                  }
                  _loc76_++;
               }
               _loc76_ = 0;
               while(_loc76_ < _loc16_)
               {
                  if(!_loc4_.resistBleed)
                  {
                     if(!(_loc4_.temperature <= 0 && !_loc4_.resistFreeze))
                     {
                        if(Boolean(_loc79_) && Boolean(_loc80_))
                        {
                           _loc72_ = new b2Vec2(_loc8_.x + _loc17_ * _loc76_,_loc8_.y + _loc18_ * _loc76_);
                           _loc81_ = _loc11_.GetLocalPoint(_loc72_).Copy();
                           _loc82_ = _loc12_.GetLocalPoint(_loc72_).Copy();
                           _loc81_.Multiply(Physics.scale);
                           _loc81_.x -= _loc70_.x;
                           _loc81_.y -= _loc70_.y;
                           _loc82_.Multiply(Physics.scale);
                           _loc82_.x -= _loc71_.x;
                           _loc82_.y -= _loc71_.y;
                           _loc74_ = GraphicUtils.scalehex(this.goreColour(_loc4_),0.5 + Math.random() * 0.5);
                           _loc77_.graphics.beginFill(Math.random() * 255 << 24 | _loc74_);
                           _loc77_.graphics.drawCircle(_loc81_.x,_loc81_.y,0.5 + Math.random() * 1.5);
                           _loc77_.graphics.endFill();
                           _loc78_.graphics.beginFill(Math.random() * 255 << 24 | _loc74_);
                           _loc78_.graphics.drawCircle(_loc82_.x,_loc82_.y,0.5 + Math.random() * 1.5);
                           _loc78_.graphics.endFill();
                        }
                     }
                  }
                  _loc76_++;
               }
            }
            if(_loc79_)
            {
               _loc79_.draw(_loc77_);
               _loc79_.unlock();
            }
            if(_loc80_)
            {
               _loc80_.draw(_loc78_);
               _loc80_.unlock();
            }
         }
         else if(!_loc4_.soft && !_loc4_.burning)
         {
            _loc76_ = 0;
            while(_loc76_ < _loc16_)
            {
               _loc73_ = _loc3_.GetLinearVelocity().Copy();
               _loc73_.Multiply(0.1);
               _loc73_.x += Math.random() * _loc19_ * 0.4;
               _loc73_.y += Math.random() * _loc20_ * 0.4;
               GameState.particles.addParticles((_loc8_.x + _loc17_ * _loc76_) * Physics.scale,(_loc8_.y + _loc18_ * _loc76_) * Physics.scale,1,"sparkle",_loc73_.x,_loc73_.y);
               _loc76_ += 4;
            }
         }
         if(_loc4_.resistBleed)
         {
            return;
         }
         if(_loc4_.alive && _loc4_.multiSharpDamage > 0 && !_loc4_.burning && !(_loc4_.trigger is Poisoned) && !(_loc4_.trigger is Sanded))
         {
            if(_loc15_ == 0)
            {
               if(_loc25_ > 0.5)
               {
                  if(_loc4_.temperature > 0 && GameState.madeby != "lightsaber")
                  {
                     _loc83_ = _loc11_.GetLocalPoint(_loc8_);
                     _loc84_ = _loc11_.GetLocalPoint(_loc9_);
                     _loc85_ = new b2Vec2(_loc84_.x - _loc83_.x,_loc84_.y - _loc83_.y);
                     _loc86_ = new b2Vec2(-_loc85_.y,_loc85_.x);
                     _loc13_.bleeding.push([_loc83_,_loc84_,_loc86_,BoxUtils.vectorDist(_loc83_,_loc84_)]);
                  }
               }
               else
               {
                  _loc13_.health = 0;
                  Body.Damage(_loc11_,5);
               }
               if(_loc26_ > 0.5)
               {
                  if(_loc4_.temperature > 0 && GameState.madeby != "lightsaber")
                  {
                     _loc87_ = _loc12_.GetLocalPoint(_loc8_);
                     _loc88_ = _loc12_.GetLocalPoint(_loc9_);
                     _loc89_ = new b2Vec2(_loc87_.x - _loc88_.x,_loc87_.y - _loc88_.y);
                     _loc90_ = new b2Vec2(-_loc89_.y,_loc89_.x);
                     _loc14_.bleeding.push([_loc87_,_loc88_,_loc90_,BoxUtils.vectorDist(_loc87_,_loc88_)]);
                  }
               }
               else
               {
                  _loc14_.health = 0;
                  Body.Damage(_loc12_,5);
               }
            }
            else if(_loc4_.alive)
            {
               _loc4_.bleeding.push([_loc3_.GetLocalPoint(_loc8_.Copy()),_loc3_.GetLocalPoint(_loc9_.Copy()),null,1]);
            }
         }
      }
      
      private function goreColour(param1:userData) : uint
      {
         var _loc2_:uint = 0;
         if(GameState.madeby == "lightsaber" || param1.burning)
         {
            if(Math.random() > 0.5)
            {
               _loc2_ = 2236962;
            }
            else
            {
               _loc2_ = param1.bloodColour;
            }
         }
         else if(param1.trigger is Poisoned)
         {
            if(Math.random() > 0.5)
            {
               _loc2_ = 5537551;
            }
            else
            {
               _loc2_ = 9284969;
            }
         }
         else if(param1.trigger is Sanded)
         {
            if(Math.random() > 0.5)
            {
               _loc2_ = 10984556;
            }
            else
            {
               _loc2_ = 12364413;
            }
         }
         else
         {
            _loc2_ = param1.bloodColour;
         }
         return _loc2_;
      }
      
      private function SplitShape(param1:b2PolygonShape, param2:b2Segment, param3:Number, param4:Array, param5:Array) : int
      {
         var _loc25_:Array = null;
         var _loc26_:b2Vec2 = null;
         var _loc27_:* = undefined;
         var _loc28_:b2Vec2 = null;
         if(!param1)
         {
            return -1;
         }
         if(!param4)
         {
            return -1;
         }
         if(param3 <= 0)
         {
            param3 = 0.001;
         }
         var _loc6_:Array = [1];
         var _loc7_:b2Vec2 = new b2Vec2();
         var _loc8_:b2Body = param1.GetBody();
         var _loc9_:b2XForm = _loc8_.GetXForm();
         var _loc10_:int = param1.TestSegment(_loc9_,_loc6_,_loc7_,param2,1);
         var _loc11_:b2Vec2 = param2.p1.Copy();
         _loc11_.Multiply(1 - _loc6_[0]);
         var _loc12_:b2Vec2 = param2.p2.Copy();
         _loc12_.Multiply(_loc6_[0]);
         _loc11_.Add(_loc12_);
         param5[0].x = _loc11_.x;
         param5[0].y = _loc11_.y;
         var _loc13_:b2Segment = new b2Segment();
         _loc13_.p1 = param2.p2;
         _loc13_.p2 = param2.p1;
         var _loc14_:int = param1.TestSegment(_loc9_,_loc6_,_loc7_,_loc13_,1);
         var _loc15_:b2Vec2 = _loc13_.p1.Copy();
         _loc15_.Multiply(1 - _loc6_[0]);
         _loc12_ = _loc13_.p2.Copy();
         _loc12_.Multiply(_loc6_[0]);
         _loc15_.Add(_loc12_);
         param5[1].x = _loc15_.x;
         param5[1].y = _loc15_.y;
         if(_loc10_ != 1)
         {
            this.cutSegment.p1 = _loc15_;
            this.NextCut();
            return -1;
         }
         if(_loc14_ != 1)
         {
            this.NextCut();
            return -2;
         }
         var _loc16_:b2Vec2 = _loc8_.GetLocalPoint(_loc11_);
         var _loc17_:b2Vec2 = _loc8_.GetLocalPoint(_loc15_);
         var _loc18_:Array = param1.GetVertices();
         var _loc19_:Array = [-1,-1];
         var _loc20_:* = -1;
         var _loc21_:int = param1.GetVertexCount();
         var _loc22_:Array = [];
         _loc22_[0] = [];
         _loc22_[1] = [];
         var _loc23_:b2Vec2 = b2Math.b2CrossVF(b2Math.SubtractVV(_loc17_,_loc16_),1);
         var _loc24_:* = 0;
         while(_loc24_ < _loc21_)
         {
            if(b2Math.b2Dot(_loc23_,b2Math.SubtractVV(_loc18_[_loc24_],_loc16_)) > 0)
            {
               _loc27_ = 0;
            }
            else
            {
               _loc27_ = 1;
            }
            if(_loc20_ != _loc27_)
            {
               if(_loc20_ == 0)
               {
                  _loc19_[0] = _loc22_[0].length;
                  _loc22_[0].push(_loc17_,_loc16_);
               }
               else if(_loc20_ == 1)
               {
                  _loc19_[1] = _loc22_[1].length;
                  _loc22_[1].push(_loc16_,_loc17_);
               }
            }
            _loc22_[_loc27_].push(_loc18_[_loc24_]);
            _loc20_ = _loc27_;
            _loc24_++;
         }
         if(_loc19_[0] == -1)
         {
            _loc19_[0] = _loc22_[0].length;
            _loc22_[0].push(_loc17_,_loc16_);
         }
         if(_loc19_[1] == -1)
         {
            _loc19_[1] = _loc22_[1].length;
            _loc22_[1].push(_loc16_,_loc17_);
         }
         if(param3 > 0)
         {
            _loc27_ = 0;
            while(_loc27_ < 2)
            {
               _loc25_ = _loc22_[_loc27_];
               if(_loc19_[_loc27_] > 0)
               {
                  _loc26_ = b2Math.SubtractVV(_loc25_[_loc19_[_loc27_] - 1],_loc25_[_loc19_[_loc27_]]);
               }
               else
               {
                  _loc26_ = b2Math.SubtractVV(_loc25_[_loc25_.length - 1],_loc25_[0]);
               }
               _loc26_.Normalize();
               _loc28_ = b2Math.MulFV(param3,_loc26_);
               _loc25_[_loc19_[_loc27_]] = b2Math.AddVV(_loc25_[_loc19_[_loc27_]],_loc28_);
               if(_loc19_[_loc27_] < _loc25_.length - 2)
               {
                  _loc26_ = b2Math.SubtractVV(_loc25_[_loc19_[_loc27_] + 2],_loc25_[_loc19_[_loc27_] + 1]);
               }
               else
               {
                  _loc26_ = b2Math.SubtractVV(_loc25_[0],_loc25_[_loc25_.length - 1]);
               }
               _loc26_.Normalize();
               _loc28_ = b2Math.MulFV(param3,_loc26_);
               _loc25_[_loc19_[_loc27_] + 1] = b2Math.AddVV(_loc25_[_loc19_[_loc27_] + 1],_loc28_);
               _loc27_++;
            }
         }
         param4[0].vertices = BoxUtils.arrangeClockwise(_loc22_[0]);
         param4[0].vertexCount = _loc22_[0].length;
         param4[1].vertices = BoxUtils.arrangeClockwise(_loc22_[1]);
         param4[1].vertexCount = _loc22_[1].length;
         _loc27_ = 0;
         while(_loc27_ < 2)
         {
            if(this.CheckPolyShape(param4[_loc27_]))
            {
               return -1;
            }
            _loc27_++;
         }
         return 0;
      }
      
      private function CheckPolyShape(param1:b2PolygonDef) : *
      {
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:b2Vec2 = null;
         var _loc12_:* = undefined;
         var _loc13_:b2Vec2 = null;
         var _loc14_:* = undefined;
         var _loc15_:b2Vec2 = null;
         var _loc16_:b2Vec2 = null;
         var _loc17_:* = undefined;
         var _loc18_:b2Vec2 = null;
         var _loc19_:b2Vec2 = null;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:b2Vec2 = null;
         var _loc23_:Number = NaN;
         var _loc24_:b2Vec2 = null;
         var _loc2_:int = param1.vertexCount;
         if(_loc2_ < 3 || _loc2_ > b2Settings.b2_maxPolygonVertices)
         {
            return -1;
         }
         var _loc3_:Array = new Array(_loc2_);
         var _loc4_:* = 0;
         while(_loc4_ < _loc2_)
         {
            _loc9_ = _loc4_;
            _loc10_ = 0;
            if(_loc4_ + 1 < _loc2_)
            {
               _loc10_ = _loc4_ + 1;
            }
            else
            {
               _loc10_ = 0;
            }
            _loc11_ = param1.vertices[_loc10_].Copy();
            _loc11_.Subtract(param1.vertices[_loc9_]);
            if(_loc11_.LengthSquared() < Number.MIN_VALUE * Number.MIN_VALUE)
            {
               return -1;
            }
            _loc3_[_loc4_] = b2Math.b2CrossVF(_loc11_,1);
            _loc3_[_loc4_].Normalize();
            _loc4_++;
         }
         _loc4_ = 0;
         loop1:
         while(_loc4_ < _loc2_)
         {
            _loc12_ = 0;
            while(true)
            {
               if(_loc12_ >= _loc2_)
               {
                  _loc4_++;
                  continue loop1;
               }
               if(!(_loc12_ == _loc4_ || _loc12_ == (_loc4_ + 1) % _loc2_))
               {
                  _loc13_ = b2Math.SubtractVV(param1.vertices[_loc12_],param1.vertices[_loc4_]);
                  _loc14_ = b2Math.b2Dot(_loc3_[_loc4_],_loc13_);
                  if(_loc14_ > -b2Settings.b2_linearSlop)
                  {
                     break;
                  }
               }
               _loc12_++;
            }
            return -1;
         }
         var _loc5_:b2Vec2 = new b2Vec2();
         var _loc6_:Number = 0;
         var _loc7_:b2Vec2 = new b2Vec2(0,0);
         var _loc8_:Number = 1 / 3;
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc15_ = _loc7_;
            _loc16_ = param1.vertices[_loc4_];
            _loc17_ = 0;
            if(_loc4_ + 1 < _loc2_)
            {
               _loc17_ = param1.vertices[_loc4_ + 1];
            }
            else
            {
               _loc17_ = param1.vertices[0];
            }
            _loc18_ = b2Math.SubtractVV(_loc16_,_loc15_);
            _loc19_ = b2Math.SubtractVV(_loc17_,_loc15_);
            _loc20_ = b2Math.b2CrossVV(_loc18_,_loc19_);
            _loc21_ = 0.5 * _loc20_;
            _loc6_ += _loc21_;
            _loc22_ = _loc15_.Copy();
            _loc22_.Add(_loc15_);
            _loc22_.Add(_loc16_);
            _loc23_ = _loc21_ * _loc8_;
            _loc24_ = b2Math.MulFV(_loc23_,_loc22_);
            _loc5_.Add(_loc22_);
            _loc4_++;
         }
         if(_loc6_ < Number.MIN_VALUE)
         {
            return -1;
         }
         b2Math.MulFV(1 / _loc6_,_loc5_);
         return 0;
      }
   }
}

