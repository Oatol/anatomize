package
{
   import Box2D.Collision.Shapes.b2PolygonDef;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2DistanceJoint;
   import Box2D.Dynamics.Joints.b2PrismaticJoint;
   import Box2D.Dynamics.Joints.b2RevoluteJoint;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Gun.Firearm;
   import environment.OpenWorld;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import shiny.*;
   import triggers.*;
   
   public class Obj
   {
      
      public var spawnSkin:Vector.<Array>;
      
      public var spawnName:String;
      
      public var spawnNode:Object;
      
      public var spawnTitle:String;
      
      public var spawnCreator:String;
      
      public var spawnDetails:String;
      
      public var spawnLinks:Boolean = false;
      
      public var spawnCustom:Boolean = false;
      
      public var spawnCustomContent:String;
      
      public var spawnLocal:Boolean = false;
      
      public var spawnSprite:Sprite;
      
      public var spawnScale:Number = 1;
      
      public var spawnAngle:Number = 0;
      
      public var spawnAlpha:Number = 1;
      
      public var spawnAlphas:Array = [];
      
      public var prevSkin:Vector.<Array>;
      
      public var prevName:String;
      
      public var libraryItems:Array;
      
      public function Obj()
      {
         super();
      }
      
      public function spawnConsoleObject(param1:String, param2:Number = 30, param3:Number = 30, param4:Number = 0, param5:Boolean = false) : void
      {
         this.spawnObject(param1,param2,param3,param4,param5,true);
      }
      
      public function delayedSpawnObject(param1:String, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Boolean = false, param6:Boolean = false, param7:Vector.<Array> = null, param8:b2Body = null) : b2Body
      {
         var _loc9_:b2Body = this.spawnObject(param1,-Math.random() * 1000,-Math.random() * 1000,param4,param5,param6,param7);
         if(_loc9_)
         {
            if(param8)
            {
               userData(_loc9_.GetUserData()).ignored.push(param8);
            }
            _loc9_.SetXForm(new b2Vec2(param2 / Vars.physScale,param3 / Vars.physScale),param4 * Vars.toRadians);
         }
         return _loc9_;
      }
      
      public function veryDelayedSpawnObject(param1:String, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Boolean = false, param6:Boolean = false, param7:Vector.<Array> = null) : b2Body
      {
         var _loc8_:b2Body = this.spawnObject(param1,-500 + Math.random() * 100 - 50,-500 + Math.random() * 100 - 50,param4,param5,param6,param7);
         userData(_loc8_.GetUserData()).justSpawned = true;
         if(_loc8_)
         {
            userData(_loc8_.GetUserData()).trigger = new DelayedTeleport(1,new b2Vec2(param2,param3));
            userData(_loc8_.GetUserData()).triggered = true;
         }
         return _loc8_;
      }
      
      public function spawnItem(param1:Array, param2:Array, param3:Number, param4:*, param5:Number, param6:Number, param7:Number, param8:Array, param9:String = "none", param10:Vector.<Array> = null) : b2Body
      {
         var _loc13_:String = null;
         var _loc19_:Boolean = false;
         var _loc22_:Sprite = null;
         var _loc23_:uint = 0;
         var _loc24_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc33_:userData = null;
         var _loc34_:Array = null;
         var _loc35_:b2PolygonDef = null;
         var _loc36_:Vector.<b2Vec2> = null;
         var _loc37_:int = 0;
         var _loc38_:Number = NaN;
         var _loc39_:int = 0;
         var _loc40_:b2Vec2 = null;
         var _loc41_:Number = NaN;
         var _loc42_:Number = NaN;
         var _loc43_:b2Vec2 = null;
         var _loc44_:int = 0;
         var _loc45_:b2Vec2 = null;
         var _loc46_:DisplayObject = null;
         var _loc11_:Number = Vars.objSize * this.spawnScale;
         if(GameState.environmenting)
         {
            _loc11_ = 1;
         }
         if(!GameState.loading)
         {
            if(_loc11_ > Tweak.ScaleMax)
            {
               _loc11_ = Tweak.ScaleMax;
            }
            if(_loc11_ < Tweak.ScaleMin)
            {
               _loc11_ = Tweak.ScaleMin;
            }
         }
         _loc11_ *= param3;
         var _loc12_:b2BodyDef = new b2BodyDef();
         _loc12_.angle = param7;
         if(param4 is String)
         {
            _loc33_ = Properties.objectProperties(param4);
            _loc12_.userData = _loc33_;
            _loc13_ = param4;
         }
         else
         {
            if(!(param4 is userData))
            {
               return null;
            }
            _loc12_.userData = param4;
            _loc13_ = param4.name;
         }
         _loc12_.position.Set(param5 / Physics.scale,param6 / Physics.scale);
         _loc12_.linearDamping = 0;
         _loc12_.angularDamping = 0;
         if(!GameState.environmenting)
         {
            _loc12_.linearDamping = Vars.objDampLinear;
            _loc12_.angularDamping = Vars.objDampAngular;
         }
         if(_loc13_ == "dart" || _loc13_ == "kunai" || _loc13_ == "nail" || _loc13_ == "arrow" || _loc13_ == "blowdart" || _loc13_ == "smiter" || _loc13_ == "dartball")
         {
            _loc12_.angularDamping = Vars.objDampAngular + 3;
         }
         if(_loc13_ == "hoverboard" || _loc13_ == "frisbee" || _loc13_ == "paperairplane" || _loc13_ == "aimarrow" || _loc13_ == "maimarrow" || _loc13_ == "razorrimmedhat" || _loc13_ == "bombdisc")
         {
            _loc12_.angularDamping = Vars.objDampAngular + 10;
         }
         else if(_loc13_ == "portal1" || _loc13_ == "portal2" || _loc13_ == "blackhole" || _loc13_ == "darknesstear")
         {
            _loc12_.angularDamping = 9000;
            _loc12_.linearDamping = 9000;
         }
         else if(_loc13_ == "identitydisc" || _loc13_ == "dronejanitor")
         {
            _loc12_.angularDamping = 1;
         }
         else if(_loc13_ == "neurogas" || _loc13_ == "fog")
         {
            _loc12_.linearDamping = 1;
         }
         else if(_loc13_ == "toiletpaperresidue")
         {
            _loc12_.linearDamping = 1;
            _loc12_.angularDamping = 1;
         }
         else if(_loc13_ == "parachute")
         {
            _loc12_.linearDamping = 0.5;
            _loc12_.angularDamping = 0.5;
         }
         else if(_loc13_ == "shuttlecock")
         {
            _loc12_.angularDamping = 20;
         }
         else if(_loc13_ == "bliss")
         {
            _loc12_.angularDamping = 10;
            _loc12_.linearDamping = 1;
         }
         if(Properties.forceObjFixed == 1)
         {
            _loc12_.fixedRotation = true;
         }
         var _loc14_:b2Body = Physics.world.CreateBody(_loc12_);
         if(!_loc14_)
         {
            return null;
         }
         var _loc15_:userData = userData(_loc14_.GetUserData());
         var _loc16_:Item = O.getItem(_loc13_);
         if(_loc16_)
         {
            _loc15_.item = _loc16_;
         }
         var _loc17_:Number = Vars.objSize * this.spawnScale;
         if(_loc17_ > Tweak.ScaleMax)
         {
            _loc17_ = Tweak.ScaleMax;
         }
         if(_loc17_ < Tweak.ScaleMin)
         {
            _loc17_ = Tweak.ScaleMin;
         }
         _loc15_.size = _loc17_;
         if(Main.instance.forceFlip)
         {
            _loc15_.flipped = true;
            Main.instance.forceFlip = false;
         }
         var _loc18_:Array = param1;
         if(_loc15_.flipped)
         {
            _loc18_ = GeneralUtils.flipArray(_loc18_);
         }
         if(_loc16_)
         {
            this.spawnAlphas = _loc16_.alphas;
         }
         var _loc20_:Sprite = new Sprite();
         var _loc21_:Sprite = new Sprite();
         var _loc25_:int = int(_loc18_.length);
         _loc20_.mouseEnabled = false;
         _loc21_.mouseEnabled = false;
         var _loc26_:Array = [];
         var _loc27_:Array = [];
         var _loc28_:Array = [];
         _loc29_ = 0;
         for(; _loc29_ < _loc25_; _loc29_++)
         {
            _loc19_ = false;
            _loc34_ = _loc18_[_loc29_];
            _loc35_ = new b2PolygonDef();
            _loc35_.userData = Properties.shapeProperties("none") as ShapeUserData;
            if(param8[0] != "disabled")
            {
               if(param8[_loc29_] is String)
               {
                  _loc35_.userData = Properties.shapeProperties(param8[_loc29_]);
               }
               else if(param8[_loc29_] is Object)
               {
                  _loc35_.userData = param8[_loc29_] as ShapeUserData;
                  if(ShapeUserData(param8[_loc29_]).sensor)
                  {
                     _loc19_ = true;
                  }
               }
            }
            if(Boolean(this.spawnAlphas) && this.spawnAlphas.length > 0)
            {
               ShapeUserData(_loc35_.userData).alpha = this.spawnAlphas[_loc29_];
            }
            if(Boolean(this.spawnSkin) && !param10)
            {
               param10 = this.spawnSkin;
            }
            if(Properties.forceObjStatic)
            {
               _loc35_.density = 0;
            }
            else if(param2[_loc29_] != undefined)
            {
               _loc35_.density = Vars.objDensity * param2[_loc29_];
            }
            else
            {
               _loc35_.density = Vars.objDensity * param2[0];
            }
            _loc15_.density = 1;
            _loc35_.restitution = 0.2;
            _loc35_.friction = 0.5;
            if(!GameState.environmenting)
            {
               _loc15_.density = Properties.forceObjStatic ? 0 : Vars.objDensity;
               _loc35_.restitution = Vars.objRestitution;
               _loc35_.friction = Vars.objFriction;
            }
            _loc35_.vertexCount = _loc34_.length;
            _loc35_.isSensor = _loc19_;
            _loc36_ = new Vector.<b2Vec2>();
            _loc37_ = int(_loc34_.length);
            _loc38_ = 0;
            while(_loc38_ < _loc37_)
            {
               _loc36_.push(new b2Vec2(_loc34_[_loc38_][0] * _loc11_ / Physics.scale,_loc34_[_loc38_][1] * _loc11_ / Physics.scale));
               _loc38_++;
            }
            if(ShapeUserData(_loc35_.userData).decorative)
            {
               if(ShapeUserData(_loc35_.userData).randomDecoration)
               {
                  if(Math.random() > 0.5)
                  {
                     continue;
                  }
               }
               _loc26_.push(ShapeUserData(_loc35_.userData).name);
               _loc27_.push(ShapeUserData(_loc35_.userData).alpha);
               _loc28_.push(_loc36_);
            }
            else
            {
               _loc39_ = int(_loc36_.length);
               _loc38_ = 0;
               while(_loc38_ < _loc39_)
               {
                  _loc40_ = _loc36_[_loc38_];
                  b2Vec2(_loc35_.vertices[_loc38_]).Set(_loc40_.x,_loc40_.y);
                  _loc38_++;
               }
               _loc14_.CreateShape(_loc35_);
            }
         }
         _loc29_ = _loc26_.length - 1;
         while(_loc29_ >= 0)
         {
            _loc23_ = BoxUtils.shapeNameToColour(_loc26_[_loc29_],param10);
            _loc24_ = Number(_loc27_[_loc29_]);
            _loc21_.graphics.beginFill(_loc23_,_loc24_);
            _loc36_ = _loc28_[_loc29_];
            _loc41_ = _loc36_[0].x * Physics.scale;
            _loc42_ = _loc36_[0].y * Physics.scale;
            _loc21_.graphics.moveTo(_loc41_,_loc42_);
            _loc39_ = int(_loc36_.length);
            _loc44_ = 0;
            while(_loc44_ < _loc39_)
            {
               _loc43_ = _loc36_[_loc44_];
               if(_loc43_)
               {
                  _loc21_.graphics.lineTo(_loc43_.x * Physics.scale,_loc43_.y * Physics.scale);
               }
               _loc44_++;
            }
            _loc21_.graphics.lineTo(_loc41_,_loc42_);
            _loc29_--;
         }
         _loc14_.SetMassFromShapes();
         _loc14_.SetXForm(new b2Vec2(param5 / Physics.scale,param6 / Physics.scale),_loc14_.GetAngle());
         if(World.toggleIntegerSnap == 1)
         {
            _loc45_ = new b2Vec2();
            _loc45_.x = Math.round(_loc14_.GetPosition().x * Physics.scale) / Physics.scale;
            _loc45_.y = Math.round(_loc14_.GetPosition().y * Physics.scale) / Physics.scale;
            _loc14_.SetXForm(_loc45_,_loc14_.GetAngle());
         }
         if(_loc15_.sleepOnSpawn)
         {
            _loc14_.PutToSleep();
         }
         var _loc30_:* = BoxUtils.bodyDimensions(_loc14_);
         _loc15_.width = _loc30_[0];
         _loc15_.height = _loc30_[1];
         _loc15_.hull = GameState.hullHandler.convexHull(GameState.hullHandler.convert(_loc18_,_loc11_));
         if(param10)
         {
            _loc15_.skin = param10.concat();
         }
         _loc20_.graphics.endFill();
         _loc20_.graphics.lineStyle();
         _loc20_.mouseEnabled = false;
         _loc20_.mouseChildren = false;
         if(Properties.forceObjStain)
         {
            _loc15_.stainless = true;
         }
         if(Properties.forceObjGhost)
         {
            _loc15_.ghost = true;
         }
         _loc15_.multiConcussion = Vars.stabSettings["% Concussion"];
         _loc15_.multiStanding = Vars.stabSettings["% Standing"];
         _loc15_.multiStabForce = Vars.stabSettings["% Skin Thickness"];
         _loc15_.multiStabDensity = Vars.stabSettings["% Body Density"];
         _loc15_.multiBulletPenetration = Vars.stabSettings["% Bullet Penetration"];
         _loc15_.multiGlobalDamage = Vars.stabSettings["% Global Damage"];
         _loc15_.multiBulletDamage = Vars.stabSettings["% Bullet Damage"];
         _loc15_.multiBluntDamage = Vars.stabSettings["% Blunt Damage"];
         _loc15_.multiBleedDamage = Vars.stabSettings["% Bleed Damage"];
         _loc15_.multiSharpDamage = Vars.stabSettings["% Sharp Damage"];
         _loc15_.multiRegen = Vars.stabSettings["% Regeneration"];
         var _loc31_:Sprite = BoxUtils.bodyToSprite(_loc14_,_loc15_.size);
         if(Properties.forceObjInvis)
         {
            _loc31_.alpha = 0;
         }
         _loc15_.graphic = _loc31_;
         _loc15_.graphic.y = 2000;
         Main.instance.itemSprite.addChild(_loc15_.graphic);
         _loc21_.name = "decals";
         _loc15_.graphic.addChild(_loc21_);
         if(GameState.isCapable && Boolean(_loc15_.graphic.getChildByName("effects")))
         {
            if(Boolean(World.togglePreciseEffects) && _loc14_.m_shapeCount > 1)
            {
               _loc46_ = new Shape();
               Shape(_loc46_).graphics.drawGraphicsData(_loc21_.graphics.readGraphicsData(false));
               Shape(_loc46_).graphics.drawGraphicsData(Sprite(_loc15_.graphic.getChildByName("item")).graphics.readGraphicsData(false));
               _loc46_.cacheAsBitmap = true;
            }
            else
            {
               _loc46_ = GameState.hullHandler.drawHullFilled(_loc15_.hull,0,0,1);
            }
            if(_loc25_ == 1)
            {
               _loc46_.scaleX = _loc46_.scaleY = 1.02;
            }
            _loc15_.graphic.addChild(_loc46_);
            _loc15_.graphic.getChildByName("effects").mask = _loc46_;
         }
         var _loc32_:Bitmap = BoxUtils.getEffectBM(_loc14_);
         if(_loc32_)
         {
            _loc15_.graphic.addChild(_loc15_.graphic.getChildByName("effects"));
         }
         if(_loc15_.graphic)
         {
            _loc15_.graphic.mouseEnabled = false;
            _loc15_.graphic.mouseChildren = false;
            if(Boolean(GameState.spawning) && Boolean(this.spawnSprite) && this.spawnSprite.alpha != 1)
            {
               _loc15_.alpha = this.spawnSprite.alpha;
            }
         }
         if(_loc14_.IsStatic())
         {
            _loc15_.graphic.cacheAsBitmap = true;
         }
         this.spawnAlphas = null;
         userData(_loc14_.GetUserData()).body = _loc14_;
         return _loc14_;
      }
      
      public function spawnObject(param1:String, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Boolean = false, param6:Boolean = false, param7:Vector.<Array> = null) : b2Body
      {
         /*
          * 反编译错误
          * 代码可能被混淆
          * 提示：您可以尝试在“设置”中启用“反混淆代码”选项。
          * 错误类型: ExecutionException (java.lang.StackOverflowError)
          */
         throw new flash.errors.IllegalOperationError("由于错误未进行反编译");
      }
      
      private function ObjValue(param1:*, param2:String) : *
      {
         if(param2)
         {
            return param2;
         }
         return param1;
      }
      
      private function AddGunToBody(param1:b2Body, param2:Object) : *
      {
         var _loc3_:String = null;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Firearm = null;
         _loc3_ = this.ObjValue("pis",param2.projectile);
         _loc4_ = Number(this.ObjValue(1,param2.size));
         _loc5_ = int(this.ObjValue(1,param2.amount));
         _loc6_ = int(this.ObjValue(60,param2.reload));
         _loc7_ = int(this.ObjValue(100,param2.force));
         _loc8_ = int(this.ObjValue(1,param2.recoil));
         _loc9_ = int(this.ObjValue(1,param2.scatter));
         _loc10_ = Number(this.ObjValue(0,param2.muzzleX));
         _loc11_ = Number(this.ObjValue(-_loc10_,param2.muzzleFlipX));
         _loc12_ = Number(this.ObjValue(0,param2.muzzleY));
         _loc13_ = int(this.ObjValue(1,param2.magazineSize));
         _loc14_ = int(this.ObjValue(1,param2.cycleTime));
         _loc15_ = Number(this.ObjValue(0,param2.bulletAngle));
         _loc16_ = Number(this.ObjValue(0,param2.angle));
         if(param2.muzzleAngle)
         {
            _loc16_ = Number(this.ObjValue(0,param2.muzzleAngle));
         }
         _loc17_ = new Firearm(param2.object,param1,_loc6_,_loc7_,_loc8_,_loc9_,_loc3_,_loc4_,_loc5_);
         _loc17_.datPos = new b2Vec2(_loc10_ / Physics.scale,_loc12_ / Physics.scale);
         _loc17_.datPosFlipped = new b2Vec2(_loc11_ / Physics.scale,_loc12_ / Physics.scale);
         _loc17_.InitGun(_loc14_,_loc6_,_loc7_,_loc8_,_loc9_,_loc4_,_loc5_,_loc13_,_loc16_,_loc15_);
         _loc17_.chamberTime = int(this.ObjValue(1,param2.cycleTime));
         _loc17_.burstAmount = int(this.ObjValue(0,param2.burst));
         _loc17_.burstDelay = int(this.ObjValue(10,param2.burstDelay));
         _loc17_.allowBarrelAttachments = Boolean(this.ObjValue(true,param2.barrelAttachments));
         _loc17_.disableAfterFiring = Boolean(this.ObjValue(true,param2.continuousTrigger));
         _loc17_.casingReload = Boolean(this.ObjValue(true,param2.casingReload));
         _loc17_.destroyAfterFiring = Boolean(this.ObjValue(false,param2.destroyAfterFiring));
         if(param2.bulletProperties)
         {
            _loc17_.bulletProperties = param2.bulletProperties.split(",");
         }
         _loc17_.randomBulletAngle = Number(this.ObjValue(0,param2.randomAngle));
         _loc17_.randomBulletSize = Number(this.ObjValue(0,param2.randomSize));
         if(Boolean(param2.sounds) && Boolean(param2.volumes))
         {
            _loc17_.attachSounds(param2.sounds.split(","),param2.volumes.split(","));
         }
         Main.instance.firearmArray.push(_loc17_);
      }
      
      private function AddArmourToBody(param1:b2Body, param2:Object) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         var _loc14_:b2Vec2 = null;
         var _loc15_:b2Vec2 = null;
         var _loc16_:userData = null;
         _loc3_ = 100;
         _loc4_ = 0.2;
         _loc5_ = 0.5;
         _loc6_ = 50;
         _loc7_ = 0;
         _loc8_ = true;
         _loc9_ = false;
         _loc10_ = false;
         _loc11_ = false;
         _loc12_ = false;
         _loc13_ = false;
         _loc14_ = new b2Vec2();
         _loc15_ = new b2Vec2();
         if(param2.health)
         {
            _loc3_ = Number(param2.health);
         }
         if(param2.blunt)
         {
            _loc4_ = Number(param2.blunt);
         }
         if(param2.bullet)
         {
            _loc5_ = Number(param2.bullet);
         }
         if(param2.cut)
         {
            _loc6_ = Number(param2.cut);
         }
         if(param2.angle)
         {
            _loc7_ = Number(param2.angle);
         }
         if(param2.cutProtect)
         {
            _loc8_ = param2.cutProtect == "true";
         }
         if(param2.hideHead)
         {
            _loc9_ = param2.hideHead == "true";
         }
         if(param2.allowOther)
         {
            _loc12_ = param2.allowOther == "true";
         }
         if(param2.collideDolls)
         {
            _loc13_ = param2.collideDolls == "true";
         }
         if(param2.flipX)
         {
            _loc10_ = param2.flipX == "true";
         }
         if(param2.flipY)
         {
            _loc11_ = param2.flipY == "true";
         }
         if(param2.x)
         {
            _loc14_.x = Number(param2.x);
         }
         if(param2.y)
         {
            _loc14_.y = Number(param2.y);
         }
         if(param2.triggerPos)
         {
            _loc14_.x = param2.triggerPos.split(",")[0];
         }
         if(param2.triggerPos)
         {
            _loc14_.y = param2.triggerPos.split(",")[1];
         }
         if(param2.triggerPosFlip)
         {
            _loc15_.x = param2.triggerPosFlipped.split(",")[0];
         }
         if(param2.triggerPosFlip)
         {
            _loc15_.y = param2.triggerPosFlipped.split(",")[1];
         }
         _loc16_ = userData(param1.GetUserData());
         if(param2.armour == "torso")
         {
            _loc16_.armour = new ArmourTorso(param1,_loc3_,999,_loc4_,_loc5_,_loc6_);
         }
         else if(param2.armour == "chest")
         {
            _loc16_.armour = new ArmourTorso(param1,_loc3_,0,_loc4_,_loc5_,_loc6_);
         }
         else if(param2.armour == "stomach")
         {
            _loc16_.armour = new ArmourTorso(param1,_loc3_,1,_loc4_,_loc5_,_loc6_);
         }
         else if(param2.armour == "belt")
         {
            _loc16_.armour = new ArmourTorso(param1,_loc3_,2,_loc4_,_loc5_,_loc6_);
         }
         else if(param2.armour == "thigh")
         {
            _loc16_.armour = new ArmourThigh(param1,_loc3_,_loc4_,_loc5_,_loc6_);
         }
         else if(param2.armour == "boot")
         {
            _loc16_.armour = new ArmourBoot(param1,_loc3_,_loc4_,_loc5_,_loc6_);
         }
         else if(param2.armour == "shoulder")
         {
            _loc16_.armour = new ArmourShoulder(param1,_loc3_,_loc4_,_loc5_,_loc6_);
         }
         else if(param2.armour == "glove")
         {
            _loc16_.armour = new ArmourGlove(param1,_loc3_,_loc4_,_loc5_,_loc6_);
         }
         else if(param2.armour == "back")
         {
            _loc16_.armour = new ArmourBack(param1,_loc3_,_loc4_,_loc5_,_loc6_);
         }
         else
         {
            _loc16_.armour = new ArmourHelmet(param1,_loc3_,_loc4_,_loc5_,_loc6_);
            ArmourHelmet(_loc16_.armour).hideHead = _loc9_;
         }
         Armour(_loc16_.armour).equipAngleOffset = _loc7_;
         Armour(_loc16_.armour).protectFromCuts = _loc8_;
         Armour(_loc16_.armour).allowOther = _loc12_;
         Armour(_loc16_.armour).collideWithDolls = _loc13_;
         _loc16_.triggerPos = _loc14_;
         if(_loc15_.x == 0 && _loc15_.y == 0)
         {
            if(_loc10_ || _loc11_)
            {
               _loc15_ = _loc14_.Copy();
               if(_loc10_)
               {
                  _loc15_.x *= -1;
               }
               if(_loc11_)
               {
                  _loc15_.y *= -1;
               }
               _loc16_.triggerPosFlipped = _loc15_;
            }
         }
         if(param2.linkOnEquip)
         {
            Armour(_loc16_.armour).linkOnEquip = true;
         }
         if(param2.triggerOnEquip)
         {
            Armour(_loc16_.armour).triggerOnEquip = true;
         }
      }
      
      private function AddTriggerToBody(param1:b2Body, param2:String) : void
      {
         var availableTriggersToKeepCompilerHappy:Array;
         var bud:userData = null;
         var type:Class = null;
         var fa:Firearm = null;
         var bod:b2Body = param1;
         var trig:String = param2;
         bud = userData(bod.GetUserData());
         if(!bud)
         {
            return;
         }
         availableTriggersToKeepCompilerHappy = [Repel,DoorLever,DroneDisruptor,SpeakerBox,JointRemover,MedicalSwitch,VelocitySwitch,KinetizerPortable,BatteryTrigger,BlueBlood,LaserGrenade,PetrifyRadius,CeilingFan,PaintOnCollision,RGB,ProjectileChange,TransmuteRandom,DiscoLight,RemoteGimbal,CameraGimbal,VirtualJoystick,CutOnCollision,BrittleExplosion,MoveLinkedForward,MoveToMouse,MoveLinkedToMouse,PointAtLinked,PointRandom,DoubleOrNothing,TriggerLinkedInRadius,LightSource,Slowmotion,CloneProperties,CloneLinks,VirtualTrigger,JumpLinked,TemperatureInRadius,SetTemperatureInRadius,Airstrike,D20,AnnoyingAlarmClock,EmitProjectiles,SpawnItems,ApplyForceSpecific,PourSpawnProjectile,DestroyOnColour,SpawnItemsSlowly,DrawStage,MagnetWhenSwung,TeleportBehindOnHit,SpawnItemsWhenSwung,LinkToJointed,MeltAndPour,FireworkGrenade,RotAndWorms,DisintegrateOnHit,BrickMine,ExplodeInRadius,HoleInRadius,BouldersWhenSpun,RandomEffectInRadius,RandomEffectOnHit,ProjectilesWhenSpunOrSwung,ProjectilesOnEverything,ProjectilesOnSharp
         ,RandomPropertiesOnHit,GraphicsWidth,TriggerLinkedOnDestroy,SayRandomLine,DisintegrateIntoParticles,SpawnItemsCraft,DrainHeal,SpaghettiInRadius,LinkLinkedToRay,DoorSwitch,DoorSwitchAlpha,ApplyEffectOnSharp,CameraFollowLinked,ApplyEffectInRadius,ApplyEffectToLinked,AimAtLinkedAttachment,JointSlinger,AutoJoint,CloneEffect,TriggerNext,BlockBarrelAttachment,SoundBarrelAttachment,BeltAttachment,StockAttachment,TimeScatter,FirearmReloadRequired,FirearmAttachRequired,ApplyEffectOnStick,BubbleGum,GraphicsVariance,LetterBullet,ExplodeAfterDuration,JointZapper,ApplyEffectBeam];
         try
         {
            if(trig.indexOf("::") != -1)
            {
               type = getDefinitionByName(trig) as Class;
               if(bud.trigger is Gun)
               {
                  fa = Gun(bud.trigger).firearm;
                  bud.trigger = new type(fa);
               }
               else
               {
                  bud.trigger = new type();
               }
               return;
            }
         }
         catch(e:ReferenceError)
         {
            GameState.ui.showTooltip(GameState.ui.menuMain,trig + " functionality isn\'t available. Fix the " + bud.name + " model and try again.\n\n\n",0,2000,250);
         }
         switch(trig)
         {
            case "hazmat":
               bud.trigger = new Hazmat(bod);
               break;
            case "animateHead":
               bud.trigger = new AnimateHead(bod);
               break;
            case "slowmotion":
               bud.trigger = new SlowmotionOnCut();
               bud.triggered = true;
               break;
            case "scaredrone":
               bud.trigger = new ScareDrone();
               bud.triggered = true;
               bud.triggerRadius = 200;
               bud.triggerForce = 100;
               break;
            case "pocket":
               bud.trigger = new Pocket();
               break;
            case "tapper":
               bud.trigger = new HeadTapper();
               break;
            case "ultrasharp":
               bud.trigger = new UltraSharp(bud.triggerForce,bud.triggerColour);
               break;
            case "dronesurgeon":
               bud.trigger = new DroneMedic();
               bud.triggerState = 1;
               break;
            case "sanitizerbottle":
               bud.trigger = new SanitizerBottle();
               break;
            case "handsanitizer":
               bud.trigger = new HandSanitizer();
               break;
            case "medkit":
               bud.trigger = new Medkit();
               break;
            case "HealPill":
               bud.trigger = new HealingPill();
               break;
            case "RegenPill":
               bud.trigger = new RegenKit();
               break;
            case "RepairPill":
               bud.trigger = new RepairKit();
               break;
            case "MutatePill":
               bud.trigger = new MutatePill();
               break;
            case "sanitizerunit":
               bud.trigger = new SanitizerMachine();
               break;
            case "toiletpaper":
               bud.trigger = new ToiletPaper();
               break;
            case "healConnected":
               bud.trigger = new HealConnected();
               break;
            case "magnet":
               bud.trigger = new Magnet();
               break;
            case "moverX":
               bud.trigger = new MoverX();
               break;
            case "moverY":
               bud.trigger = new MoverY();
               break;
            case "pistonX":
               bud.trigger = new MoverXLoop();
               break;
            case "pistonY":
               bud.trigger = new MoverYLoop();
               break;
            case "pistonMotor":
               bud.trigger = new MotorLoop();
               break;
            case "propulsor":
               bud.trigger = new Propulsor();
         }
      }
      
      public function addbullet(param1:String, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:b2Vec2, param8:Number, param9:b2Body, param10:Number = 0) : b2Body
      {
         var _loc11_:Number = NaN;
         var _loc12_:b2Body = null;
         var _loc13_:Array = null;
         var _loc14_:Number = NaN;
         var _loc15_:userData = null;
         var _loc17_:Firearm = null;
         var _loc18_:Number = NaN;
         var _loc19_:b2Vec2 = null;
         var _loc20_:Array = null;
         var _loc21_:int = 0;
         var _loc22_:userData = null;
         var _loc23_:* = undefined;
         var _loc24_:* = undefined;
         var _loc25_:b2Vec2 = null;
         var _loc26_:userData = null;
         var _loc27_:int = 0;
         var _loc28_:Array = null;
         var _loc29_:Number = NaN;
         var _loc30_:Array = null;
         var _loc31_:Array = null;
         var _loc32_:int = 0;
         var _loc33_:Array = null;
         var _loc34_:int = 0;
         var _loc35_:String = null;
         var _loc36_:userData = null;
         var _loc37_:userData = null;
         var _loc38_:Array = null;
         var _loc39_:b2Body = null;
         var _loc40_:BitmapData = null;
         var _loc41_:int = 0;
         var _loc42_:Item = null;
         var _loc43_:Vector.<Array> = null;
         var _loc44_:uint = 0;
         var _loc45_:Array = null;
         var _loc46_:userData = null;
         var _loc47_:Array = null;
         var _loc48_:b2Body = null;
         var _loc49_:Array = null;
         var _loc50_:int = 0;
         var _loc51_:Number = NaN;
         var _loc52_:Vector.<MyLittleParticle> = null;
         var _loc53_:MyLittleParticle = null;
         var _loc54_:Number = NaN;
         var _loc55_:Number = NaN;
         var _loc56_:int = 0;
         var _loc57_:Array = null;
         var _loc58_:userData = null;
         var _loc59_:Class = null;
         var _loc60_:* = undefined;
         var _loc61_:Number = NaN;
         var _loc62_:Number = NaN;
         var _loc63_:b2Vec2 = null;
         var _loc64_:b2Vec2 = null;
         var _loc65_:Array = null;
         var _loc66_:b2Body = null;
         var _loc67_:userData = null;
         var _loc68_:b2Vec2 = null;
         var _loc69_:Number = NaN;
         var _loc70_:int = 0;
         var _loc71_:int = 0;
         var _loc72_:Number = NaN;
         var _loc73_:Number = NaN;
         var _loc74_:String = null;
         var _loc75_:int = 0;
         var _loc76_:int = 0;
         var _loc77_:int = 0;
         var _loc78_:int = 0;
         var _loc79_:int = 0;
         var _loc80_:int = 0;
         var _loc81_:b2Vec2 = null;
         var _loc82_:Array = null;
         var _loc83_:Vector.<Array> = null;
         var _loc84_:Vector.<Array> = null;
         var _loc85_:int = 0;
         var _loc86_:Array = null;
         var _loc87_:String = null;
         var _loc88_:Item = null;
         var _loc89_:int = 0;
         var _loc90_:int = 0;
         var _loc91_:int = 0;
         var _loc92_:b2Vec2 = null;
         var _loc93_:b2Vec2 = null;
         var _loc94_:b2DistanceJoint = null;
         var _loc95_:Array = null;
         var _loc96_:String = null;
         var _loc97_:Array = null;
         var _loc98_:String = null;
         var _loc99_:Number = NaN;
         var _loc100_:Boolean = false;
         var _loc101_:Boolean = false;
         var _loc102_:Boolean = false;
         var _loc103_:Boolean = false;
         var _loc104_:b2PrismaticJoint = null;
         var _loc105_:GrappleGun = null;
         var _loc106_:b2Vec2 = null;
         var _loc107_:int = 0;
         var _loc108_:b2Body = null;
         var _loc109_:userData = null;
         var _loc110_:int = 0;
         var _loc111_:Boolean = false;
         var _loc112_:Vector.<b2Body> = null;
         var _loc113_:int = 0;
         var _loc114_:int = 0;
         var _loc115_:int = 0;
         var _loc116_:b2Body = null;
         var _loc117_:* = undefined;
         var _loc118_:b2Vec2 = null;
         var _loc119_:PortalGun = null;
         var _loc120_:int = 0;
         var _loc121_:b2Vec2 = null;
         var _loc122_:b2Vec2 = null;
         var _loc123_:b2Vec2 = null;
         var _loc124_:b2Vec2 = null;
         var _loc125_:Array = null;
         var _loc126_:Number = NaN;
         var _loc127_:Number = NaN;
         var _loc128_:Number = NaN;
         var _loc129_:Number = NaN;
         var _loc130_:b2Vec2 = null;
         var _loc131_:* = 0;
         var _loc132_:Boolean = false;
         var _loc133_:Boolean = false;
         var _loc134_:Number = NaN;
         var _loc135_:Number = NaN;
         var _loc136_:Array = null;
         var _loc137_:b2Body = null;
         var _loc138_:Number = NaN;
         var _loc139_:Number = NaN;
         var _loc140_:Number = NaN;
         var _loc141_:Number = NaN;
         var _loc142_:userData = null;
         var _loc143_:b2Vec2 = null;
         var _loc144_:Array = null;
         var _loc145_:ParticleEffect = null;
         _loc11_ = param4;
         if(!param1)
         {
            return null;
         }
         if(param1 == "none")
         {
            return null;
         }
         if(!Tool.isAim || Main.instance.selectedBodies.length == 0)
         {
            param9.WakeUp();
         }
         if(isNaN(param6))
         {
            param6 = 1;
         }
         _loc14_ = Vars.objSize;
         _loc15_ = userData(param9.GetUserData());
         var _loc16_:b2Vec2 = param9.GetWorldCenter();
         if(_loc15_.trigger is Gun)
         {
            _loc17_ = Gun(_loc15_.trigger).firearm;
         }
         Vars.objSize = param6;
         _loc18_ = Vars.objDensity;
         if(Vars.objDensity == 0)
         {
            Vars.objDensity = 1;
         }
         _loc19_ = new b2Vec2(param2,param3);
         _loc20_ = ["fire3","fire3","fire3","slice","slice","shock","smoke"];
         _loc21_ = 0;
         while(_loc21_ < param5)
         {
            _loc11_ = param4;
            if(_loc17_)
            {
               _loc11_ += (Math.random() * _loc17_.randomBulletAngle - _loc17_.randomBulletAngle * 0.5) * Vars.toRadians;
            }
            if(_loc15_.flipped && _loc15_.trigger is Gun)
            {
               Main.instance.forceFlip = true;
            }
            if(param5 > 1)
            {
               param2 = _loc19_.x + Math.random() * 0.5 - 0.25;
               param3 = _loc19_.y + Math.random() * 0.5 - 0.25;
            }
            if(param1 == "pis" || param1 == "smg" || param1 == "ass" || param1 == "min" || param1 == "sni" || param1 == "rif" || param1 == "dev" || param1 == "9mm" || param1 == "turret")
            {
               _loc27_ = 0;
               while(_loc27_ < (Math.random() * 6 + 3) / param5)
               {
                  _loc35_ = _loc20_[int(Math.random() * _loc20_.length)];
                  if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                  {
                     _loc35_ = _loc15_.pfx.getParticle();
                  }
                  GameState.particles.addParticles(param2 * Physics.scale,param3 * Physics.scale,1,_loc35_,param7.x * _loc27_ / 200,param7.y * _loc27_ / 200,2,2);
                  _loc27_++;
               }
               _loc28_ = ["bullet_" + param1];
               _loc13_ = GeneralUtils.flipArray(O.getItem("9mmbullet").vertices);
               if(param6 > 2)
               {
                  param6 = 2;
               }
               if(param1 == "dev")
               {
                  _loc13_ = GeneralUtils.flipArray(_loc13_);
               }
               if(param1 == "turret")
               {
                  _loc13_ = O.getItem("ammoreplica").vertices;
                  _loc11_ += 90 * Vars.toRadians;
                  _loc28_ = O.getItem("ammoreplica").colours;
               }
               _loc12_ = GameState.objects.spawnItem(_loc13_,[1],param6 * 0.025,"bullet_" + param1,-9000,-9000,_loc11_,_loc28_);
               userData(_loc12_.GetUserData()).ignored.push(param9);
               _loc29_ = 0.5;
               _loc30_ = ["smg","pis","9mm","dev","ass","min","rif","sni","turret"];
               _loc31_ = [36,56,42,56,48,64,128,256,48];
               _loc32_ = _loc30_.indexOf(param1);
               if(_loc32_ != -1)
               {
                  userData(_loc12_.GetUserData()).triggerForce = _loc31_[_loc32_] * 0.1;
               }
            }
            else
            {
               if(param1 == "muzzleflash")
               {
                  _loc33_ = Body.GetAroundPoint(new b2Vec2(param2 * Physics.scale,param3 * Physics.scale),20,20);
                  _loc34_ = 0;
                  while(_loc34_ < _loc33_.length)
                  {
                     _loc36_ = userData(_loc33_[_loc34_].GetUserData());
                     if(_loc36_)
                     {
                        if(Boolean(_loc36_.trigger) && (_loc36_.trigger is Torch || _loc36_.trigger is Lighter || _loc36_.trigger is Bomb))
                        {
                           _loc36_.triggered = true;
                        }
                        _loc36_.temperature += 50;
                     }
                     _loc34_++;
                  }
                  _loc35_ = "fire3";
                  if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                  {
                     _loc35_ = _loc15_.pfx.getParticle();
                  }
                  _loc27_ = 0;
                  while(_loc27_ < 10 / param5)
                  {
                     GameState.particles.addParticles(param2 * Physics.scale,param3 * Physics.scale,1,_loc35_,param7.x * _loc27_ / 200,param7.y * _loc27_ / 200,2,2);
                     _loc27_++;
                  }
                  Vars.objSize = _loc14_;
                  return this.addbullet("fli",param2,param3,_loc11_,param5,param6,param7,param8,param9);
               }
               if(param1 == "sho" || param1 == "fli" || param1 == "musk")
               {
                  _loc13_ = [[[0,-5],[3.55,-3.55],[5,0],[3.55,3.55],[0,5],[-3.55,3.55],[-5,0],[-3.55,-3.55]]];
                  _loc12_ = GameState.objects.spawnItem(_loc13_,[1],1,"bullet_" + param1,0,0,_loc11_,["bullet_" + param1]);
                  if(_loc21_ == 0)
                  {
                     _loc27_ = 0;
                     while(_loc27_ < Math.random() * param5 + 10)
                     {
                        _loc35_ = _loc20_[int(Math.random() * _loc20_.length)];
                        if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                        {
                           _loc35_ = _loc15_.pfx.getParticle();
                        }
                        GameState.particles.addParticles(param2 * Physics.scale,param3 * Physics.scale,1,_loc35_,param7.x * _loc27_ / 200,param7.y * _loc27_ / 200,2,2);
                        _loc27_++;
                     }
                  }
                  if(param1 == "musk")
                  {
                     userData(_loc12_.GetUserData()).triggerForce = 48;
                     param1 = "fli";
                  }
                  else
                  {
                     userData(_loc12_.GetUserData()).triggerForce = 24;
                  }
                  if(param1 == "fli")
                  {
                     _loc35_ = "smoke";
                     if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                     {
                        _loc35_ = _loc15_.pfx.getParticle();
                     }
                     _loc27_ = 0;
                     while(_loc27_ < 20 / param5)
                     {
                        GameState.particles.addParticles(param2 * Physics.scale,param3 * Physics.scale,1,_loc35_,param7.x * _loc27_ / 200,param7.y * _loc27_ / 200,2,2);
                        _loc27_++;
                     }
                  }
                  userData(_loc12_.GetUserData()).ignored.push(param9);
               }
               else if(param1 == "rifle")
               {
                  _loc13_ = [[[0,-5],[3.55,-3.55],[5,0],[3.55,3.55],[0,5],[-3.55,3.55],[-5,0],[-3.55,-3.55]]];
                  _loc12_ = GameState.objects.spawnItem(_loc13_,[1],1,"bullet_" + param1,0,0,_loc11_,["bullet_" + param1]);
                  userData(_loc12_.GetUserData()).triggerForce = 48;
               }
               else if(param1 == "ghostkiller")
               {
                  _loc13_ = [[[0,-5],[3.55,-3.55],[5,0],[3.55,3.55],[0,5],[-3.55,3.55],[-5,0],[-3.55,-3.55]]];
                  _loc12_ = GameState.objects.spawnItem(_loc13_,[1],param6,"ghostkiller",0,0,_loc11_,["CCCCCC"]);
                  userData(_loc12_.GetUserData()).graphic.alpha = 0.5;
                  userData(_loc12_.GetUserData()).trigger = new GhostBullet();
                  userData(_loc12_.GetUserData()).ghostCollide = true;
               }
               else if(param1 == "crumbler" || param1 == "crumblebullet")
               {
                  _loc13_ = [[[0,-5],[3.55,-3.55],[5,0],[3.55,3.55],[0,5],[-3.55,3.55],[-5,0],[-3.55,-3.55]]];
                  _loc12_ = GameState.objects.spawnItem(_loc13_,[1],param6,"crumblebullet",0,0,_loc11_,["999999"]);
                  userData(_loc12_.GetUserData()).trigger = new CrumbleBullet();
                  userData(_loc12_.GetUserData()).ignore = "crumblebullet";
                  userData(_loc12_.GetUserData()).ghost = true;
               }
               else if(param1 == "breach")
               {
                  _loc13_ = [[[0,-5],[3.55,-3.55],[5,0],[3.55,3.55],[0,5],[-3.55,3.55],[-5,0],[-3.55,-3.55]]];
                  _loc12_ = GameState.objects.spawnItem(_loc13_,[1],param6,"breach",0,0,_loc11_,["999999"]);
                  userData(_loc12_.GetUserData()).trigger = new CrumbleBullet();
                  userData(_loc12_.GetUserData()).ignore = "breach";
               }
               else if(param1 == "bleachBullet" || param1 == "ammoniaBullet")
               {
                  _loc37_ = Properties.objectProperties(param1);
                  _loc37_.trigger = new BleachAmmoniaBullet();
                  _loc37_.triggered = true;
                  _loc37_.triggerLock = true;
                  _loc37_.triggerState = param1 == "bleachBullet" ? 0 : 1;
                  _loc12_ = Spawn.circle(param2,param3,10,_loc37_,[1,1,1]);
               }
               else
               {
                  if(param1 == "frost")
                  {
                     _loc38_ = Body.GetAroundPoint(new b2Vec2(param2 * Physics.scale,param3 * Physics.scale),160 * _loc15_.size,160 * _loc15_.size);
                     for each(_loc39_ in _loc38_)
                     {
                        if(_loc39_ != param9)
                        {
                           Body.Freeze(_loc39_);
                           _loc40_ = BoxUtils.getEffectBMD(_loc39_);
                           if(_loc40_)
                           {
                              _loc41_ = 0;
                              while(_loc41_ < 4)
                              {
                                 _loc40_.copyPixels(R.getSprite("p_snowBig"),new Rectangle(0,0,20,16),new Point(Math.random() * _loc39_.GetUserData().width - _loc39_.GetUserData().width * 0.5,Math.random() * _loc39_.GetUserData().height - _loc39_.GetUserData().height * 0.5),null,null,true);
                                 _loc41_++;
                              }
                           }
                        }
                     }
                     Vars.objSize = _loc14_;
                     return null;
                  }
                  if(param1 == "riflegrenade")
                  {
                     _loc42_ = O.getItem("riflegrenade");
                     _loc12_ = GameState.objects.spawnItem(_loc42_.vertices,[1],_loc42_.scale,"riflegrenade",param2,param3,0,_loc42_.colours);
                     userData(_loc12_.GetUserData()).trigger = new AutoGrenade();
                     userData(_loc12_.GetUserData()).triggerOnContact = true;
                     userData(_loc12_.GetUserData()).ignore = "riflegrenade";
                     userData(_loc12_.GetUserData()).triggerForce = 500;
                     userData(_loc12_.GetUserData()).triggerRadius = 50;
                     _loc11_ += Vars.PI;
                  }
                  else if(param1 == "aut" || param1 == "m79" || param1 == "autogrenade")
                  {
                     _loc13_ = GeneralUtils.flipArray([[[-2,40],[-2,-40],[6,-48],[134,-48],[134,48],[6,48]],[[-10,-40],[-2,-40],[-2,40],[-10,40]],[[-66,24],[-66,-24],[-50,-40],[-10,-40],[-10,40],[-50,40]]]);
                     _loc12_ = GameState.objects.spawnItem(_loc13_,[1],0.05 * param6,"autogrenade",0,0,_loc11_,["5b4b30","7f7f7f","533b30"]);
                     userData(_loc12_.GetUserData()).triggerOnContact = true;
                     userData(_loc12_.GetUserData()).triggerOnCut = true;
                     userData(_loc12_.GetUserData()).trigger = new AutoGrenade();
                     if(param1 == "aut")
                     {
                        userData(_loc12_.GetUserData()).triggerForce = 2000;
                        userData(_loc12_.GetUserData()).triggerRadius = 100;
                     }
                     else
                     {
                        userData(_loc12_.GetUserData()).triggerForce = 5000;
                        userData(_loc12_.GetUserData()).triggerRadius = 250;
                     }
                     _loc35_ = "sparkle";
                     if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                     {
                        _loc35_ = _loc15_.pfx.getParticle();
                     }
                     _loc27_ = 0;
                     while(_loc27_ < 20)
                     {
                        GameState.particles.addParticles(param2 * Physics.scale,param3 * Physics.scale,1,_loc35_,param7.x * _loc27_ / 200,param7.y * _loc27_ / 200,2,2);
                        _loc27_++;
                     }
                  }
                  else if(param1 == "tank")
                  {
                     _loc13_ = GeneralUtils.flipArray([[[-2,40],[-2,-40],[6,-48],[134,-48],[134,48],[6,48]],[[-10,-40],[-2,-40],[-2,40],[-10,40]],[[-66,24],[-66,-24],[-50,-40],[-10,-40],[-10,40],[-50,40]]]);
                     _loc12_ = GameState.objects.spawnItem(_loc13_,[1],0.2 * param6,"autogrenade",0,0,_loc11_,["5b4b30","7f7f7f","533b30"]);
                     userData(_loc12_.GetUserData()).triggerOnContact = true;
                     userData(_loc12_.GetUserData()).trigger = new AutoGrenade();
                     userData(_loc12_.GetUserData()).triggerForce = 10000;
                     userData(_loc12_.GetUserData()).triggerRadius = 100;
                     userData(_loc12_.GetUserData()).triggerOnCut = true;
                     _loc35_ = "fire2";
                     if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                     {
                        _loc35_ = _loc15_.pfx.getParticle();
                     }
                     _loc27_ = 0;
                     while(_loc27_ < 20)
                     {
                        GameState.particles.addParticles(param2 * Physics.scale,param3 * Physics.scale,1,_loc35_,param7.x * _loc27_ / 200,param7.y * _loc27_ / 200,2,2);
                        _loc27_++;
                     }
                  }
                  else if(param1 == "punk")
                  {
                     _loc12_ = GameState.objects.spawnItem(O.getItem("steampunkbullet").vertices,[1],0.06,"bullet_punk",0,0,0,O.getItem("steampunkbullet").colours);
                     userData(_loc12_.GetUserData()).triggerForce = 128;
                     userData(_loc12_.GetUserData()).trigger = new Rocket("air");
                     userData(_loc12_.GetUserData()).triggered = true;
                     userData(_loc12_.GetUserData()).triggerPos = new b2Vec2(10,0);
                     _loc11_ += Vars.PI;
                  }
                  else if(param1 == "lemon")
                  {
                     _loc43_ = _loc15_.skin;
                     _loc44_ = 16173056;
                     if(Boolean(_loc43_) && _loc43_.length > 0)
                     {
                        _loc44_ = BoxUtils.getSkinColour(_loc43_,"f6c800");
                     }
                     _loc43_.push(["f6c800",_loc44_.toString(16)]);
                     _loc12_ = GameState.objects.spawnItem(O.getItem("lemon").vertices,[1],0.06,"lemon",0,0,0,O.getItem("lemon").colours,"none",_loc43_);
                     userData(_loc12_.GetUserData()).triggerForce = 128;
                     userData(_loc12_.GetUserData()).trigger = new Rocket("lemon",0);
                     userData(_loc12_.GetUserData()).triggered = true;
                     userData(_loc12_.GetUserData()).disintegrator = true;
                     userData(_loc12_.GetUserData()).disintegrating = true;
                     userData(_loc12_.GetUserData()).triggerPos = new b2Vec2(10,0);
                     _loc11_ += Vars.PI;
                  }
                  else if(param1 == "futuristic")
                  {
                     _loc12_ = GameState.objects.spawnItem(O.getItem("steampunkbullet").vertices,[1],0.06,"bullet_punk",0,0,0,["49D9E9","49D9E9","49D9E9","49D9E9","282828","49D9E9"]);
                     userData(_loc12_.GetUserData()).triggerDuration = 20;
                     userData(_loc12_.GetUserData()).triggerForce = 10000;
                     userData(_loc12_.GetUserData()).zerograv = true;
                     userData(_loc12_.GetUserData()).trigger = new DelayedRocket("darkorb");
                     userData(_loc12_.GetUserData()).triggered = true;
                     userData(_loc12_.GetUserData()).triggerPos = new b2Vec2(6,0);
                     userData(_loc12_.GetUserData()).ignore = "futuristicpistol";
                     _loc11_ += Vars.PI;
                  }
                  else if(param1 == "fat")
                  {
                     _loc12_ = GameState.objects.spawnItem(GeneralUtils.flipArray(O.getItem("mininuke").vertices),[1],0.1,"mininuke",0,0,0,O.getItem("mininuke").colours);
                     userData(_loc12_.GetUserData()).trigger = new MiniNuke();
                     userData(_loc12_.GetUserData()).triggerDuration = 0;
                     userData(_loc12_.GetUserData()).triggerContact = 100;
                     userData(_loc12_.GetUserData()).ignore = "fatman";
                     if(_loc15_.flipped)
                     {
                        _loc11_ -= Vars.PI / 2;
                     }
                     else
                     {
                        _loc11_ += Vars.PI / 2;
                     }
                     _loc35_ = "sparkle";
                     if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                     {
                        _loc35_ = _loc15_.pfx.getParticle();
                     }
                     _loc27_ = 0;
                     while(_loc27_ < 10)
                     {
                        GameState.particles.addParticles(param2 * Physics.scale,param3 * Physics.scale,1,_loc35_,param7.x * _loc27_ / 30,param7.y * _loc27_ / 30,1,1);
                        _loc27_++;
                     }
                  }
                  else if(param1 == "fla" || param1 == "flamer")
                  {
                     _loc12_ = GameState.objects.spawnObject("fireflame",param2,param3,_loc11_,false,true);
                     _loc11_ += Math.PI;
                  }
                  else if(param1 == "har" || param1 == "harpoonbullet")
                  {
                     _loc12_ = GameState.objects.spawnItem(O.getItem("harpoonbullet").vertices,[1.2],0.14,"harpoonbullet",0,0,0,O.getItem("harpoonbullet").colours);
                     _loc11_ += Math.PI;
                  }
                  else if(param1 == "nai" || param1 == "nail")
                  {
                     _loc13_ = GeneralUtils.flipArray([[[-16.7,-1.45],[-16.7,1.55],[-20,0]],[[-16.7,-1.45],[18.05,-1.45],[18.05,1.55],[-16.7,1.55]],[[18.05,-1.45],[20,-3.5],[20,3.5],[18.05,1.55]]]);
                     _loc12_ = GameState.objects.spawnItem(_loc13_,[1],1,"nail",param2,param3,_loc11_,[Properties.shapeStickSharp("nailhead"),"nailend","nailend"]);
                  }
                  else if(param1 == "cluster")
                  {
                     _loc43_ = _loc15_.skin;
                     _loc44_ = 3363632;
                     if(Boolean(_loc43_) && _loc43_.length > 0)
                     {
                        _loc44_ = BoxUtils.getSkinColour(_loc43_,"335330");
                     }
                     _loc43_.push(["505050",_loc44_.toString(16)]);
                     _loc42_ = O.getItem("3pointstar");
                     _loc12_ = GameState.objects.spawnItem(_loc42_.vertices,[5],0.012 * param6,_loc42_.name,param2,param3,0,_loc42_.colours,"none",_loc43_);
                     userData(_loc12_.GetUserData()).sharp = true;
                     userData(_loc12_.GetUserData()).ignore = _loc42_.name;
                     userData(_loc12_.GetUserData()).trigger = new TempProjectile(Math.random() * 20,3);
                     userData(_loc12_.GetUserData()).triggerOnContact = true;
                  }
                  else if(param1 == "cactusspike")
                  {
                     _loc43_ = _loc15_.skin;
                     _loc44_ = 1783296;
                     if(Boolean(_loc43_) && _loc43_.length > 0)
                     {
                        _loc44_ = BoxUtils.getSkinColour(_loc43_,"1B3600");
                     }
                     _loc43_.push(["1b3600",_loc44_.toString(16)]);
                     _loc42_ = O.getItem("cactusspike");
                     _loc45_ = _loc42_.vertices;
                     _loc12_ = GameState.objects.spawnItem(_loc45_,[1],0.05 * param6,_loc42_.name,param2,param3,0,_loc42_.colours,"none",_loc43_);
                     userData(_loc12_.GetUserData()).sharp = true;
                     userData(_loc12_.GetUserData()).ignore = _loc42_.name;
                     userData(_loc12_.GetUserData()).trigger = new TempProjectile(Math.random() * 60 + 60,3);
                     userData(_loc12_.GetUserData()).triggerOnContact = true;
                  }
                  else if(param1 == "scorpionspike")
                  {
                     _loc43_ = _loc15_.skin;
                     _loc44_ = 3418918;
                     if(Boolean(_loc43_) && _loc43_.length > 0)
                     {
                        _loc44_ = BoxUtils.getSkinColour(_loc43_,"342B26");
                     }
                     _loc43_.push(["1b3600",_loc44_.toString(16)]);
                     _loc42_ = O.getItem("cactusspike");
                     _loc12_ = GameState.objects.spawnItem(_loc42_.vertices,[1],0.05 * param6,_loc42_.name,param2,param3,0,_loc42_.colours,"none",_loc43_);
                     userData(_loc12_.GetUserData()).sharp = true;
                     userData(_loc12_.GetUserData()).ignore = _loc42_.name;
                     userData(_loc12_.GetUserData()).trigger = new ScorpionStinger();
                  }
                  else if(param1 == "pellet")
                  {
                     _loc12_ = GameState.objects.spawnItem(O.getItem("circle").vertices,[5],0.25,"beepod",param2 * Physics.scale,param3 * Physics.scale,0,["None"]);
                     userData(_loc12_.GetUserData()).trigger = new Bee();
                  }
                  else if(param1 == "bb")
                  {
                     _loc12_ = GameState.objects.spawnItem(O.getItem("circle").vertices,[0.01],0.25,"beepod",param2 * Physics.scale,param3 * Physics.scale,0,["None"]);
                     userData(_loc12_.GetUserData()).trigger = new Bee();
                     userData(_loc12_.GetUserData()).killOnContact = true;
                  }
                  else if(param1 == "worm")
                  {
                     _loc12_ = GameState.objects.spawnItem(O.getItem("circle").vertices,[0.01],0.25,"beepod",param2 * Physics.scale,param3 * Physics.scale,0,["None"]);
                     _loc46_ = userData(_loc12_.GetUserData());
                     _loc46_.trigger = new WormStaff();
                     _loc46_.triggered = true;
                     _loc46_.sticky = true;
                     _loc46_.triggerPos = new b2Vec2();
                     _loc46_.graphic.alpha = 0;
                     _loc46_.triggerRadius = 40;
                     _loc46_.triggerState = 1;
                     _loc46_.saveable = false;
                  }
                  else if(param1 == "bee")
                  {
                     _loc37_ = Properties.objTemp("beepod");
                     _loc37_.trigger = new Bee();
                     _loc37_.triggered = true;
                     _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                  }
                  else if(param1 == "bubble")
                  {
                     _loc37_ = Properties.objTemp("bubble");
                     _loc37_.trigger = new Bubble();
                     _loc37_.ignore = "bubble";
                     _loc37_.triggerCollide = 1;
                     _loc37_.triggered = true;
                     _loc37_.zerograv = true;
                     _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                  }
                  else if(param1 == "glue")
                  {
                     _loc37_ = Properties.objBurn("glue");
                     _loc37_.saveable = false;
                     _loc37_.trigger = new Glue();
                     _loc37_.triggered = true;
                     _loc12_ = Spawn.circle(param2,param3,0.1,_loc37_,[1,1,1]);
                  }
                  else if(param1 == "gravity")
                  {
                     _loc37_ = Properties.objectProperties("gravity");
                     _loc37_.saveable = false;
                     _loc37_.trigger = new GravityBullet();
                     _loc37_.triggerDuration = 120;
                     _loc37_.triggered = true;
                     _loc12_ = Spawn.circle(param2,param3,0.1,_loc37_,[1,1,1]);
                  }
                  else if(param1 == "levity")
                  {
                     _loc37_ = Properties.objectProperties("levity");
                     _loc37_.saveable = false;
                     _loc37_.trigger = new GravityBullet();
                     _loc37_.triggerDuration = 120;
                     _loc37_.triggered = true;
                     _loc12_ = Spawn.circle(param2,param3,0.1,_loc37_,[1,1,1]);
                  }
                  else if(param1 == "stasis")
                  {
                     _loc37_ = Properties.objectProperties("stasis");
                     _loc37_.saveable = false;
                     _loc37_.trigger = new StasisBullet();
                     _loc37_.triggered = true;
                     _loc12_ = Spawn.circle(param2,param3,0.1,_loc37_,[1,1,1]);
                  }
                  else if(param1 == "powder")
                  {
                     _loc37_ = Properties.objectProperties("powder");
                     _loc37_.saveable = false;
                     _loc37_.trigger = new GenericBullet("poof");
                     _loc37_.triggered = true;
                     _loc12_ = Spawn.circle(param2,param3,0.1,_loc37_,[1,1,1]);
                  }
                  else if(param1 == "gas")
                  {
                     _loc37_ = Properties.objBurn("gasoline");
                     _loc37_.saveable = false;
                     _loc37_.trigger = new Gasoline();
                     _loc37_.triggered = true;
                     _loc37_.temperature = 30;
                     _loc37_.ignition = 40;
                     _loc47_ = Body.GetAroundPoint(new b2Vec2(param2,param3),20,20,false);
                     for each(_loc48_ in _loc47_)
                     {
                        if(userData(_loc48_.GetUserData()).burning)
                        {
                           _loc37_.ignition = _loc37_.temperature;
                        }
                     }
                     _loc12_ = Spawn.circle(param2,param3,0.1,_loc37_,[1,100,0.5]);
                  }
                  else if(param1 == "ghost")
                  {
                     _loc37_ = Properties.objectProperties("ghost");
                     _loc37_.saveable = false;
                     _loc37_.trigger = new GhostingBullet();
                     _loc37_.triggered = true;
                     _loc12_ = Spawn.circle(param2,param3,0.1,_loc37_,[1,1,1]);
                  }
                  else if(param1 == "gib")
                  {
                     _loc37_ = Properties.objectProperties("gib");
                     _loc37_.saveable = false;
                     _loc37_.trigger = new GibBullet();
                     _loc37_.triggered = true;
                     _loc12_ = Spawn.circle(param2,param3,0.1,_loc37_,[1,1,1]);
                  }
                  else
                  {
                     if(param1 == "confetti")
                     {
                        _loc49_ = ["rope","warning","slime","bat","ghost","wizardhat","balloon","spider","stoneskull","football","metalring","icebubble","carving","mine","shuriken","sword","cube","waves","eye","goop","spatter","praise"];
                        _loc50_ = 0;
                        while(_loc50_ < 20)
                        {
                           _loc35_ = _loc49_[int(_loc49_.length * Math.random()) >> 0];
                           if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                           {
                              _loc35_ = _loc15_.pfx.getParticle();
                           }
                           _loc51_ = Math.random() * 0.5;
                           _loc52_ = GameState.particles.addParticles(Physics.scale * param2 + Math.random() * 10 - 5,Physics.scale * param3 + Math.random() * 10 - 5,1,_loc35_,_loc51_ * param7.x,_loc51_ * param7.y,2,2);
                           for each(_loc53_ in _loc52_)
                           {
                              _loc53_.health = 1000;
                              _loc53_.fade = Math.random() * Math.random() * 190 + 10;
                              _loc53_.wander = 1;
                           }
                           _loc50_++;
                        }
                        Vars.objSize = _loc14_;
                        return null;
                     }
                     if(param1 == "ricochet")
                     {
                        _loc54_ = Vars.objRestitution;
                        Vars.objRestitution = 2;
                        _loc43_ = _loc15_.skin;
                        _loc44_ = 10714627;
                        if(Boolean(_loc43_) && _loc43_.length > 0)
                        {
                           _loc44_ = BoxUtils.getSkinColour(_loc43_,"A37E03");
                        }
                        _loc43_.push(["505050",_loc44_.toString(16)]);
                        _loc42_ = O.getItem("hexadecagon");
                        _loc12_ = GameState.objects.spawnItem(_loc42_.vertices,[2],0.2,"ricochet",param2,param3,0,_loc42_.colours,"none",_loc43_);
                        Vars.objRestitution = _loc54_;
                        userData(_loc12_.GetUserData()).saveable = false;
                     }
                     else if(param1 == "sass" || param1 == "sausage")
                     {
                        _loc37_ = Properties.objectProperties("sausage");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new SassageBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                        _loc27_ = 0;
                        while(_loc27_ < 10)
                        {
                           _loc55_ = 0.01 + 0.1 * Math.random();
                           _loc56_ = Math.floor(Math.random() * 200) + 55;
                           GameState.particles.addSimpleParticles(param2 * Physics.scale,param3 * Physics.scale,1,uint(255 << 24 | _loc56_ << 16),param7.x * _loc55_,param7.y * _loc55_,2,2);
                           _loc27_++;
                        }
                     }
                     else if(param1 == "steam")
                     {
                        _loc37_ = Properties.objectProperties("sausage");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new SteamBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                        userData(_loc12_.GetUserData()).zerograv = true;
                        userData(_loc12_.GetUserData()).triggerRadius = 10;
                        userData(_loc12_.GetUserData()).triggerForce = 100;
                     }
                     else if(param1 == "bling")
                     {
                        _loc37_ = Properties.objectProperties("bling");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new BlingBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                        userData(_loc12_.GetUserData()).ignore = "bling";
                     }
                     else if(param1 == "crabber")
                     {
                        _loc37_ = Properties.objectProperties(param1);
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new CrabBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                     }
                     else if(param1 == "arcanitybullet")
                     {
                        _loc37_ = Properties.objectProperties(param1);
                        _loc12_ = GameState.objects.spawnObject(param1,param2,param3,_loc75_,_loc15_.flipped,true);
                        userData(_loc12_.GetUserData()).trigger = new Arcanity();
                        userData(_loc12_.GetUserData()).sharp = true;
                        userData(_loc12_.GetUserData()).triggerForce = _loc15_.triggerForce;
                        userData(_loc12_.GetUserData()).triggerRadius = _loc15_.triggerRadius;
                        userData(_loc12_.GetUserData()).triggered = true;
                     }
                     else if(param1 == "grasper")
                     {
                        _loc37_ = Properties.objectProperties(param1);
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new GraspBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                     }
                     else if(param1 == "bane")
                     {
                        _loc37_ = Properties.objectProperties("banebullet");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new BaneBullet();
                        userData(_loc12_.GetUserData()).ignore = "banebullet";
                        userData(_loc12_.GetUserData()).triggered = true;
                     }
                     else if(param1 == "droner")
                     {
                        _loc37_ = Properties.objectProperties("droner");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new DronerBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                     }
                     else if(param1 == "adrenaline")
                     {
                        _loc37_ = Properties.objectProperties("sausage");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new AdrenalineBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                        userData(_loc12_.GetUserData()).triggerForce = 50;
                     }
                     else if(param1 == "flr" || param1 == "flare")
                     {
                        _loc37_ = Properties.objectProperties("flare");
                        _loc37_.ignore = "flare";
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new FlareBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                        _loc27_ = 0;
                        while(_loc27_ < 10)
                        {
                           _loc55_ = 0.01 + 0.1 * Math.random();
                           _loc56_ = Math.floor(Math.random() * 200) + 55;
                           GameState.particles.addSimpleParticles(param2 * Physics.scale,param3 * Physics.scale,1,uint(255 << 24 | _loc56_ << 16),param7.x * _loc55_,param7.y * _loc55_,2,2);
                           _loc27_++;
                        }
                     }
                     else if(param1 == "flm")
                     {
                        _loc37_ = Properties.objectProperties("flare");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new FlameBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                     }
                     else if(param1 == "frostfire")
                     {
                        _loc37_ = Properties.objectProperties("frostfire");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new FrostfireBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                     }
                     else if(param1 == "deepfry")
                     {
                        _loc37_ = Properties.objectProperties("fry");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new DeepfryBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                     }
                     else if(param1 == "poi" || param1 == "poisonbullet")
                     {
                        _loc37_ = Properties.objectProperties("poisonbullet");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new PoisonBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                        userData(_loc12_.GetUserData()).killOnContact = true;
                        userData(_loc12_.GetUserData()).triggerRadius = 30;
                     }
                     else if(param1 == "tox" || param1 == "toxinbullet")
                     {
                        _loc37_ = Properties.objectProperties("toxinbullet");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new ToxinBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                        userData(_loc12_.GetUserData()).killOnContact = true;
                        userData(_loc12_.GetUserData()).triggerRadius = 30;
                        userData(_loc12_.GetUserData()).resistPoison = true;
                     }
                     else if(param1 == "aci" || param1 == "aciddrop")
                     {
                        _loc37_ = Properties.objectProperties("acidbullet");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new AcidBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                     }
                     else if(param1 == "cursor")
                     {
                        _loc37_ = Properties.objectProperties("cursorbullet");
                        _loc12_ = Spawn.circle(param2,param3,6,_loc37_,[10,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new CursorBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                     }
                     else if(param1 == "crit")
                     {
                        _loc37_ = Properties.objectProperties("critbullet");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new GenericBullet("blood");
                        userData(_loc12_.GetUserData()).triggered = true;
                        userData(_loc12_.GetUserData()).critting = true;
                        userData(_loc12_.GetUserData()).killOnContact = true;
                     }
                     else if(param1 == "crush")
                     {
                        _loc37_ = Properties.objectProperties("crushbullet");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new GravityBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                     }
                     else if(param1 == "petrify")
                     {
                        _loc37_ = Properties.objectProperties("petrifybullet");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new PetrifyBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                     }
                     else if(param1 == "web")
                     {
                        _loc37_ = Properties.objectProperties("webbullet");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new WebBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                     }
                     else if(param1 == "trans" || param1 == "transmute")
                     {
                        _loc37_ = Properties.objectProperties("transbullet");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new GenericBullet("sparkle");
                        userData(_loc12_.GetUserData()).triggered = true;
                        userData(_loc12_.GetUserData()).transmuting = true;
                        userData(_loc12_.GetUserData()).killOnContact = true;
                     }
                     else if(param1 == "acid" || param1 == "acidpotion")
                     {
                        _loc12_ = GameState.objects.spawnObject("acidpotion",param2,param3,_loc11_,false,true);
                        userData(_loc12_.GetUserData()).triggerOnContact = true;
                     }
                     else if(param1 == "drone")
                     {
                        if(!(_loc15_.trigger is Gun))
                        {
                           Vars.objSize = _loc14_;
                           return null;
                        }
                        _loc57_ = [DroneClean,DroneExplosive,DroneLaser,DroneHammer,DroneRocket,DroneToxic,DronePin,DronePaint];
                        _loc12_ = GameState.objects.spawnObject("dronetemp",param2,param3,_loc11_,false,true);
                        DroneLauncher(Gun(_loc15_.trigger).firearm).drones.push(_loc12_);
                        _loc58_ = userData(_loc12_.GetUserData());
                        _loc59_ = getDefinitionByName(getQualifiedClassName(_loc57_[_loc57_.length * Math.random() >> 0])) as Class;
                        _loc58_.trigger = new _loc59_();
                        _loc58_.triggerRadius = 200;
                        _loc58_.triggerDuration = 50;
                        _loc58_.triggerOnContact = true;
                     }
                     else if(param1 == "teleport")
                     {
                        _loc12_ = GameState.objects.spawnObject("telegrenade",param2,param3,_loc11_,false,true);
                     }
                     else if(param1 == "error")
                     {
                        _loc12_ = GameState.objects.spawnObject("genericcube",param2,param3,_loc11_,false,true);
                        userData(_loc12_.GetUserData()).killOnContact = true;
                     }
                     else if(param1 == "smoke")
                     {
                        _loc12_ = GameState.objects.spawnObject("smokebomb",param2,param3,_loc11_,false,true);
                        userData(_loc12_.GetUserData()).triggerOnContact = true;
                        userData(_loc12_.GetUserData()).triggerRadius = 150;
                     }
                     else if(param1 == "cookie")
                     {
                        _loc60_ = GameState.objects.spawnScale;
                        GameState.objects.spawnScale = Math.random() + 0.5;
                        _loc12_ = GameState.objects.spawnObject("cookie",param2,param3,_loc11_,false,true);
                        GameState.objects.spawnScale = _loc60_;
                        userData(_loc12_.GetUserData()).trigger = new MilkCookie();
                     }
                     else if(param1 == "cookier")
                     {
                        _loc60_ = GameState.objects.spawnScale;
                        GameState.objects.spawnScale = Math.random() + 0.5;
                        _loc12_ = GameState.objects.delayedSpawnObject("cookie",param2,param3,_loc11_,false,true);
                        GameState.objects.spawnScale = _loc60_;
                        userData(_loc12_.GetUserData()).trigger = new CookieBullet();
                        userData(_loc12_.GetUserData()).triggerOnContact = true;
                        userData(_loc12_.GetUserData()).ignore = "cookie";
                     }
                     else if(param1 == "spi" || param1 == "explosivedisc")
                     {
                        _loc43_ = _loc15_.skin;
                        _loc44_ = 16724736;
                        if(Boolean(_loc43_) && _loc43_.length > 0)
                        {
                           _loc44_ = BoxUtils.getSkinColour(_loc43_,"e92d15");
                        }
                        _loc13_ = [[[-10,4.05],[-10,-4.05],[10,-4.05],[10,4.05]]];
                        _loc12_ = GameState.objects.spawnItem(_loc13_,[1],param6,Properties.objectProperties("disc"),param2,param3,_loc11_,[_loc44_.toString(16)]);
                        userData(_loc12_.GetUserData()).trigger = new Disc();
                        userData(_loc12_.GetUserData()).triggered = true;
                        userData(_loc12_.GetUserData()).zerograv = true;
                        userData(_loc12_.GetUserData()).unbreakable = true;
                        userData(_loc12_.GetUserData()).triggerRadius = 50;
                        if(_loc43_)
                        {
                           userData(_loc12_.GetUserData()).skin = _loc43_.slice();
                        }
                        param7.x += param9.GetLinearVelocity().x;
                        param7.y += param9.GetLinearVelocity().y;
                     }
                     else if(param1 == "dra" || param1 == "drainbullet")
                     {
                        _loc37_ = Properties.objectProperties("drainbullet");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new DrainBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                        userData(_loc12_.GetUserData()).killOnContact = true;
                        userData(_loc12_.GetUserData()).triggerRadius = 30;
                     }
                     else if(param1 == "voi" || param1 == "voidbullet")
                     {
                        _loc37_ = Properties.objectProperties("voidbullet");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,3]);
                        userData(_loc12_.GetUserData()).trigger = new VoidBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                        userData(_loc12_.GetUserData()).zerograv = true;
                        userData(_loc12_.GetUserData()).ghost = true;
                        userData(_loc12_.GetUserData()).triggerRadius = 50;
                        userData(_loc12_.GetUserData()).triggerForce = 100;
                        userData(_loc12_.GetUserData()).triggerDuration = 180;
                     }
                     else if(param1 == "sna" || param1 == "snarebullet")
                     {
                        _loc37_ = Properties.objectProperties("snarebullet");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new SnareBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                        userData(_loc12_.GetUserData()).triggerLock = true;
                        userData(_loc12_.GetUserData()).killOnContact = true;
                     }
                     else if(param1 == "implosive" || param1 == "implosivebullet")
                     {
                        _loc37_ = Properties.objectProperties("implosivebullet");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new ImplosiveBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                        userData(_loc12_.GetUserData()).triggerLock = true;
                        userData(_loc12_.GetUserData()).triggerRadius = 100;
                        userData(_loc12_.GetUserData()).triggerForce = 100;
                     }
                     else if(param1 == "banish" || param1 == "banishbullet")
                     {
                        _loc37_ = Properties.objectProperties("banishbullet");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new BanishBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                        userData(_loc12_.GetUserData()).triggerLock = true;
                     }
                     else if(param1 == "protect")
                     {
                        _loc37_ = Properties.objectProperties("protectbullet");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new ProtectBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                        userData(_loc12_.GetUserData()).triggerLock = true;
                     }
                     else if(param1 == "sandstone")
                     {
                        _loc37_ = Properties.objectProperties("sandbullet");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new SandBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                        userData(_loc12_.GetUserData()).triggerLock = true;
                     }
                     else if(param1 == "lava")
                     {
                        _loc37_ = Properties.objectProperties("lavabullet");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new LavaBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                        userData(_loc12_.GetUserData()).triggerLock = true;
                     }
                     else if(param1 == "glitch")
                     {
                        _loc37_ = Properties.objectProperties("glitchbullet");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new GlitchBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                        userData(_loc12_.GetUserData()).triggerLock = true;
                     }
                     else if(param1 == "glass")
                     {
                        _loc37_ = Properties.objectProperties("glassbullet");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new GlassBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                        userData(_loc12_.GetUserData()).triggerLock = true;
                     }
                     else if(param1 == "bleed")
                     {
                        _loc37_ = Properties.objectProperties("bleedbullet");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new BleedBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                        userData(_loc12_.GetUserData()).triggerLock = true;
                     }
                     else if(param1 == "prop" || param1 == "propertybullet")
                     {
                        _loc37_ = Properties.objectProperties("propertybullet");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new PropBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                        userData(_loc12_.GetUserData()).triggerLock = true;
                     }
                     else if(param1 == "bla")
                     {
                        _loc37_ = Properties.objectProperties("blastbullet");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new BlastBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                        userData(_loc12_.GetUserData()).triggerRadius = 20;
                        userData(_loc12_.GetUserData()).triggerForce = 1000;
                     }
                     else if(param1 == "blast")
                     {
                        _loc37_ = Properties.objectProperties("blastbullet");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new BlastBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                        userData(_loc12_.GetUserData()).triggerRadius = 20;
                        userData(_loc12_.GetUserData()).triggerForce = 1000;
                     }
                     else if(param1 == "dea" || param1 == "death")
                     {
                        _loc37_ = Properties.objectProperties("deathbullet");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new DeathBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                     }
                     else if(param1 == "rend" || param1 == "sli")
                     {
                        _loc37_ = Properties.objectProperties("rendbullet");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new RendBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                     }
                     else if(param1 == "lig" || param1 == "light")
                     {
                        _loc37_ = Properties.objectProperties("lightbullet");
                        _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                        userData(_loc12_.GetUserData()).trigger = new LightBullet();
                        userData(_loc12_.GetUserData()).triggered = true;
                     }
                     else
                     {
                        if(param1.substr(0,3) == "zap")
                        {
                           _loc61_ = param2 * Physics.scale;
                           _loc62_ = param3 * Physics.scale;
                           _loc63_ = new b2Vec2(_loc61_,_loc62_);
                           _loc64_ = new b2Vec2(_loc61_ + param7.x * Physics.scale,_loc62_ + param7.y * Physics.scale);
                           _loc65_ = GameState.cutter.CustomRaycast(_loc63_,800,_loc64_,false);
                           _loc66_ = _loc65_[0];
                           if(_loc66_)
                           {
                              _loc67_ = userData(_loc66_.GetUserData());
                              _loc67_.trigger = new Electrified();
                              _loc67_.triggerDuration = 30 + Math.random() * 60;
                              _loc67_.triggered = true;
                              if(_loc67_.alive)
                              {
                                 Body.Damage(_loc66_,30);
                              }
                           }
                           if(_loc65_[1])
                           {
                              _loc68_ = _loc65_[1].Copy();
                              _loc68_.Multiply(Physics.scale);
                              _loc69_ = (_loc68_.y - _loc63_.y) / (_loc68_.x - _loc63_.x);
                              _loc70_ = parseInt(param1.substr(3));
                              _loc71_ = 0;
                              while(_loc71_ < 20)
                              {
                                 _loc72_ = _loc63_.x + _loc71_ / 20 * (_loc68_.x - _loc63_.x);
                                 _loc73_ = _loc63_.y + _loc69_ * (_loc72_ - _loc63_.x);
                                 if(_loc70_ < 2)
                                 {
                                    if(Math.random() > 0.9)
                                    {
                                       this.addbullet("zap" + String(_loc70_ + 1),_loc72_ / Physics.scale + Math.random() * 2,_loc73_ / Physics.scale + Math.random() * 2,0,1,1,new b2Vec2(_loc68_.x - _loc63_.x + Math.random() * 500 - 250,_loc68_.y - _loc63_.y + Math.random() * 500 - 250),10,param9);
                                       this.addbullet("zap" + String(_loc70_ + 1),_loc72_ / Physics.scale + Math.random() * 2,_loc73_ / Physics.scale + Math.random() * 2,0,1,1,new b2Vec2(_loc68_.x - _loc63_.x + Math.random() * 500 - 250,_loc68_.y - _loc63_.y + Math.random() * 500 - 250),10,param9);
                                       if(_loc70_ != 1)
                                       {
                                          break;
                                       }
                                    }
                                 }
                                 _loc35_ = "shock";
                                 if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                                 {
                                    _loc35_ = _loc15_.pfx.getParticle();
                                 }
                                 GameState.particles.addParticles(_loc72_,_loc73_,1,_loc35_,(-_loc63_.x + _loc72_) * 0.05,(-_loc63_.y + _loc73_) * 0.05,2,2);
                                 _loc71_++;
                              }
                           }
                           Vars.objSize = _loc14_;
                           return null;
                        }
                        if(param1 == "win" || param1 == "windbullet")
                        {
                           _loc37_ = Properties.objectProperties(param1);
                           _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                           userData(_loc12_.GetUserData()).trigger = new Repel();
                           userData(_loc12_.GetUserData()).triggered = true;
                           userData(_loc12_.GetUserData()).triggerForce = 1000;
                           userData(_loc12_.GetUserData()).triggerRadius = 50;
                           userData(_loc12_.GetUserData()).pfx = new PFXOverwrite(_loc12_);
                           userData(_loc12_.GetUserData()).pfx.attachParticles(1,"air");
                           userData(_loc12_.GetUserData()).resistGust = true;
                           userData(_loc12_.GetUserData()).killOnContact = true;
                           userData(_loc12_.GetUserData()).ignore = param1;
                        }
                        else if(param1 == "tas" || param1 == "taserbullet")
                        {
                           _loc37_ = Properties.objectProperties("taserRound");
                           _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                           userData(_loc12_.GetUserData()).trigger = new TaserBullet();
                           userData(_loc12_.GetUserData()).triggered = true;
                        }
                        else if(param1 == "knockoutbullet")
                        {
                           _loc37_ = Properties.objectProperties(param1);
                           _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                           userData(_loc12_.GetUserData()).trigger = new IncapacitateBullet();
                           userData(_loc12_.GetUserData()).triggered = true;
                        }
                        else if(param1 == "bss" || param1 == "bass")
                        {
                           _loc37_ = Properties.objectProperties("bass");
                           _loc37_.zerograv = true;
                           _loc37_.trigger = new GenericBullet("note");
                           _loc37_.triggered = true;
                           _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,0.8]);
                        }
                        else if(param1 == "back")
                        {
                           _loc13_ = [[[10,0],[1.5,2.5],[-10,2.5],[-10,-2.5],[1.5,-2.5]]];
                           _loc12_ = GameState.objects.spawnItem(_loc13_,[50 / (10 / param6)],param6,"bullet_" + param1,0,0,_loc11_,["bullet_" + param1]);
                        }
                        else if(param1 == "car" || param1 == "carbine")
                        {
                           _loc37_ = Properties.objectProperties("carbineRound");
                           _loc37_.zerograv = true;
                           _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                           userData(_loc12_.GetUserData()).trigger = new CarbineBullet();
                           userData(_loc12_.GetUserData()).triggered = true;
                           userData(_loc12_.GetUserData()).resistArc = true;
                        }
                        else if(param1 == "carBig" || param1 == "arc")
                        {
                           _loc12_ = GameState.objects.spawnObject("arcgrenade",param2,param3,_loc11_,false,true);
                           userData(_loc12_.GetUserData()).triggerOnContact = true;
                           userData(_loc12_.GetUserData()).triggerRadius = _loc15_.triggerRadius;
                           userData(_loc12_.GetUserData()).triggerDuration = _loc15_.triggerDuration;
                           userData(_loc12_.GetUserData()).triggerForce = _loc15_.triggerForce;
                        }
                        else if(param1 == "twi" || param1 == "twisterbullet")
                        {
                           _loc37_ = Properties.objectProperties("smgRound");
                           _loc37_.zerograv = true;
                           _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                           userData(_loc12_.GetUserData()).trigger = new TwisterBullet();
                           userData(_loc12_.GetUserData()).triggered = true;
                        }
                        else if(param1 == "ketchup")
                        {
                           _loc74_ = "c5710b";
                           if(_loc15_.skin.length > 0)
                           {
                              _loc74_ = BoxUtils.getSkinColour(_loc15_.skin,"c5710b").toString(16);
                           }
                           while(_loc74_.length < 6)
                           {
                              _loc74_ = "0" + _loc74_;
                           }
                           _loc37_ = Properties.objTemp(_loc74_);
                           _loc37_.trigger = new Paint();
                           _loc37_.triggered = true;
                           _loc37_.killOnContact = true;
                           _loc12_ = Spawn.circle(param2,param3,2 * _loc15_.size,_loc37_,[1,1,1]);
                           _loc37_.size = _loc15_.size * 5;
                        }
                        else if(param1 == "splt" || param1 == "splatter")
                        {
                           _loc74_ = "c5710b";
                           if(_loc15_.skin.length > 0)
                           {
                              _loc74_ = BoxUtils.getSkinColour(_loc15_.skin,"c5710b").toString(16);
                           }
                           while(_loc74_.length < 6)
                           {
                              _loc74_ = "0" + _loc74_;
                           }
                           _loc37_ = Properties.objTemp(_loc74_);
                           _loc37_.trigger = new Paint();
                           _loc37_.triggered = true;
                           _loc37_.killOnContact = true;
                           _loc12_ = Spawn.circle(param2,param3,2 * _loc15_.size,_loc37_,[1,1,1]);
                           _loc37_.size = _loc15_.size * 5;
                        }
                        else if(param1 == "pnt" || param1 == "paintdrop")
                        {
                           _loc75_ = 50 + Math.random() * 200 >> 0;
                           _loc76_ = 50 + Math.random() * 200 >> 0;
                           _loc77_ = 50 + Math.random() * 200 >> 0;
                           _loc74_ = _loc75_.toString(16) + _loc76_.toString(16) + _loc77_.toString(16);
                           _loc37_ = Properties.objTemp(_loc74_);
                           _loc37_.trigger = new Paint();
                           _loc37_.triggered = true;
                           _loc12_ = Spawn.circle(param2,param3,2 * _loc15_.size,_loc37_,[1,1,1]);
                           _loc37_.size = _loc15_.size;
                           _loc27_ = 0;
                           while(_loc27_ < 10)
                           {
                              _loc55_ = 0.05 * Math.random();
                              _loc78_ = _loc75_ + Math.random() * 30 - 15;
                              _loc79_ = _loc76_ + Math.random() * 30 - 15;
                              _loc80_ = _loc77_ + Math.random() * 30 - 15;
                              if(_loc78_ > 255)
                              {
                                 _loc78_ = 255;
                              }
                              if(_loc79_ > 255)
                              {
                                 _loc79_ = 255;
                              }
                              if(_loc80_ > 255)
                              {
                                 _loc80_ = 255;
                              }
                              if(_loc78_ < 0)
                              {
                                 _loc78_ = 0;
                              }
                              if(_loc79_ < 0)
                              {
                                 _loc79_ = 0;
                              }
                              if(_loc80_ < 0)
                              {
                                 _loc80_ = 0;
                              }
                              GameState.particles.addSimpleParticles(param2 * Physics.scale,param3 * Physics.scale,1,uint(255 << 24 | _loc78_ << 16 | _loc79_ << 8 | _loc80_),param7.x * _loc55_,param7.y * _loc55_,1,1);
                              _loc27_++;
                           }
                        }
                        else if(param1 == "paintExplosion")
                        {
                           _loc37_ = Properties.objectProperties(param1);
                           _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                           userData(_loc12_.GetUserData()).triggerForce = 500;
                           userData(_loc12_.GetUserData()).triggered = true;
                           userData(_loc12_.GetUserData()).trigger = new PaintGrenade();
                        }
                        else if(param1 == "monochrome")
                        {
                           _loc81_ = GeneralUtils.pointOnCircle(param2 * Physics.scale,param3 * Physics.scale,Math.random() * _loc15_.triggerRadius * _loc15_.size,Math.random() * 360);
                           param2 = _loc81_.x / Physics.scale;
                           param3 = _loc81_.y / Physics.scale;
                           _loc75_ = 50 + Math.random() * 200 >> 0;
                           _loc74_ = _loc75_.toString(16) + _loc75_.toString(16) + _loc75_.toString(16);
                           _loc37_ = Properties.objectProperties(_loc74_);
                           _loc37_.trigger = new MonochromeBullet();
                           _loc37_.triggered = true;
                           _loc37_.ignore = "monochrome";
                           _loc37_.ignored.push(param9);
                           _loc37_.triggerForce = _loc15_.triggerForce;
                           _loc12_ = Spawn.circle(param2,param3,2 * _loc15_.size,_loc37_,[1,1,1]);
                           _loc37_.size = _loc15_.size;
                        }
                        else if(param1 == "dec" || param1 == "decoration")
                        {
                           _loc37_ = Properties.objTemp("decoration");
                           _loc37_.zerograv = true;
                           _loc37_.trigger = new GenericBullet("decoration");
                           _loc37_.triggered = true;
                           _loc37_.killOnContact = true;
                           _loc12_ = Spawn.circle(param2,param3,2,_loc37_,[1,1,1]);
                           _loc37_.size = _loc15_.size;
                        }
                        else if(param1 == "decorated")
                        {
                           _loc37_ = Properties.objectProperties("decorated");
                           _loc37_.zerograv = true;
                           _loc37_.trigger = new DecoratingBullet();
                           _loc37_.triggered = true;
                           _loc12_ = Spawn.circle(param2,param3,2,_loc37_,[1,1,1]);
                           _loc37_.size = _loc15_.size;
                        }
                        else if(param1 == "med" || param1 == "heals")
                        {
                           _loc37_ = Properties.objTemp("heals");
                           _loc37_.zerograv = true;
                           _loc37_.trigger = new HealBullet();
                           _loc37_.triggered = true;
                           _loc37_.triggerState = -1;
                           _loc37_.triggerRadius = 30;
                           _loc37_.killOnContact = true;
                           _loc37_.triggerDuration = 0;
                           _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                           _loc37_.size = _loc15_.size;
                        }
                        else if(param1 == "tra" || param1 == "triggerbullet")
                        {
                           _loc37_ = Properties.objTemp("tracer");
                           _loc37_.zerograv = true;
                           _loc37_.trigger = new TracerBullet();
                           _loc37_.triggered = true;
                           _loc37_.killOnContact = true;
                           _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                           _loc37_.size = _loc15_.size;
                        }
                        else if(param1 == "can")
                        {
                           _loc13_ = [[[0,-5],[3.55,-3.55],[5,0],[3.55,3.55],[0,5],[-3.55,3.55],[-5,0],[-3.55,-3.55]]];
                           _loc12_ = GameState.objects.spawnItem(_loc13_,[10],param6,"cannonball",0,0,_loc11_,["333333"]);
                           userData(_loc12_.GetUserData()).trigger = new TempProjectile(30);
                           userData(_loc12_.GetUserData()).triggerOnContact = true;
                        }
                        else if(param1 == "shake")
                        {
                           _loc13_ = [[[0,-5],[3.55,-3.55],[5,0],[3.55,3.55],[0,5],[-3.55,3.55],[-5,0],[-3.55,-3.55]]];
                           _loc12_ = GameState.objects.spawnItem(_loc13_,[10],param6 * 0.5,"woop",0,0,_loc11_,["FF0000"]);
                           userData(_loc12_.GetUserData()).trigger = new SuddenlyGrenade("fire3");
                           userData(_loc12_.GetUserData()).triggerForce = -_loc15_.triggerForce;
                           userData(_loc12_.GetUserData()).triggered = true;
                           userData(_loc12_.GetUserData()).triggerPos = new b2Vec2(0,0);
                           userData(_loc12_.GetUserData()).sticky = true;
                           userData(_loc12_.GetUserData()).unbreakable = true;
                        }
                        else if(param1 == "shakePower")
                        {
                           _loc13_ = [[[0,-5],[3.55,-3.55],[5,0],[3.55,3.55],[0,5],[-3.55,3.55],[-5,0],[-3.55,-3.55]]];
                           _loc12_ = GameState.objects.spawnItem(_loc13_,[10],param6 * 0.5,"woop",0,0,_loc11_,["B7001C"]);
                           userData(_loc12_.GetUserData()).trigger = new SuddenlyNapalm("fire3",60);
                           userData(_loc12_.GetUserData()).triggerForce = -250;
                           userData(_loc12_.GetUserData()).triggerRadius = 20;
                           userData(_loc12_.GetUserData()).triggered = true;
                           userData(_loc12_.GetUserData()).triggerPos = new b2Vec2(0,0);
                           userData(_loc12_.GetUserData()).sticky = true;
                           userData(_loc12_.GetUserData()).unbreakable = true;
                        }
                        else if(param1 == "pot" || param1 == "potato")
                        {
                           _loc12_ = GameState.objects.spawnItem(O.getItem("potato").vertices,[1],Math.random() * 0.1 + 0.1,"potato",0,0,0,O.getItem("potato").colours);
                        }
                        else if(param1 == "shrimp")
                        {
                           _loc12_ = GameState.objects.spawnItem(GeneralUtils.flipArray(O.getItem("shrimpbullet").vertices),[0.1],Math.random() * 0.02 + 0.02,"shrimpbullet",0,0,0,O.getItem("shrimpbullet").colours);
                           userData(_loc12_.GetUserData()).trigger = new Shrimp();
                           userData(_loc12_.GetUserData()).triggered = true;
                           userData(_loc12_.GetUserData()).ignore = "shrimpbullet";
                        }
                        else if(param1 == "pot2" || param1 == "heavypotato")
                        {
                           _loc12_ = GameState.objects.spawnItem(O.getItem("potato").vertices,[5],Math.random() * 0.2 + 0.1,"heavypotato",0,0,0,O.getItem("potato").colours);
                           userData(_loc12_.GetUserData()).trigger = new TempProjectile(Math.random() * 60 + 60);
                           userData(_loc12_.GetUserData()).triggered = true;
                        }
                        else if(param1 == "boulder")
                        {
                           _loc82_ = ["614e0e"];
                           if(Boolean(_loc15_.skin) && _loc15_.skin.length > 0)
                           {
                              _loc82_[0] = _loc15_.skin[0][1];
                           }
                           _loc12_ = GameState.objects.spawnItem(O.getItem("potato").vertices,[1],Math.random() * 0.1 + 0.1,"boulder",0,0,0,_loc82_);
                           userData(_loc12_.GetUserData()).trigger = new TempProjectile(Math.random() * 30 + 30);
                           userData(_loc12_.GetUserData()).ignore = "boulder";
                           userData(_loc12_.GetUserData()).triggerOnContact = true;
                           userData(_loc12_.GetUserData()).saveable = false;
                        }
                        else if(param1 == "coreboulder")
                        {
                           _loc82_ = [_loc15_.triggerColour];
                           if(Boolean(_loc15_.skin) && _loc15_.skin.length > 0)
                           {
                              _loc82_[0] = BoxUtils.getSkinColour(_loc15_.skin,_loc82_[0]);
                           }
                           _loc12_ = GameState.objects.spawnItem(O.getItem("potato").vertices,[1],_loc15_.size * (Math.random() * 0.1 + 0.1),"boulder",0,0,0,_loc82_);
                           userData(_loc12_.GetUserData()).trigger = new DisintegrateOnNextHit("fire3",param6 * (Math.random() * 10 + 10),1);
                           userData(_loc12_.GetUserData()).ignore = "boulder";
                           userData(_loc12_.GetUserData()).triggerOnContact = true;
                           userData(_loc12_.GetUserData()).saveable = false;
                        }
                        else if(param1 == "quake")
                        {
                           _loc82_ = ["6A5B4F"];
                           _loc12_ = GameState.objects.spawnItem(O.getItem("potato").vertices,[10],Math.random() * 0.1 + 0.1,"boulder",0,0,0,_loc82_);
                           userData(_loc12_.GetUserData()).trigger = new DisintegrateOnNextHit("boulder",Math.random() * 10 + 10,1);
                           userData(_loc12_.GetUserData()).ignore = "boulder";
                           userData(_loc12_.GetUserData()).triggerOnContact = true;
                           userData(_loc12_.GetUserData()).saveable = false;
                        }
                        else if(param1 == "riot")
                        {
                           _loc12_ = GameState.objects.spawnItem(GeneralUtils.flipArray(O.getItem("steampunkbullet").vertices),[4],0.07,"riot",0,0,_loc11_,["282828","282828","282828","282828","333333","282828"]);
                           userData(_loc12_.GetUserData()).trigger = new TempProjectile(20);
                           userData(_loc12_.GetUserData()).triggerOnContact = true;
                           userData(_loc12_.GetUserData()).saveable = false;
                        }
                        else if(param1 == "dar" || param1 == "blowdart")
                        {
                           _loc12_ = GameState.objects.spawnItem(GeneralUtils.flipArray(O.getItem("blowdart").vertices),[1,1,1,1,10],O.getItem("blowdart").scale,"blowdart",0,0,0,O.getItem("blowdart").colours);
                        }
                        else if(param1 == "trap" || param1 == "trapdart")
                        {
                           _loc12_ = GameState.objects.spawnItem(GeneralUtils.flipArray(O.getItem("trapdart").vertices),[1],O.getItem("trapdart").scale,"trapdart",0,0,0,O.getItem("trapdart").colours);
                           userData(_loc12_.GetUserData()).trigger = new TempProjectile(30,4);
                           userData(_loc12_.GetUserData()).triggerOnContact = true;
                           userData(_loc12_.GetUserData()).saveable = false;
                        }
                        else if(param1 == "tranq")
                        {
                           _loc12_ = GameState.objects.spawnItem(GeneralUtils.flipArray(O.getItem("tranqdart").vertices),[1,1,1,1,10],O.getItem("tranqdart").scale,"tranqdart",0,0,0,O.getItem("tranqdart").colours);
                        }
                        else if(param1 == "euth" || param1 == "deathdart")
                        {
                           _loc12_ = GameState.objects.spawnItem(GeneralUtils.flipArray(O.getItem("tranqdart").vertices),[1,1,1,1,10],O.getItem("tranqdart").scale,"deathdart",0,0,0,O.getItem("tranqdart").colours);
                        }
                        else if(param1 == "saw")
                        {
                           _loc12_ = GameState.objects.spawnItem(O.getItem("sawgunblade").vertices,[0.2],O.getItem("sawgunblade").scale,"sawgunblade",0,0,0,O.getItem("sawgunblade").colours);
                           userData(_loc12_.GetUserData()).trigger = new TempProjectile(10);
                           userData(_loc12_.GetUserData()).triggerOnContact = true;
                           userData(_loc12_.GetUserData()).ignore = "sawgun";
                           userData(_loc12_.GetUserData()).saveable = false;
                        }
                        else if(param1 == "ballista")
                        {
                           _loc12_ = GameState.objects.spawnItem(O.getItem("ballistaprojectile").vertices,[1],O.getItem("ballistaprojectile").scale,"ballistaspear",0,0,0,O.getItem("ballistaprojectile").colours);
                           if(_loc15_.flipped)
                           {
                              _loc11_ += Math.PI * 1.5;
                           }
                           else
                           {
                              _loc11_ += Math.PI * 0.5;
                           }
                        }
                        else if(param1 == "plu" || param1 == "plunger")
                        {
                           _loc12_ = GameState.objects.spawnItem(O.getItem("plunger").vertices,[1],O.getItem("plunger").scale,"plunger",0,0,0,O.getItem("plunger").colours);
                           if(_loc15_.flipped)
                           {
                              _loc11_ -= Math.PI * 1.5;
                           }
                           else
                           {
                              _loc11_ -= Math.PI * 0.5;
                           }
                        }
                        else if(param1 == "ice")
                        {
                           _loc37_ = Properties.objectProperties("snow");
                           _loc12_ = Spawn.circle(param2 * Physics.scale,param3 * Physics.scale,5,Properties.objectProperties("snow"),[1,1,1]);
                           userData(_loc12_.GetUserData()).trigger = new SnowBullet();
                           userData(_loc12_.GetUserData()).triggered = true;
                           userData(_loc12_.GetUserData()).sticky = true;
                           userData(_loc12_.GetUserData()).triggerRadius = 50;
                        }
                        else if(param1 == "rpg")
                        {
                           _loc12_ = GameState.objects.spawnObject("rpgrocket",param2,param3,_loc75_,!_loc15_.flipped,true);
                           userData(_loc12_.GetUserData()).triggerOnContact = true;
                           userData(_loc12_.GetUserData()).triggerOnCut = true;
                        }
                        else if(param1 == "wristrocket")
                        {
                           _loc83_ = new Vector.<Array>();
                           _loc83_.push(["3e4130","424242"]);
                           _loc83_.push(["5e6059","292C28"]);
                           _loc83_.push(["3b401f","292C28"]);
                           if(Boolean(_loc15_.skin) && _loc15_.skin.length > 0)
                           {
                              BoxUtils.setSkinColour(_loc83_,"3b401f",BoxUtils.getSkinColour(_loc15_.skin,"424242").toString(16));
                              BoxUtils.setSkinColour(_loc83_,"3e4130",BoxUtils.getSkinColour(_loc15_.skin,"292c28").toString(16));
                              BoxUtils.setSkinColour(_loc83_,"5e6059",BoxUtils.getSkinColour(_loc15_.skin,"292C28").toString(16));
                           }
                           _loc84_ = this.spawnSkin.slice();
                           this.spawnSkin = _loc83_;
                           _loc12_ = GameState.objects.spawnObject("rpgrocket",param2,param3,_loc75_,!_loc15_.flipped,true,_loc83_);
                           this.spawnSkin = _loc84_;
                           userData(_loc12_.GetUserData()).triggerOnContact = true;
                           userData(_loc12_.GetUserData()).triggerOnCut = true;
                        }
                        else if(param1 == "panzer")
                        {
                           _loc12_ = GameState.objects.spawnObject("panzerfaustrocket",param2,param3,_loc75_,!_loc15_.flipped,true);
                           userData(_loc12_.GetUserData()).triggerOnContact = true;
                           userData(_loc12_.GetUserData()).triggerOnCut = true;
                        }
                        else if(param1 == "aprocket")
                        {
                           _loc12_ = GameState.objects.spawnObject("aprocket",param2,param3,_loc75_,!_loc15_.flipped,true);
                           userData(_loc12_.GetUserData()).triggerOnContact = true;
                           userData(_loc12_.GetUserData()).triggerOnCut = true;
                           userData(_loc12_.GetUserData()).triggered = true;
                        }
                        else if(param1 == "bomb")
                        {
                           _loc12_ = GameState.objects.spawnObject("bomb",param2,param3,_loc75_,!_loc15_.flipped,true);
                           userData(_loc12_.GetUserData()).triggerOnContact = true;
                           userData(_loc12_.GetUserData()).sticky = true;
                           userData(_loc12_.GetUserData()).triggerDuration = _loc15_.triggerDuration;
                           userData(_loc12_.GetUserData()).triggerRadius = _loc15_.triggerRadius;
                           userData(_loc12_.GetUserData()).triggerForce = _loc15_.triggerForce * 10;
                        }
                        else if(param1 == "airbomb")
                        {
                           _loc12_ = GameState.objects.spawnObject("airbomb",param2,param3,_loc75_,!_loc15_.flipped,true);
                           userData(_loc12_.GetUserData()).triggerContact = 0;
                           userData(_loc12_.GetUserData()).triggerOnContact = true;
                           userData(_loc12_.GetUserData()).triggerRadius = 600 * param6;
                           userData(_loc12_.GetUserData()).triggerForce = 1000;
                        }
                        else if(param1 == "tinymissile")
                        {
                           _loc12_ = GameState.objects.spawnObject("tinymissile",param2,param3,_loc75_,!_loc15_.flipped,true);
                           userData(_loc12_.GetUserData()).triggerContact = 0;
                           userData(_loc12_.GetUserData()).triggerOnContact = true;
                           userData(_loc12_.GetUserData()).triggerRadius = 150 * param6;
                           userData(_loc12_.GetUserData()).triggerForce = 200;
                        }
                        else if(param1 == "firework")
                        {
                           if(_loc15_.flipped)
                           {
                              _loc11_ -= Math.PI * 0.5;
                           }
                           else
                           {
                              _loc11_ -= Math.PI * 1.5;
                           }
                           _loc12_ = GameState.objects.spawnObject("firework",param2,param3,_loc75_,!_loc15_.flipped,true);
                           userData(_loc12_.GetUserData()).triggered = true;
                           userData(_loc12_.GetUserData()).triggerForce = _loc15_.triggerForce;
                           userData(_loc12_.GetUserData()).triggerDuration = _loc15_.triggerDuration;
                        }
                        else if(param1 == "triz" || param1 == "trirocket")
                        {
                           _loc12_ = GameState.objects.spawnObject("thermobaricrocket",param2,param3,_loc75_,!_loc15_.flipped,true);
                           userData(_loc12_.GetUserData()).triggered = true;
                        }
                        else if(param1 == "com" || param1 == "ripper")
                        {
                           _loc12_ = GameState.objects.spawnItem(O.getItem("combatpellet").vertices,[0.1],param6,"bullet_com",0,0,_loc11_,O.getItem("combatpellet").colours);
                           userData(_loc12_.GetUserData()).triggerForce = 12;
                           userData(_loc12_.GetUserData()).trigger = new AimArrow();
                           userData(_loc12_.GetUserData()).triggerRadius = 600;
                           userData(_loc12_.GetUserData()).triggerDuration = 0;
                           userData(_loc12_.GetUserData()).triggered = true;
                           userData(_loc12_.GetUserData()).connected = _loc15_.connected.slice();
                        }
                        else if(param1 == "aimarrow")
                        {
                           _loc82_ = O.getItem("aimarrow").colours;
                           if(_loc15_.skin.length > 0)
                           {
                              _loc85_ = 0;
                              while(_loc85_ < _loc82_.length)
                              {
                                 _loc82_[_loc85_] = _loc15_.skin[_loc85_][1];
                                 _loc85_++;
                              }
                           }
                           _loc12_ = GameState.objects.spawnItem(GeneralUtils.flipArray(O.getItem("aimarrow").vertices),[2],0.11,"aimarrow",0,0,0,_loc82_);
                           userData(_loc12_.GetUserData()).soft = true;
                           userData(_loc12_.GetUserData()).trigger = new AimArrow();
                           userData(_loc12_.GetUserData()).triggerRadius = 300;
                           userData(_loc12_.GetUserData()).triggerDuration = 6;
                           userData(_loc12_.GetUserData()).triggered = true;
                           userData(_loc12_.GetUserData()).connected = _loc15_.connected.slice();
                        }
                        else if(param1 == "maimarr")
                        {
                           _loc82_ = O.getItem("maimarrow").colours;
                           if(_loc15_.skin.length > 0)
                           {
                              _loc85_ = 0;
                              while(_loc85_ < _loc15_.skin.length)
                              {
                                 _loc82_[_loc85_] = _loc15_.skin[_loc85_][1];
                                 _loc85_++;
                              }
                           }
                           _loc12_ = GameState.objects.spawnItem(GeneralUtils.flipArray(O.getItem("maimarrow").vertices),[2],0.11,"maimarrow",0,0,0,_loc82_);
                           userData(_loc12_.GetUserData()).soft = true;
                           userData(_loc12_.GetUserData()).trigger = new MaimArrow();
                           userData(_loc12_.GetUserData()).connected = _loc15_.connected.slice();
                           userData(_loc12_.GetUserData()).connected.push(param9);
                           userData(_loc12_.GetUserData()).triggerForce = 1000;
                           userData(_loc12_.GetUserData()).triggered = true;
                        }
                        else if(param1 == "targetarrow")
                        {
                           _loc12_ = GameState.objects.spawnItem(GeneralUtils.flipArray(O.getItem("arrowproj").vertices),[1],0.04,"targetarrowproj",0,0,0,O.getItem("arrowproj").colours);
                           userData(_loc12_.GetUserData()).soft = true;
                           userData(_loc12_.GetUserData()).trigger = new TargetArrow();
                        }
                        else if(param1 == "targeticicle")
                        {
                           _loc12_ = GameState.objects.spawnItem(GeneralUtils.rotateArray(O.getItem("targetball").vertices,90),[1],0.12,"targetball",0,0,0,O.getItem("targetball").colours);
                           userData(_loc12_.GetUserData()).soft = true;
                           userData(_loc12_.GetUserData()).sticky = true;
                           userData(_loc12_.GetUserData()).trigger = new TargetIcicle();
                        }
                        else if(param1 == "arr" || param1 == "arrow")
                        {
                           _loc12_ = GameState.objects.spawnItem(GeneralUtils.flipArray(O.getItem("arrowproj").vertices),[0.5],0.04,"arrow",0,0,0,O.getItem("arrowproj").colours);
                           userData(_loc12_.GetUserData()).soft = true;
                        }
                        else if(param1 == "xarr" || param1 == "crossbow")
                        {
                           _loc12_ = GameState.objects.spawnItem(GeneralUtils.flipArray(O.getItem("xarrowproj").vertices),[0.75],0.04,"xarrow",0,0,0,O.getItem("xarrowproj").colours);
                           userData(_loc12_.GetUserData()).soft = true;
                           userData(_loc12_.GetUserData()).ignore = "crossbow";
                        }
                        else if(param1 == "steelarrow")
                        {
                           _loc86_ = ["recurveblade","seaxblade","sharpfingerblade","neckblade","bowieblade","karambitblade","kukriblade"];
                           _loc87_ = _loc86_[int(_loc86_.length * Math.random())];
                           _loc88_ = O.getItem(_loc87_);
                           _loc12_ = GameState.objects.spawnItem(_loc88_.vertices,[1.5],_loc88_.scale,_loc87_,0,0,0,_loc88_.colours);
                           userData(_loc12_.GetUserData()).sharp = true;
                           userData(_loc12_.GetUserData()).ignore = "steeldenture";
                           userData(_loc12_.GetUserData()).trigger = new TemporaryRocket("poof",120);
                           userData(_loc12_.GetUserData()).triggerForce = -500;
                           userData(_loc12_.GetUserData()).triggered = true;
                           userData(_loc12_.GetUserData()).triggerPos = new b2Vec2(11,0);
                           _loc12_.SetAngularVelocity((_loc15_.flipped ? -1 : 1) * (Math.random() * -1000 - 500));
                        }
                        else if(param1 == "elvenarr" || param1 == "elvenarrow")
                        {
                           _loc12_ = GameState.objects.spawnItem(GeneralUtils.flipArray(O.getItem("elvenarrow").vertices),[1],0.04,"elvenarrow",0,0,0,O.getItem("elvenarrow").colours,"none",_loc15_.skin);
                           userData(_loc12_.GetUserData()).soft = true;
                           userData(_loc12_.GetUserData()).trigger = new TemporaryRocket("poof",120);
                           userData(_loc12_.GetUserData()).triggerForce = -500;
                           userData(_loc12_.GetUserData()).triggered = true;
                           userData(_loc12_.GetUserData()).ignore = "elvenarr";
                           userData(_loc12_.GetUserData()).triggerPos = new b2Vec2(11,0);
                        }
                        else if(param1 == "soularr")
                        {
                           _loc89_ = int(O.getItem("soulstormarrow").alphas.length);
                           _loc90_ = 0;
                           while(_loc90_ < _loc89_)
                           {
                              O.getItem("soulstormarrow").alphas[_loc90_] = _loc90_ / _loc89_;
                              _loc90_++;
                           }
                           _loc12_ = GameState.objects.spawnItem(O.getItem("soulstormarrow").vertices,[1],0.1,"soulstormarrow",0,0,0,O.getItem("soulstormarrow").colours,"none",_loc15_.skin);
                           userData(_loc12_.GetUserData()).trigger = new SuddenlyAim();
                           userData(_loc12_.GetUserData()).triggered = true;
                           userData(_loc12_.GetUserData()).ignore = _loc15_.name;
                           userData(_loc12_.GetUserData()).connected.push(param9);
                        }
                        else if(param1 == "xxarr" || param1 == "steamarrow")
                        {
                           _loc12_ = GameState.objects.spawnItem(GeneralUtils.flipArray(O.getItem("steamarrow").vertices),[1],0.11,"steamarrow",0,0,0,O.getItem("steamarrow").colours);
                           userData(_loc12_.GetUserData()).soft = true;
                        }
                        else
                        {
                           if(param1 == "guillotine")
                           {
                              _loc91_ = Properties.forceObjFixed;
                              Properties.forceObjFixed = 1;
                              _loc12_ = GameState.objects.spawnItem(O.getItem("guillotineblade").vertices,[10],0.18 * _loc15_.size,"guillotineblade",0,0,0,O.getItem("guillotineblade").colours);
                              Properties.forceObjFixed = _loc91_;
                              Vars.objSize = _loc14_;
                              userData(_loc12_.GetUserData()).ignore = "guillotine";
                              userData(_loc12_.GetUserData()).trigger = new TempProjectile(16,0);
                              userData(_loc12_.GetUserData()).triggered = true;
                              userData(_loc12_.GetUserData()).saveable = false;
                              userData(_loc12_.GetUserData()).layer = 0;
                              GraphicUtils.addGraphicToLayer(userData(_loc12_.GetUserData()));
                              _loc92_ = new b2Vec2(0,-4000 * _loc12_.GetMass() * (1 / TimeLord.timerSpeed));
                              _loc92_ = BoxUtils.rotateVec(_loc92_,_loc11_);
                              _loc12_.SetXForm(new b2Vec2(param2,param3),_loc11_ + Vars.PI);
                              _loc12_.ApplyForce(_loc92_,_loc12_.GetWorldCenter());
                              _loc93_ = _loc12_.GetPosition().Copy();
                              _loc94_ = Joints.Distance("rope",param9,_loc12_,new b2Vec2(param2 - 1,param3),new b2Vec2(_loc93_.x - 1,_loc93_.y),0.4,1);
                              _loc94_ = Joints.Distance("rope",param9,_loc12_,new b2Vec2(param2 + 1,param3),new b2Vec2(_loc93_.x + 1,_loc93_.y),0.4,1);
                              Vars.objSize = _loc14_;
                              return null;
                           }
                           if(param1 == "larr" || param1 == "longarrow")
                           {
                              _loc12_ = GameState.objects.spawnItem(GeneralUtils.flipArray(O.getItem("longarrowproj").vertices),[1.8],0.04,"longarrowproj",0,0,0,O.getItem("longarrowproj").colours);
                              userData(_loc12_.GetUserData()).soft = true;
                           }
                           else if(param1 == "candycane")
                           {
                              _loc11_ += 90 * Vars.toRadians * (_loc15_.flipped ? -1 : 1);
                              _loc12_ = GameState.objects.spawnItem(GeneralUtils.flipArray(O.getItem("candycane").vertices),[1.8],0.1,"candycane",0,0,0,O.getItem("candycane").colours,"none",_loc15_.skin);
                              userData(_loc12_.GetUserData()).soft = true;
                              userData(_loc12_.GetUserData()).trigger = new TemporaryRocket("candycane",20,1);
                              userData(_loc12_.GetUserData()).triggerForce = -1000;
                              userData(_loc12_.GetUserData()).triggered = true;
                              userData(_loc12_.GetUserData()).triggerPos = new b2Vec2(0,10);
                           }
                           else if(param1 == "narr" || param1 == "nestarrow")
                           {
                              _loc12_ = GameState.objects.spawnItem(GeneralUtils.flipArray(O.getItem("nestofbeesarrow").vertices),[2],0.01,"nestofbeesarrow",0,0,0,O.getItem("nestofbeesarrow").colours);
                              userData(_loc12_.GetUserData()).soft = true;
                              _loc22_ = userData(_loc12_.GetUserData());
                              userData(_loc12_.GetUserData()).trigger = new TemporaryRocket("fire3");
                              userData(_loc12_.GetUserData()).triggerForce = -1000;
                              userData(_loc12_.GetUserData()).triggered = true;
                              userData(_loc12_.GetUserData()).ignore = "nestofbees";
                              userData(_loc12_.GetUserData()).triggerPos = new b2Vec2(11,0);
                           }
                           else if(param1 == "concuss")
                           {
                              _loc37_ = Properties.objectProperties("water");
                              _loc12_ = Spawn.circle(param2,param3,2,_loc37_,[1,1,0]);
                              _loc37_.name = "7F6A00";
                              _loc37_.trigger = new ConcussSpray();
                              _loc37_.triggered = true;
                              _loc37_.killOnContact = true;
                           }
                           else if(param1 == "wat" || param1 == "waterdrop")
                           {
                              _loc37_ = Properties.objectProperties("water");
                              _loc12_ = Spawn.circle(param2,param3,2,_loc37_,[1,1,0]);
                              _loc37_.size = _loc15_.size;
                              _loc37_.trigger = new Water();
                              _loc37_.ignore = "water";
                              _loc37_.triggered = true;
                           }
                           else if(param1 == "coffee")
                           {
                              _loc37_ = Properties.objectProperties("water");
                              _loc12_ = Spawn.circle(param2,param3,2,_loc37_,[1,1,0]);
                              _loc37_.size = _loc15_.size;
                              _loc37_.triggerForce = _loc15_.triggerForce;
                              _loc37_.trigger = new Coffee();
                              _loc37_.ignore = "water";
                              _loc37_.triggered = true;
                              _loc37_.triggerForce = 100;
                           }
                           else if(param1 == "ext" || param1 == "extinguish")
                           {
                              _loc37_ = Properties.objectProperties("extinguish");
                              _loc12_ = Spawn.circle(param2,param3,2,_loc37_,[1,1,0]);
                              _loc37_.size = _loc15_.size;
                              _loc37_.trigger = new Water();
                              Water(_loc37_.trigger).setParticle("gas");
                              _loc37_.ignore = "water";
                              _loc37_.triggered = true;
                           }
                           else if(param1 == "tidal")
                           {
                              _loc37_ = Properties.objectProperties("water");
                              _loc12_ = Spawn.circle(param2,param3,20,_loc37_,[1,1,0]);
                              _loc37_.size = _loc15_.size;
                              _loc37_.trigger = new Water();
                              _loc37_.ignore = "water";
                              _loc37_.triggered = true;
                           }
                           else if(param1 == "gungun")
                           {
                              _loc12_ = GameState.objects.spawnObject("gungun",param2 * Physics.scale,param3 * Physics.scale,0,_loc15_.flipped,true);
                              if(!_loc12_)
                              {
                                 Vars.objSize = _loc14_;
                                 return null;
                              }
                              userData(_loc12_.GetUserData()).triggered = true;
                              userData(_loc12_.GetUserData()).ghost = true;
                              userData(_loc12_.GetUserData()).killOnContact = true;
                              userData(_loc12_.GetUserData()).ignored.push(param9);
                              _loc12_.SetXForm(new b2Vec2(param2,param3),_loc11_ + Math.PI);
                              Gun(userData(_loc12_.GetUserData()).trigger).firearm.forceReload();
                              Gun(userData(_loc12_.GetUserData()).trigger).firearm.shoot();
                           }
                           else if(param1 == "gun" || param1 == "randomGun")
                           {
                              _loc95_ = R.firearms;
                              _loc96_ = _loc95_[Math.random() * _loc95_.length >> 0];
                              _loc12_ = GameState.objects.spawnObject(_loc96_,param2 * Physics.scale,param3 * Physics.scale,0,_loc15_.flipped);
                              if(!_loc12_)
                              {
                                 Vars.objSize = _loc14_;
                                 return null;
                              }
                              userData(_loc12_.GetUserData()).triggered = true;
                              userData(_loc12_.GetUserData()).killOnContact = true;
                              userData(_loc12_.GetUserData()).ignored.push(param9);
                              _loc35_ = "forcefield";
                              if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                              {
                                 _loc35_ = _loc15_.pfx.getParticle();
                              }
                              _loc27_ = 0;
                              while(_loc27_ < 20)
                              {
                                 _loc55_ = 0.15 * Math.random() + 0.1;
                                 GameState.particles.addParticles(param2 * Physics.scale,param3 * Physics.scale,1,_loc35_,_loc55_ * param7.x,_loc55_ * param7.y);
                                 _loc27_++;
                              }
                           }
                           else if(param1 == "exp" || param1 == "randomExplosive")
                           {
                              _loc97_ = ["aerosol","airbomb","bomb","bombdisc","C4","cluster","decoygrenade","dynamite","empgrenade","barrel","flash","jetfuel","gascan","grenade","methane","mininuke","pipebomb","propanetank","rpgrocket","nuclearbomb","smokebomb","smokegrenade","stickgrenade","stinggrenade","thermobaricrocket","beegrenade","teargrenade","cryo","blackholegrenade","soapgrenade","arcgrenade","implosive","lasergrenade","pulsegrenade","powdergrenade","rendgrenade","repelgrenade","electrogrenade","supernovabomb","voidgrenade","electronbomb","neurogrenade","hydrofluoricbomb","incendiary","molotov","toxicgrenade","thermite","phosphorusbomb","contactgrenade","betty","camomine","claymoremine","inflatabledecoy","betty2","mine","steammine","shockwavemine"];
                              _loc98_ = _loc97_[Math.random() * _loc97_.length >> 0];
                              _loc12_ = GameState.objects.spawnObject(_loc98_,param2 * Physics.scale,param3 * Physics.scale,0,_loc15_.flipped);
                              if(!_loc12_)
                              {
                                 Vars.objSize = _loc14_;
                                 return null;
                              }
                              userData(_loc12_.GetUserData()).triggerOnContact = true;
                              userData(_loc12_.GetUserData()).ignored.push(param9);
                              _loc15_.connected.push(_loc12_);
                              userData(_loc12_.GetUserData()).connected.push(param9);
                              _loc35_ = "forcefield";
                              if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                              {
                                 _loc35_ = _loc15_.pfx.getParticle();
                              }
                              _loc27_ = 0;
                              while(_loc27_ < 20)
                              {
                                 _loc55_ = 0.15 * Math.random() + 0.1;
                                 GameState.particles.addParticles(param2 * Physics.scale,param3 * Physics.scale,1,_loc35_,_loc55_ * param7.x,_loc55_ * param7.y);
                                 _loc27_++;
                              }
                           }
                           else if(param1 == "swo" || param1 == "randomSword")
                           {
                              _loc97_ = ["arcticwolf","brimstone","calmtide","chaos","fallensoldier","hydrasword","gambolshroud","eyelander","chronomancer","blackout","zweihander","broadsword","buster","claymore","coldironkiller","fleshripper","combustor","crystalsword","cyberslasher","psychodragon","africansword","zabimaru","needlershard","timekeeper","tyrfing","banditsblade","brainblade","crosssword","falx","handmadesword","hyk","jesterblade","jetgoblet","slicer","spectrus","bipodknife","metasword","teutonicblade","vinterskog","cutlass","bladedancer","desertblade","dragonsword","elucidator","elvensword","falcata","falchion","fierysword","flicker","gladius","glasssword","glory","heavensdoor","hooksword","humidity","katana","khopesh","lambent","longsword","masamune","mastersword","mist","mistblade","muramasa","nightsedge","swordofdaedric","orcishsword","rapier","reaver","scarlet","shortsword","spartansword","spur","swordhilt","sword","3dmg","valiantrapier"];
                              _loc98_ = _loc97_[Math.random() * _loc97_.length >> 0];
                              _loc12_ = GameState.objects.spawnObject(_loc98_,param2 * Physics.scale,param3 * Physics.scale,0,_loc15_.flipped);
                              if(!_loc12_)
                              {
                                 Vars.objSize = _loc14_;
                                 return null;
                              }
                              _loc22_ = userData(_loc12_.GetUserData());
                              _loc22_.killOnContact = true;
                              _loc22_.saveable = false;
                              _loc22_.ignored.push(param9);
                              _loc15_.connected.push(_loc12_);
                              userData(_loc12_.GetUserData()).connected.push(param9);
                              _loc35_ = "forcefield";
                              if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                              {
                                 _loc35_ = _loc15_.pfx.getParticle();
                              }
                              _loc27_ = 0;
                              while(_loc27_ < 20)
                              {
                                 _loc55_ = 0.15 * Math.random() + 0.1;
                                 GameState.particles.addParticles(param2 * Physics.scale,param3 * Physics.scale,1,_loc35_,_loc55_ * param7.x,_loc55_ * param7.y);
                                 _loc27_++;
                              }
                           }
                           else if(param1 == "food")
                           {
                              _loc97_ = ["apple","bananapeel","banana","coconut","amanita","pear","potato","pricklypear","squash","vine","watermelonslice","gingerbreadman","hamshank","pickledcucumbers","saucebottle","sodabottle","arseniclacedpie","cake","marshmallowstick","toast","cheesy","pizza","orange","chilipepper","juicecan","icecream","snowball","popsicle","lollipop","carrot","egg","sausage","pomegranate"];
                              _loc98_ = _loc97_[Math.random() * _loc97_.length >> 0];
                              _loc12_ = GameState.objects.spawnObject(_loc98_,param2 * Physics.scale,param3 * Physics.scale,0,_loc15_.flipped);
                              if(!_loc12_)
                              {
                                 Vars.objSize = _loc14_;
                                 return null;
                              }
                              _loc22_ = userData(_loc12_.GetUserData());
                              _loc22_.triggerLock = false;
                              _loc22_.trigger = new TempProjectile(Math.random() * 45 + 45);
                              _loc22_.saveable = false;
                              _loc22_.triggerOnContact = true;
                              _loc22_.ignored.push(param9);
                              _loc11_ += 90 * Vars.toRadians * (_loc15_.flipped ? -1 : 1);
                              _loc35_ = "forcefield";
                              if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                              {
                                 _loc35_ = _loc15_.pfx.getParticle();
                              }
                              _loc27_ = 0;
                              while(_loc27_ < 20)
                              {
                                 _loc55_ = 0.15 * Math.random() + 0.1;
                                 GameState.particles.addParticles(param2 * Physics.scale,param3 * Physics.scale,1,_loc35_,_loc55_ * param7.x,_loc55_ * param7.y);
                                 _loc27_++;
                              }
                           }
                           else if(param1 == "furniture")
                           {
                              _loc97_ = ["antiquechair","antiquetable","bathtub","bed","bookshelf","boxingbag","cauldron","chair","chest","coffeetable","coffin","column","chair2","couch","countertop","dinerstool","displaycase","door","foldingchair","fridge","globe","grandfatherclock","hiatusstatue","ironcage","ironingboard","monitor","officechair","romanpedastal","foldingtable","pottedplant","radiator","shelf","tablething","speaker","statue","stepladder","stool","storagecabinet","tablelamp","table","tv","toilet","woodentrapdoor","trash","glassvase","vaultgate","wardrobe","woodensupport"];
                              _loc98_ = _loc97_[Math.random() * _loc97_.length >> 0];
                              _loc12_ = GameState.objects.spawnObject(_loc98_,param2 * Physics.scale,param3 * Physics.scale,0,_loc15_.flipped);
                              if(!_loc12_)
                              {
                                 Vars.objSize = _loc14_;
                                 return null;
                              }
                              _loc22_ = userData(_loc12_.GetUserData());
                              _loc22_.ignored.push(param9);
                              _loc22_.triggerLock = false;
                              _loc22_.trigger = new TempProjectile(Math.random() * 45 + 45);
                              _loc22_.saveable = false;
                              _loc22_.triggerOnContact = true;
                              _loc11_ += 90 * Vars.toRadians * (_loc15_.flipped ? -1 : 1);
                              _loc35_ = "forcefield";
                              if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                              {
                                 _loc35_ = _loc15_.pfx.getParticle();
                              }
                              _loc27_ = 0;
                              while(_loc27_ < 20)
                              {
                                 _loc55_ = 0.15 * Math.random() + 0.1;
                                 GameState.particles.addParticles(param2 * Physics.scale,param3 * Physics.scale,1,_loc35_,_loc55_ * param7.x,_loc55_ * param7.y);
                                 _loc27_++;
                              }
                           }
                           else if(param1 == "snowman")
                           {
                              if(_loc15_.triggerDuration != 2)
                              {
                                 Vars.objSize = Math.random() * 0.5 + 0.3;
                                 _loc12_ = GameState.objects.spawnObject("coal",param2 * Physics.scale,param3 * Physics.scale,0,!_loc15_.flipped,true);
                                 userData(_loc12_.GetUserData()).triggerPos = new b2Vec2(Math.random() * 30 - 15,Math.random() * 30 - 20);
                              }
                              else
                              {
                                 _loc12_ = GameState.objects.spawnObject("snowmancarrot",param2 * Physics.scale,param3 * Physics.scale,0,!_loc15_.flipped,true);
                                 userData(_loc12_.GetUserData()).triggerPos = new b2Vec2(Math.random() * 30 - 15,Math.random() * 30 - 10);
                              }
                              ++_loc15_.triggerDuration;
                              if(_loc15_.triggerDuration > 2)
                              {
                                 _loc15_.triggerDuration = 0;
                              }
                              userData(_loc12_.GetUserData()).trigger = new SnowmanFace(_loc12_,100);
                              ArmourHelmet(userData(_loc12_.GetUserData()).trigger).allowOther = true;
                           }
                           else if(param1 == "grapple")
                           {
                              _loc12_ = GameState.objects.spawnObject("grapple",param2 * Physics.scale,param3 * Physics.scale,0,!_loc15_.flipped);
                              if(_loc12_)
                              {
                                 userData(_loc12_.GetUserData()).trigger = new Grapple(param9);
                                 userData(_loc12_.GetUserData()).triggerOnContact = true;
                              }
                           }
                           else if(param1 == "ballandchain")
                           {
                              _loc99_ = Vars.objDensity;
                              Vars.objDensity = 10;
                              _loc12_ = GameState.objects.spawnItem(O.getItem("bowlingball").vertices,[10],O.getItem("bowlingball").scale * param6,param1,param2 * Physics.scale,param3 * Physics.scale,0,O.getItem("bowlingball").colours,"none",_loc15_.skin);
                              Vars.objDensity = _loc99_;
                              Joints.Destroy(param9,"pistonjoint");
                              if(_loc12_)
                              {
                                 _loc100_ = Tweak.jointLimited;
                                 _loc101_ = Tweak.jointLimited;
                                 _loc102_ = Tweak.jointLimitedLower;
                                 _loc103_ = Tweak.jointLimitedUpper;
                                 Tweak.jointLimited = true;
                                 Tweak.jointLimitedLower = true;
                                 Tweak.jointLimitedUpper = true;
                                 Tweak.jointCollide = true;
                                 _loc104_ = Joints.Prismatic("pistonjoint",param9,_loc12_,_loc12_.GetPosition().Copy(),param9.GetPosition().Copy(),0);
                                 Tweak.jointLimited = _loc100_;
                                 Tweak.jointLimitedLower = _loc102_;
                                 Tweak.jointLimitedUpper = _loc103_;
                                 Tweak.jointCollide = _loc101_;
                              }
                           }
                           else if(param1 == "gra" || param1 == "grapplegun")
                           {
                              if(!(_loc15_.trigger is GrappleGun))
                              {
                                 Vars.objSize = _loc14_;
                                 return null;
                              }
                              _loc105_ = GrappleGun(_loc15_.trigger);
                              if(Boolean(_loc105_.hook) && userData(_loc105_.hook.GetUserData()).name == "deleted")
                              {
                                 _loc105_.hook = null;
                                 _loc105_.joint = null;
                              }
                              if(_loc105_.joint)
                              {
                                 _loc105_.firearm.disableAfterFiring = false;
                                 if(Boolean(_loc105_.hook) && jointUserData(_loc105_.joint.GetUserData()).dead)
                                 {
                                    _loc105_.firearm.disableAfterFiring = true;
                                    Body.Destroy(_loc105_.hook,"grapple");
                                    _loc105_.hook = null;
                                    _loc105_.joint = null;
                                    Vars.objSize = _loc14_;
                                    return null;
                                 }
                                 if(BoxUtils.vectorDist(_loc105_.hook.GetPosition(),param9.GetPosition()) < 20)
                                 {
                                    _loc105_.firearm.disableAfterFiring = true;
                                    Body.Destroy(_loc105_.hook,"grapple");
                                    _loc105_.hook = null;
                                    _loc105_.joint = null;
                                    Vars.objSize = _loc14_;
                                    return null;
                                 }
                                 _loc105_.joint.m_length -= 0.8;
                                 if(_loc105_.joint.m_length < 0)
                                 {
                                    _loc105_.joint.m_length = 0;
                                 }
                                 Vars.objSize = _loc14_;
                                 return null;
                              }
                              if(_loc105_.hook)
                              {
                                 Vars.objSize = _loc14_;
                                 return null;
                              }
                              _loc12_ = GameState.objects.spawnObject("grapple",param2 * Physics.scale,param3 * Physics.scale,0,!_loc15_.flipped);
                              if(_loc12_)
                              {
                                 _loc105_.firearm.disableAfterFiring = true;
                                 userData(_loc12_.GetUserData()).trigger = new Grapple(param9);
                                 userData(_loc12_.GetUserData()).triggerOnContact = true;
                                 _loc105_.hook = _loc12_;
                                 _loc15_.connected = new Vector.<b2Body>();
                                 userData(_loc105_.hook.GetUserData()).connected = new Vector.<b2Body>();
                                 _loc15_.connected.push(_loc105_.hook);
                                 userData(_loc105_.hook.GetUserData()).connected.push(param9);
                              }
                           }
                           else
                           {
                              if(param1 == "tinyele")
                              {
                                 _loc106_ = GeneralUtils.pointOnCircle(param2 * Physics.scale,param3 * Physics.scale,10 * _loc15_.size,_loc11_ * Vars.toDegrees + _loc107_ * 9 - 90);
                                 _loc12_ = Spawn.circle(_loc106_.x,_loc106_.y,5,Properties.objectProperties("pulse"),[0.01,1,1]);
                                 userData(_loc12_.GetUserData()).ghost = true;
                                 userData(_loc12_.GetUserData()).killOnContact = true;
                                 userData(_loc12_.GetUserData()).trigger = new Tesla();
                                 userData(_loc12_.GetUserData()).triggerRadius = 100;
                                 userData(_loc12_.GetUserData()).triggered = true;
                                 userData(_loc12_.GetUserData()).triggerLock = true;
                                 userData(_loc12_.GetUserData()).zerograv = true;
                                 _loc12_.ApplyImpulse(new b2Vec2((-param2 * Physics.scale + _loc106_.x) * 0.01,(-param3 * Physics.scale + _loc106_.y) * 0.01),_loc12_.GetPosition());
                                 Vars.objSize = _loc14_;
                                 return _loc137_;
                              }
                              if(param1 == "ele" || param1 == "electro")
                              {
                                 if(_loc15_.flipped)
                                 {
                                    _loc11_ += Math.PI;
                                 }
                                 _loc107_ = 0;
                                 while(_loc107_ < 22)
                                 {
                                    _loc106_ = GeneralUtils.pointOnCircle(param2 * Physics.scale,param3 * Physics.scale,100 * _loc15_.size,_loc11_ * Vars.toDegrees + _loc107_ * 9 - 90);
                                    _loc108_ = Spawn.circle(_loc106_.x,_loc106_.y,5,Properties.objectProperties("pulse"),[0.01,1,1]);
                                    _loc37_ = userData(_loc108_.GetUserData());
                                    if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                                    {
                                       _loc37_.pfx = _loc15_.pfx;
                                    }
                                    _loc37_.ghost = true;
                                    _loc37_.killOnContact = true;
                                    _loc37_.trigger = new Tesla();
                                    _loc37_.triggerRadius = 100;
                                    _loc37_.triggered = true;
                                    _loc37_.triggerLock = true;
                                    _loc37_.zerograv = true;
                                    _loc108_.ApplyImpulse(new b2Vec2((-param2 * Physics.scale + _loc106_.x) * 0.001,(-param3 * Physics.scale + _loc106_.y) * 0.001),_loc108_.GetPosition());
                                    _loc107_++;
                                 }
                                 Vars.objSize = _loc14_;
                                 return null;
                              }
                              if(param1 == "bfg")
                              {
                                 _loc35_ = "shinygreen";
                                 if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                                 {
                                    _loc35_ = _loc15_.pfx.getParticle();
                                 }
                                 _loc27_ = 0;
                                 while(_loc27_ < 50 / param5)
                                 {
                                    GameState.particles.addParticles(param2 * Physics.scale,param3 * Physics.scale,1,_loc35_,param7.x * _loc27_ / 100,param7.y * _loc27_ / 100,10,10);
                                    _loc27_++;
                                 }
                                 if(_loc15_.flipped)
                                 {
                                    _loc11_ += Math.PI;
                                 }
                                 _loc106_ = GeneralUtils.pointOnCircle(param2 * Physics.scale,param3 * Physics.scale,10 * _loc15_.size,_loc11_ * Vars.toDegrees);
                                 _loc108_ = Spawn.circle(_loc106_.x,_loc106_.y,5,Properties.objectProperties("pulse"),[0.01,1,1]);
                                 _loc37_ = userData(_loc108_.GetUserData());
                                 if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                                 {
                                    _loc37_.pfx = _loc15_.pfx;
                                 }
                                 _loc37_.killOnContact = true;
                                 _loc37_.trigger = new BFG();
                                 _loc37_.triggerRadius = 250;
                                 _loc37_.triggerForce = 100;
                                 _loc37_.triggered = true;
                                 _loc37_.triggerLock = true;
                                 _loc37_.zerograv = true;
                                 _loc108_.ApplyImpulse(new b2Vec2((-param2 * Physics.scale + _loc106_.x) * 0.008,(-param3 * Physics.scale + _loc106_.y) * 0.008),_loc108_.GetPosition());
                                 Vars.objSize = _loc14_;
                                 return _loc108_;
                              }
                              if(param1 == "micro")
                              {
                                 if(_loc15_.flipped)
                                 {
                                    _loc11_ += Math.PI;
                                 }
                                 _loc107_ = 0;
                                 while(_loc107_ < 10)
                                 {
                                    _loc106_ = GeneralUtils.pointOnCircle(param2 * Physics.scale,param3 * Physics.scale,10 * _loc15_.size,_loc11_ * Vars.toDegrees + _loc107_ * 6 - 30);
                                    _loc108_ = Spawn.circle(_loc106_.x,_loc106_.y,5,Properties.objectProperties("pulse"),[0.01,1,1]);
                                    _loc37_ = userData(_loc108_.GetUserData());
                                    if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                                    {
                                       _loc37_.pfx = _loc15_.pfx;
                                    }
                                    _loc37_.killOnContact = true;
                                    _loc37_.trigger = new Radioactive(false,false);
                                    _loc37_.triggerRadius = 50;
                                    _loc37_.triggered = true;
                                    _loc37_.triggerLock = true;
                                    _loc37_.zerograv = true;
                                    _loc37_.ignore = "pulse";
                                    _loc108_.SetLinearVelocity(new b2Vec2((-param2 * Physics.scale + _loc106_.x) * 10,(-param3 * Physics.scale + _loc106_.y) * 10));
                                    _loc107_++;
                                 }
                                 Vars.objSize = _loc14_;
                                 return null;
                              }
                              if(param1 == "sleep")
                              {
                                 _loc37_ = Properties.objectProperties("sleep");
                                 _loc37_.saveable = false;
                                 _loc37_.trigger = new GenericBullet("sleep");
                                 _loc37_.triggered = true;
                                 _loc37_.killOnContact = true;
                                 _loc12_ = Spawn.circle(param2,param3,0.1,_loc37_,[1,1,1]);
                              }
                              else
                              {
                                 if(param1 == "stas" || param1 == "stasisbullet")
                                 {
                                    if(_loc15_.flipped)
                                    {
                                       _loc11_ += Math.PI;
                                    }
                                    _loc107_ = 0;
                                    while(_loc107_ < 11)
                                    {
                                       _loc106_ = GeneralUtils.pointOnCircle(param2 * Physics.scale,param3 * Physics.scale,10 * _loc15_.size,_loc11_ * Vars.toDegrees + _loc107_ * 9 - 45);
                                       _loc108_ = Spawn.circle(_loc106_.x,_loc106_.y,5,Properties.objectProperties("stasis"),[0.01,1,1]);
                                       userData(_loc108_.GetUserData()).killOnContact = true;
                                       userData(_loc108_.GetUserData()).trigger = new StasisBullet();
                                       userData(_loc108_.GetUserData()).triggered = true;
                                       userData(_loc108_.GetUserData()).triggerLock = true;
                                       userData(_loc108_.GetUserData()).zerograv = true;
                                       _loc108_.ApplyForce(new b2Vec2((-param2 * Physics.scale + _loc106_.x) * 0.5,(-param3 * Physics.scale + _loc106_.y) * 0.5),_loc108_.GetPosition());
                                       userData(_loc108_.GetUserData()).connected.push(param9);
                                       _loc107_++;
                                    }
                                    Vars.objSize = _loc14_;
                                    return null;
                                 }
                                 if(param1 == "armourbreaker")
                                 {
                                    _loc12_ = Spawn.circle(param2 * Physics.scale,param3 * Physics.scale,2,Properties.objectProperties(param1),[0.01,1,1]);
                                    userData(_loc12_.GetUserData()).trigger = new DestroyArmourOnCollision();
                                    userData(_loc12_.GetUserData()).triggered = true;
                                    userData(_loc12_.GetUserData()).killOnContact = true;
                                    userData(_loc12_.GetUserData()).ignore = "armourbreaker";
                                 }
                                 else
                                 {
                                    if(param1 == "laserbeam")
                                    {
                                       if(_loc15_.flipped)
                                       {
                                          _loc11_ += Math.PI;
                                       }
                                       _loc107_ = 0;
                                       while(_loc107_ < param5)
                                       {
                                          _loc106_ = GeneralUtils.pointOnCircle(param2 * Physics.scale,param3 * Physics.scale,10 * _loc15_.size,_loc11_ * Vars.toDegrees + _loc107_ * 9 - 45);
                                          _loc108_ = Spawn.circle(_loc106_.x,_loc106_.y,5,Properties.objectProperties(param1),[0.01,1,1]);
                                          _loc109_ = _loc108_.GetUserData();
                                          _loc109_.ghost = true;
                                          _loc109_.killOnContact = true;
                                          _loc109_.triggerCustom = _loc15_.triggerCustom;
                                          _loc109_.trigger = new LaserBeamBullet();
                                          _loc109_.triggerForce = _loc15_.triggerForce;
                                          _loc109_.triggerDuration = _loc15_.triggerDuration;
                                          _loc109_.triggered = true;
                                          _loc109_.triggerLock = true;
                                          _loc109_.zerograv = true;
                                          _loc23_ = Math.round(Math.random() * param8 - param8 * 0.5);
                                          _loc24_ = Math.round(Math.random() * param8 - param8 * 0.5);
                                          _loc108_.SetLinearVelocity(new b2Vec2(param7.x + _loc23_,param7.y + _loc24_));
                                          if(param5 > 1)
                                          {
                                             _loc108_.ApplyForce(new b2Vec2((-param2 * Physics.scale + _loc106_.x) * 0.5,(-param3 * Physics.scale + _loc106_.y) * 0.5),_loc108_.GetPosition());
                                          }
                                          _loc109_.ignored.push(param9);
                                          _loc109_.connected.push(param9);
                                          _loc107_++;
                                       }
                                       Vars.objSize = _loc14_;
                                       return null;
                                    }
                                    if(param1 == "blorch")
                                    {
                                       if(_loc15_.flipped)
                                       {
                                          _loc11_ += Math.PI;
                                       }
                                       _loc110_ = 1;
                                       _loc81_ = new b2Vec2(param2 * Physics.scale,param3 * Physics.scale);
                                       _loc12_ = Spawn.circle(_loc81_.x,_loc81_.y,1,Properties.objectProperties(param1),[1,1,1,100]);
                                       _loc22_ = userData(_loc12_.GetUserData());
                                       _loc22_.trigger = new Disc();
                                       _loc22_.triggerCustom = _loc15_.triggerCustom;
                                       _loc22_.ignore = param1;
                                       _loc22_.triggerRadius = _loc15_.triggerRadius;
                                       _loc22_.triggerForce = _loc15_.triggerForce;
                                       _loc22_.triggered = true;
                                       _loc22_.skin = _loc15_.skin.slice();
                                       _loc23_ = Math.round(Math.random() * param8 - param8 * 0.5);
                                       _loc24_ = Math.round(Math.random() * param8 - param8 * 0.5);
                                       if(_loc15_.flipped)
                                       {
                                          _loc110_ = -1;
                                       }
                                       _loc12_.SetLinearVelocity(new b2Vec2(param7.x + _loc23_,param7.y + _loc24_));
                                    }
                                    else if(param1 == "boom")
                                    {
                                       _loc12_ = Spawn.circle(param2 * Physics.scale,param3 * Physics.scale,1,Properties.objectProperties(param1),[1,1,1,100]);
                                       _loc22_ = userData(_loc12_.GetUserData());
                                       _loc22_.trigger = new Explode();
                                       _loc22_.triggered = true;
                                    }
                                    else if(param1 == "spiderweb")
                                    {
                                       if(_loc15_.flipped)
                                       {
                                          _loc11_ += Math.PI;
                                       }
                                       _loc108_ = Spawn.circle(param2 * Physics.scale,param3 * Physics.scale,5,Properties.objectProperties("web"),[0.01,1,1]);
                                       userData(_loc108_.GetUserData()).trigger = new WebBullet();
                                       userData(_loc108_.GetUserData()).triggered = true;
                                       userData(_loc108_.GetUserData()).triggerLock = true;
                                       userData(_loc108_.GetUserData()).ignore = "web";
                                       _loc23_ = Math.round(Math.random() * param8 - param8 * 0.5);
                                       _loc24_ = Math.round(Math.random() * param8 - param8 * 0.5);
                                       _loc108_.SetLinearVelocity(new b2Vec2(param7.x + _loc23_,param7.y + _loc24_));
                                       userData(_loc108_.GetUserData()).connected.push(param9);
                                       _loc12_ = _loc108_;
                                    }
                                    else if(param1 == "icicle")
                                    {
                                       _loc83_ = new Vector.<Array>();
                                       _loc83_.push(["49BBE2","4AC5D3"]);
                                       _loc83_.push(["4ABCE2","4AC5D3"]);
                                       if(Boolean(_loc15_.skin) && _loc15_.skin.length > 0)
                                       {
                                          BoxUtils.setSkinColour(_loc83_,"49BBE2",BoxUtils.getSkinColour(_loc15_.skin,"4AC5D3").toString(16));
                                          BoxUtils.setSkinColour(_loc83_,"4ABCE2",GraphicUtils.scalehex(BoxUtils.getSkinColour(_loc15_.skin,"4AC5D3"),1.1).toString(16));
                                       }
                                       _loc84_ = this.spawnSkin.slice();
                                       this.spawnSkin = _loc83_;
                                       _loc12_ = this.spawnObject("icicle",param2 * Physics.scale,param3 * Physics.scale,0,_loc15_.flipped,true,_loc83_);
                                       this.spawnSkin = _loc84_;
                                       if(_loc15_.flipped)
                                       {
                                          _loc11_ -= Math.PI * 0.5;
                                       }
                                       else
                                       {
                                          _loc11_ -= Math.PI * 1.5;
                                       }
                                    }
                                    else if(param1 == "pizza")
                                    {
                                       _loc12_ = GameState.objects.spawnItem(O.getItem("pizza").vertices,[1],0.2 + Math.random() * 0.06 - 0.03,"pizza",0,0,0,O.getItem("pizza").colours);
                                       userData(_loc12_.GetUserData()).name = ["B08143","61221A","f1cc78"][Math.random() * 3 >> 0];
                                       userData(_loc12_.GetUserData()).trigger = new Paint();
                                       userData(_loc12_.GetUserData()).triggered = true;
                                       userData(_loc12_.GetUserData()).killOnContact = true;
                                    }
                                    else if(param1 == "snowball")
                                    {
                                       _loc60_ = GameState.objects.spawnScale;
                                       GameState.objects.spawnScale = Math.random() * 0.5 + 0.5;
                                       _loc12_ = GameState.objects.spawnObject("snowball",param2 * Physics.scale,param3 * Physics.scale,0,_loc15_.flipped);
                                       GameState.objects.spawnScale = _loc60_;
                                       _loc35_ = "snow";
                                       if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                                       {
                                          _loc35_ = _loc15_.pfx.getParticle();
                                       }
                                       _loc27_ = 0;
                                       while(_loc27_ < 20)
                                       {
                                          _loc55_ = 0.01 * Math.random() + 0.02;
                                          GameState.particles.addParticles(param2 * Physics.scale,param3 * Physics.scale,1,_loc35_,_loc55_ * param7.x,_loc55_ * param7.y);
                                          _loc27_++;
                                       }
                                    }
                                    else if(param1 == "growingtomato")
                                    {
                                       _loc60_ = GameState.objects.spawnScale;
                                       GameState.objects.spawnScale = Math.random() * 0.5 + 0.5;
                                       _loc12_ = GameState.objects.spawnObject("growingtomato",param2 * Physics.scale,param3 * Physics.scale,0,_loc15_.flipped);
                                       GameState.objects.spawnScale = _loc60_;
                                    }
                                    else if(param1 == "icicle2")
                                    {
                                       _loc12_ = GameState.objects.spawnItem(O.getItem("icicle").vertices,[1],0.08 + Math.random() * 0.04 - 0.02,"icicle",0,0,0,O.getItem("icicle").colours);
                                       userData(_loc12_.GetUserData()).brittle = true;
                                       userData(_loc12_.GetUserData()).triggerColour = "333333";
                                       userData(_loc12_.GetUserData()).sharp = true;
                                       userData(_loc12_.GetUserData()).projectile = true;
                                       userData(_loc12_.GetUserData()).saveable = false;
                                       userData(_loc12_.GetUserData()).soft = true;
                                       userData(_loc12_.GetUserData()).unbreakable = true;
                                       userData(_loc12_.GetUserData()).ignore = "icicle";
                                       userData(_loc12_.GetUserData()).trigger = new Disintegrate("crystal",10,5);
                                       userData(_loc12_.GetUserData()).triggerOnContact = true;
                                       if(_loc15_.flipped)
                                       {
                                          _loc11_ -= Math.PI * 0.5;
                                       }
                                       else
                                       {
                                          _loc11_ -= Math.PI * 1.5;
                                       }
                                    }
                                    else if(param1 == "magma")
                                    {
                                       _loc12_ = Spawn.circle(param2 * Physics.scale,param3 * Physics.scale,5,Properties.objectProperties("magma"),[1,1,1]);
                                       userData(_loc12_.GetUserData()).trigger = new MagmaBullet();
                                       userData(_loc12_.GetUserData()).ignore = "magma";
                                       userData(_loc12_.GetUserData()).triggered = true;
                                       userData(_loc12_.GetUserData()).sticky = true;
                                       userData(_loc12_.GetUserData()).triggerRadius = 50;
                                       userData(_loc12_.GetUserData()).temperature = 250;
                                    }
                                    else if(param1 == "stormcloud")
                                    {
                                       _loc12_ = GameState.objects.spawnObject("triangle",param2,param3,_loc11_,false,true);
                                       userData(_loc12_.GetUserData()).trigger = new ShockwaveMine();
                                       userData(_loc12_.GetUserData()).name = "stormcloud";
                                       userData(_loc12_.GetUserData()).ignored.push(param9);
                                       userData(_loc12_.GetUserData()).graphic.alpha = 0;
                                       userData(_loc12_.GetUserData()).triggered = true;
                                       userData(_loc12_.GetUserData()).killOnContact = true;
                                       userData(_loc12_.GetUserData()).resistShock = true;
                                       userData(_loc12_.GetUserData()).triggerRadius = 50;
                                       userData(_loc12_.GetUserData()).triggerPos = new b2Vec2(Math.random() * 100,Math.random() * 100);
                                    }
                                    else if(param1 == "neurogas")
                                    {
                                       _loc37_ = Properties.objectProperties("neurogas");
                                       _loc12_ = Spawn.circle(param2 * Physics.scale,param3 * Physics.scale,5,Properties.objectProperties("neurogas"),[1,1,1]);
                                       userData(_loc12_.GetUserData()).trigger = new NeuroBullet();
                                       userData(_loc12_.GetUserData()).triggered = true;
                                       userData(_loc12_.GetUserData()).ghost = true;
                                       userData(_loc12_.GetUserData()).triggerRadius = 50;
                                    }
                                    else if(param1 == "hail")
                                    {
                                       _loc37_ = Properties.objectProperties("hail");
                                       _loc12_ = Spawn.circle(param2 * Physics.scale,param3 * Physics.scale,5,Properties.objectProperties("hail"),[1,1,1]);
                                       userData(_loc12_.GetUserData()).trigger = new HailBullet();
                                       userData(_loc12_.GetUserData()).triggered = true;
                                       userData(_loc12_.GetUserData()).killOnContact = true;
                                    }
                                    else
                                    {
                                       if(param1 == "net")
                                       {
                                          _loc111_ = _loc15_.trigger is NetGun;
                                          if((_loc111_) && NetGun(_loc15_.trigger).net > 2)
                                          {
                                             for each(_loc116_ in NetGun(_loc15_.trigger).nets[0])
                                             {
                                                Body.Destroy(_loc116_,"netgun");
                                             }
                                             NetGun(_loc15_.trigger).nets.shift();
                                          }
                                          _loc112_ = new Vector.<b2Body>();
                                          _loc113_ = 6;
                                          _loc114_ = 20 * _loc15_.size;
                                          _loc115_ = 0;
                                          while(_loc115_ < _loc113_)
                                          {
                                             _loc117_ = "c76f1d";
                                             if(_loc15_.triggerColour)
                                             {
                                                _loc117_ = _loc15_.triggerColour;
                                             }
                                             if(_loc15_.skin.length > 0)
                                             {
                                                _loc117_ = BoxUtils.getSkinColour(_loc15_.skin,"c76f1d").toString(16);
                                                if(_loc117_ == "FF00FF")
                                                {
                                                   _loc117_ = BoxUtils.getSkinColour(_loc15_.skin,_loc15_.triggerColour).toString(16);
                                                }
                                                if(_loc117_ == "FF00FF")
                                                {
                                                   _loc117_ = "c76f1d";
                                                }
                                             }
                                             _loc37_ = Properties.objectProperties(_loc117_);
                                             _loc118_ = BoxUtils.rotateVec(new b2Vec2(0,-(_loc113_ * _loc114_ * 0.5) + _loc115_ * _loc114_),param9.GetAngle());
                                             _loc12_ = Spawn.circle(param2 * Physics.scale + _loc118_.x,param3 * Physics.scale + _loc118_.y,2,_loc37_,[0.1,1,1]);
                                             if(_loc12_)
                                             {
                                                userData(_loc12_.GetUserData()).sticky = true;
                                                _loc12_.SetLinearVelocity(param7);
                                                _loc12_.SetBullet(true);
                                                _loc112_.push(_loc12_);
                                                if(Boolean(_loc17_) && _loc17_.bulletProperties.length > 0)
                                                {
                                                   userData(_loc12_.GetUserData()).setProperties(_loc17_.bulletProperties.join(","));
                                                }
                                             }
                                             _loc115_++;
                                          }
                                          _loc115_ = 0;
                                          while(_loc115_ < _loc112_.length - 1)
                                          {
                                             Joints.Distance("netjoint",_loc112_[_loc115_],_loc112_[_loc115_ + 1],_loc112_[_loc115_].GetPosition(),_loc112_[_loc115_ + 1].GetPosition());
                                             _loc115_++;
                                          }
                                          if(_loc111_)
                                          {
                                             NetGun(_loc15_.trigger).nets.push(_loc112_);
                                             ++NetGun(_loc15_.trigger).net;
                                          }
                                          Vars.objSize = _loc14_;
                                          return null;
                                       }
                                       if(param1 == "cupid")
                                       {
                                          _loc37_ = Properties.objectProperties("cupid");
                                          _loc12_ = Spawn.circle(param2 * Physics.scale,param3 * Physics.scale,5,_loc37_,[1,1,1]);
                                          userData(_loc12_.GetUserData()).trigger = new CupidBullet();
                                          userData(_loc12_.GetUserData()).triggered = true;
                                          userData(_loc12_.GetUserData()).ignore = "cupidbow";
                                          userData(_loc12_.GetUserData()).triggerRadius = _loc15_.triggerRadius;
                                          userData(_loc12_.GetUserData()).triggerForce = _loc15_.triggerForce;
                                       }
                                       else
                                       {
                                          if(param1 == "por" || param1 == "portal")
                                          {
                                             if(!(_loc15_.trigger is PortalGun))
                                             {
                                                Vars.objSize = _loc14_;
                                                return null;
                                             }
                                             _loc119_ = PortalGun(_loc15_.trigger);
                                             _loc120_ = -1;
                                             if(_loc15_.flipped)
                                             {
                                                _loc120_ = 1;
                                             }
                                             _loc61_ = param2 * Physics.scale;
                                             _loc62_ = param3 * Physics.scale;
                                             _loc121_ = new b2Vec2(0,0);
                                             _loc122_ = new b2Vec2(100 * _loc120_,0);
                                             _loc63_ = BoxUtils.rotateVec(_loc121_,param9.GetAngle());
                                             _loc64_ = BoxUtils.rotateVec(_loc122_,param9.GetAngle());
                                             _loc123_ = new b2Vec2(_loc61_ + _loc63_.x,_loc62_ + _loc63_.y);
                                             _loc124_ = new b2Vec2(_loc61_ + _loc64_.x,_loc62_ + _loc64_.y);
                                             GameState.madeby = "laser";
                                             _loc125_ = GameState.cutter.CustomRaycast(_loc123_,1000,_loc124_);
                                             if(!_loc125_[0])
                                             {
                                                Vars.objSize = _loc14_;
                                                return null;
                                             }
                                             _loc126_ = _loc123_.x;
                                             _loc127_ = _loc123_.y;
                                             _loc128_ = _loc124_.x;
                                             _loc129_ = _loc124_.y;
                                             if(_loc125_[1])
                                             {
                                                _loc128_ = b2Vec2(_loc125_[1]).x * Physics.scale;
                                                _loc129_ = b2Vec2(_loc125_[1]).y * Physics.scale;
                                             }
                                             _loc69_ = (_loc129_ - _loc127_) / (_loc128_ - _loc126_);
                                             _loc44_ = 4279308731;
                                             if(_loc119_.which == 2)
                                             {
                                                _loc44_ = 4294936577;
                                             }
                                             _loc130_ = new b2Vec2();
                                             _loc35_ = "laser";
                                             if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                                             {
                                                _loc35_ = _loc15_.pfx.getParticle();
                                             }
                                             _loc131_ = 30;
                                             while(_loc131_ > 0)
                                             {
                                                _loc72_ = _loc126_ + _loc131_ / 30 * (_loc128_ - _loc126_);
                                                _loc73_ = _loc127_ + _loc69_ * (_loc72_ - _loc126_);
                                                _loc52_ = GameState.particles.addParticles(_loc72_,_loc73_,1,_loc35_,(-_loc126_ + _loc72_) * 0.5,(-_loc127_ + _loc73_) * 0.5,0,0);
                                                if((Boolean(_loc52_)) && _loc52_.length > 0)
                                                {
                                                   for each(_loc53_ in _loc52_)
                                                   {
                                                      _loc53_.colour = _loc44_;
                                                      _loc53_.health = 600;
                                                      _loc53_.fade = 10;
                                                   }
                                                }
                                                if(_loc131_ == 28)
                                                {
                                                   _loc130_.x = _loc72_;
                                                   _loc130_.y = _loc73_;
                                                }
                                                _loc131_--;
                                             }
                                             if(_loc119_.which == 1)
                                             {
                                                if(_loc119_.firstPortal)
                                                {
                                                   Body.Destroy(_loc119_.firstPortal,"portal");
                                                }
                                                _loc134_ = GameState.objects.spawnScale;
                                                GameState.objects.spawnScale = _loc15_.size;
                                                _loc12_ = GameState.objects.spawnObject("portal1",_loc130_.x,_loc130_.y,0,_loc15_.flipped,true);
                                                GameState.objects.spawnScale = _loc134_;
                                                _loc119_.firstPortal = _loc12_;
                                                _loc119_.which = 2;
                                             }
                                             else if(_loc119_.which == 2)
                                             {
                                                if(_loc119_.secondPortal)
                                                {
                                                   Body.Destroy(_loc119_.secondPortal,"portal");
                                                }
                                                _loc134_ = GameState.objects.spawnScale;
                                                GameState.objects.spawnScale = _loc15_.size;
                                                _loc12_ = GameState.objects.spawnObject("portal2",_loc130_.x,_loc130_.y,0,_loc15_.flipped,true);
                                                GameState.objects.spawnScale = _loc134_;
                                                _loc119_.secondPortal = _loc12_;
                                                _loc119_.which = 1;
                                             }
                                             _loc132_ = _loc119_.firstPortal != null;
                                             _loc133_ = _loc119_.secondPortal != null;
                                             if(Boolean(_loc119_.firstPortal) && Boolean(_loc119_.secondPortal))
                                             {
                                                userData(_loc119_.firstPortal.GetUserData()).connected = new Vector.<b2Body>();
                                                userData(_loc119_.secondPortal.GetUserData()).connected = new Vector.<b2Body>();
                                                userData(_loc119_.firstPortal.GetUserData()).connected.push(_loc119_.secondPortal);
                                                userData(_loc119_.secondPortal.GetUserData()).connected.push(_loc119_.firstPortal);
                                             }
                                             Vars.objSize = _loc14_;
                                             return null;
                                          }
                                          if(param1 == "blu" || param1 == "randomBlunt")
                                          {
                                             _loc97_ = ["gavel","gravityhammer","powerglove","shorthammerspiked","hammerthorn","handofdoom","carmirrorclub","baton","bludgeon","brassknuckles","crutch","cudgel","baton2","flashlight","gaffistick","macemamm","maul","metalbat","cudgel2","mjolnir","morningstar","nailbat","nailstick","pipe","pitchfork","powerfist","pulverizer","radianthammer","rollingpin","sceptre","shillelagh","streetsign","torch","trident","trophy","trout","voodoohammer","warhammer","woodenhammer","staffofundefined","lollipop","firepoker","rockethammer","sacredwarhammer","tanzaniteshammer","warbanner","wastelandsledge"];
                                             _loc98_ = _loc97_[Math.random() * _loc97_.length >> 0];
                                             _loc12_ = GameState.objects.spawnObject(_loc98_,param2 * Physics.scale,param3 * Physics.scale,0,_loc15_.flipped);
                                             if(!_loc12_)
                                             {
                                                Vars.objSize = _loc14_;
                                                return null;
                                             }
                                             _loc22_ = userData(_loc12_.GetUserData());
                                             _loc22_.triggerLock = false;
                                             _loc22_.triggerOnContact = true;
                                             _loc22_.trigger = new TempProjectile(20);
                                             _loc22_.saveable = false;
                                             _loc22_.triggered = true;
                                             _loc11_ += 90 * Vars.toRadians * (_loc15_.flipped ? -1 : 1);
                                             _loc35_ = "laser";
                                             if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                                             {
                                                _loc35_ = _loc15_.pfx.getParticle();
                                             }
                                             _loc27_ = 0;
                                             while(_loc27_ < 20)
                                             {
                                                _loc55_ = 0.15 * Math.random() + 0.1;
                                                GameState.particles.addParticles(param2 * Physics.scale,param3 * Physics.scale,1,_loc35_,_loc55_ * param7.x,_loc55_ * param7.y);
                                                _loc27_++;
                                             }
                                          }
                                          else
                                          {
                                             if(param1 == "rep" || param1 == "repulsor")
                                             {
                                                _loc61_ = param2 * Physics.scale;
                                                _loc62_ = param3 * Physics.scale;
                                                _loc63_ = BoxUtils.rotateVec(new b2Vec2(0,-5 * _loc15_.size),param9.GetAngle());
                                                _loc64_ = BoxUtils.rotateVec(new b2Vec2(0,-10 * _loc15_.size),param9.GetAngle());
                                                _loc123_ = new b2Vec2(_loc61_ + _loc63_.x,_loc62_ + _loc63_.y);
                                                _loc124_ = new b2Vec2(_loc61_ + _loc64_.x,_loc62_ + _loc64_.y);
                                                _loc65_ = GameState.cutter.CustomRaycast(_loc123_,200 * _loc15_.size,_loc124_,true);
                                                _loc66_ = _loc65_[0];
                                                _loc135_ = param9.GetAngle() + Vars.PI * 0.5;
                                                _loc35_ = "forcefield";
                                                if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                                                {
                                                   _loc35_ = _loc15_.pfx.getParticle();
                                                }
                                                _loc27_ = 0;
                                                while(_loc27_ < 20)
                                                {
                                                   GameState.particles.addParticles(_loc123_.x,_loc123_.y,1,_loc35_,_loc27_ * -3 * Math.cos(_loc135_),_loc27_ * -3 * Math.sin(_loc135_),3,3);
                                                   _loc27_++;
                                                }
                                                if(Boolean(_loc66_) && Boolean(!_loc66_.IsStatic()) && _loc66_ != param9)
                                                {
                                                   _loc136_ = BoxUtils.selectCompound(_loc66_);
                                                   for each(_loc137_ in _loc136_)
                                                   {
                                                      _loc137_.WakeUp();
                                                      _loc137_.ApplyImpulse(new b2Vec2(-_loc15_.triggerForce * Math.cos(_loc135_) * _loc137_.GetMass(),-_loc15_.triggerForce * Math.sin(_loc135_) * _loc137_.GetMass()),b2Vec2(_loc65_[1]));
                                                   }
                                                }
                                                Vars.objSize = _loc14_;
                                                return null;
                                             }
                                             if(param1 == "launcher")
                                             {
                                                _loc61_ = param2 * Physics.scale;
                                                _loc62_ = param3 * Physics.scale;
                                                _loc120_ = -1;
                                                if(_loc15_.flipped)
                                                {
                                                   _loc120_ = 1;
                                                }
                                                if(_loc15_.flipped)
                                                {
                                                   _loc63_ = new b2Vec2(12,0);
                                                   _loc64_ = new b2Vec2(13,0);
                                                }
                                                else
                                                {
                                                   _loc63_ = new b2Vec2(-8,0);
                                                   _loc64_ = new b2Vec2(-9,0);
                                                }
                                                _loc63_ = BoxUtils.rotateVec(_loc63_,param9.GetAngle());
                                                _loc64_ = BoxUtils.rotateVec(_loc64_,param9.GetAngle());
                                                _loc123_ = new b2Vec2(_loc61_ + _loc63_.x * _loc15_.size,_loc62_ + _loc63_.y * _loc15_.size);
                                                _loc124_ = new b2Vec2(_loc61_ + _loc64_.x * _loc15_.size,_loc62_ + _loc64_.y * _loc15_.size);
                                                _loc138_ = 20;
                                                if(_loc15_.triggerState)
                                                {
                                                   _loc138_ = _loc15_.triggerState;
                                                }
                                                GameState.cutter.ExcludeSingle(param9);
                                                _loc65_ = GameState.cutter.CustomRaycast(_loc123_,_loc138_ * _loc15_.size,_loc124_,false);
                                                if(!_loc65_[0])
                                                {
                                                   _loc65_ = GameState.cutter.CustomRaycast(_loc123_,_loc138_ * _loc15_.size,_loc124_,true);
                                                }
                                                _loc66_ = _loc65_[0];
                                                _loc135_ = param9.GetAngle();
                                                _loc35_ = "air";
                                                if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                                                {
                                                   _loc35_ = _loc15_.pfx.getParticle();
                                                }
                                                _loc27_ = 0;
                                                while(_loc27_ < 20)
                                                {
                                                   GameState.particles.addParticles(_loc123_.x,_loc123_.y,1,_loc35_,_loc27_ * 3 * _loc120_ * Math.cos(_loc135_),_loc27_ * 3 * _loc120_ * Math.sin(_loc135_),3,3);
                                                   _loc27_++;
                                                }
                                                if(Boolean(_loc66_) && Boolean(!_loc66_.IsStatic()) && _loc66_ != param9)
                                                {
                                                   _loc136_ = BoxUtils.selectCompound(_loc66_);
                                                   _loc139_ = _loc15_.triggerForce * _loc120_;
                                                   for each(_loc137_ in _loc136_)
                                                   {
                                                      _loc137_.WakeUp();
                                                      _loc137_.ApplyImpulse(new b2Vec2(_loc139_ * Math.cos(_loc135_) * _loc137_.GetMass(),_loc139_ * Math.sin(_loc135_) * _loc137_.GetMass()),b2Vec2(_loc65_[1]));
                                                   }
                                                }
                                                Vars.objSize = _loc14_;
                                                return null;
                                             }
                                             if(param1 == "bea")
                                             {
                                                _loc120_ = -1;
                                                if(_loc15_.flipped)
                                                {
                                                   _loc120_ = 1;
                                                }
                                                _loc61_ = param2 * Physics.scale;
                                                _loc62_ = param3 * Physics.scale;
                                                _loc123_ = new b2Vec2(_loc61_,_loc62_);
                                                _loc124_ = new b2Vec2(_loc61_ + param7.x,_loc62_ + param7.y);
                                                GameState.madeby = "laser";
                                                GameState.cutter.CustomCut(_loc123_,_loc124_,1,_loc15_.triggerForce,0);
                                                _loc126_ = _loc123_.x;
                                                _loc127_ = _loc123_.y;
                                                _loc128_ = _loc124_.x;
                                                _loc129_ = _loc124_.y;
                                                _loc69_ = (_loc129_ - _loc127_) / (_loc128_ - _loc126_);
                                                _loc43_ = _loc15_.skin;
                                                _loc44_ = 4289689623;
                                                if(Boolean(_loc43_) && _loc43_.length > 0)
                                                {
                                                   _loc44_ = 4278190080 + BoxUtils.getSkinColour(_loc43_,"AF7817");
                                                }
                                                _loc35_ = "laser";
                                                if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                                                {
                                                   _loc35_ = _loc15_.pfx.getParticle();
                                                }
                                                _loc131_ = 50;
                                                while(_loc131_ > 0)
                                                {
                                                   _loc72_ = _loc126_ + _loc131_ / 50 * (_loc128_ - _loc126_);
                                                   _loc73_ = _loc127_ + _loc69_ * (_loc72_ - _loc126_);
                                                   _loc52_ = GameState.particles.addParticles(_loc72_,_loc73_,1,_loc35_,(-_loc126_ + _loc72_) * 0.5,(-_loc127_ + _loc73_) * 0.5,0,0);
                                                   if((Boolean(_loc52_)) && _loc52_.length > 0)
                                                   {
                                                      for each(_loc53_ in _loc52_)
                                                      {
                                                         _loc53_.colour = _loc44_;
                                                      }
                                                   }
                                                   _loc131_--;
                                                }
                                                Vars.objSize = _loc14_;
                                                return null;
                                             }
                                             if(param1 == "las" || param1 == "las2")
                                             {
                                                _loc63_ = new b2Vec2();
                                                _loc64_ = new b2Vec2();
                                                _loc140_ = 800;
                                                _loc23_ = Math.round(Math.random() * param8 - param8 * 0.5);
                                                _loc24_ = Math.round(Math.random() * param8 - param8 * 0.5);
                                                _loc141_ = Math.atan2(param7.y + _loc24_,param7.x + _loc23_);
                                                _loc120_ = 1;
                                                if(!isNaN(_loc15_.triggerForce))
                                                {
                                                   if(!_loc15_.flipped)
                                                   {
                                                      _loc120_ = -1;
                                                   }
                                                   _loc140_ = _loc15_.triggerForce;
                                                   _loc141_ = param9.GetAngle();
                                                }
                                                _loc121_ = new b2Vec2(0,0);
                                                _loc122_ = new b2Vec2(_loc140_ * _loc120_,0);
                                                _loc63_ = BoxUtils.rotateVec(_loc121_,_loc141_);
                                                _loc64_ = BoxUtils.rotateVec(_loc122_,_loc141_);
                                                _loc61_ = param2 * Physics.scale;
                                                _loc62_ = param3 * Physics.scale;
                                                _loc123_ = new b2Vec2(_loc61_ + _loc63_.x,_loc62_ + _loc63_.y);
                                                _loc124_ = new b2Vec2(_loc61_ + _loc64_.x,_loc62_ + _loc64_.y);
                                                GameState.madeby = "laser";
                                                if(param1 == "las2")
                                                {
                                                   GameState.cutter.maxRaycasts = 1;
                                                }
                                                GameState.cutter.CustomCut(_loc123_,_loc124_,1,_loc140_,0);
                                                if(param1 == "las2")
                                                {
                                                   GameState.cutter.maxRaycasts = 64;
                                                }
                                                _loc126_ = _loc123_.x;
                                                _loc127_ = _loc123_.y;
                                                _loc128_ = _loc124_.x;
                                                _loc129_ = _loc124_.y;
                                                _loc69_ = (_loc129_ - _loc127_) / (_loc128_ - _loc126_);
                                                _loc43_ = _loc15_.skin;
                                                _loc44_ = 4288217088;
                                                if(param1 == "las")
                                                {
                                                   if(Boolean(_loc43_) && _loc43_.length > 0)
                                                   {
                                                      _loc44_ = 4278190080 + BoxUtils.getSkinColour(_loc43_,"800000");
                                                   }
                                                }
                                                else
                                                {
                                                   _loc44_ = 4281567201;
                                                   if(Boolean(_loc43_) && _loc43_.length > 0)
                                                   {
                                                      _loc44_ = 4278190080 + BoxUtils.getSkinColour(_loc43_,"3387e1");
                                                   }
                                                }
                                                _loc35_ = "laser";
                                                if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                                                {
                                                   _loc35_ = _loc15_.pfx.getParticle();
                                                }
                                                _loc131_ = 30;
                                                while(_loc131_ > 0)
                                                {
                                                   _loc72_ = _loc126_ + _loc131_ / 30 * (_loc128_ - _loc126_);
                                                   _loc73_ = _loc127_ + _loc69_ * (_loc72_ - _loc126_);
                                                   _loc52_ = GameState.particles.addParticles(_loc72_,_loc73_,1,_loc35_,(-_loc126_ + _loc72_) * 0.5,(-_loc127_ + _loc73_) * 0.5,0,0);
                                                   if((Boolean(_loc52_)) && _loc52_.length > 0)
                                                   {
                                                      for each(_loc53_ in _loc52_)
                                                      {
                                                         _loc53_.colour = _loc44_;
                                                      }
                                                   }
                                                   _loc131_--;
                                                }
                                                Vars.objSize = _loc14_;
                                                return null;
                                             }
                                             if(param1 == "pulse" || param1 == "corrosiveray" || param1 == "foodray")
                                             {
                                                _loc120_ = -1;
                                                if(_loc15_.flipped)
                                                {
                                                   _loc120_ = 1;
                                                }
                                                _loc43_ = _loc15_.skin;
                                                _loc61_ = param2 * Physics.scale;
                                                _loc62_ = param3 * Physics.scale;
                                                _loc121_ = new b2Vec2(0,0);
                                                _loc122_ = new b2Vec2(_loc15_.triggerForce * _loc120_,0);
                                                _loc63_ = BoxUtils.rotateVec(_loc121_,param9.GetAngle());
                                                _loc64_ = BoxUtils.rotateVec(_loc122_,param9.GetAngle());
                                                _loc123_ = new b2Vec2(_loc61_ + _loc63_.x,_loc62_ + _loc63_.y);
                                                _loc124_ = new b2Vec2(_loc61_ + _loc64_.x,_loc62_ + _loc64_.y);
                                                GameState.madeby = "laser";
                                                _loc125_ = GameState.cutter.CustomRaycast(_loc123_,_loc15_.triggerForce,_loc124_);
                                                if(_loc125_[0])
                                                {
                                                   _loc142_ = b2Body(_loc125_[0]).GetUserData();
                                                   if(param1 == "corrosiveray")
                                                   {
                                                      Body.Blight(_loc125_[0],Math.random() * 50 + 10);
                                                      Body.BlightEffect(_loc125_[0],_loc125_[1],"64CC12",_loc15_.skin);
                                                   }
                                                   else if(param1 == "foodray")
                                                   {
                                                      Body.Food(_loc125_[0]);
                                                   }
                                                   else
                                                   {
                                                      if(_loc142_.alive)
                                                      {
                                                         Body.Damage(b2Body(_loc125_[0]),_loc142_.health * 0.5,null,null,null,false);
                                                      }
                                                      _loc142_.trigger = new Bass();
                                                      _loc142_.triggerDuration = 60;
                                                      _loc142_.triggerPos = new b2Vec2(250,250);
                                                      _loc142_.triggered = true;
                                                   }
                                                }
                                                _loc126_ = _loc123_.x;
                                                _loc127_ = _loc123_.y;
                                                _loc128_ = _loc124_.x;
                                                _loc129_ = _loc124_.y;
                                                if(Boolean(_loc125_[0]) && Boolean(_loc125_[1]))
                                                {
                                                   _loc128_ = b2Vec2(_loc125_[1]).x * Physics.scale;
                                                   _loc129_ = b2Vec2(_loc125_[1]).y * Physics.scale;
                                                }
                                                _loc69_ = (_loc129_ - _loc127_) / (_loc128_ - _loc126_);
                                                _loc44_ = 4284901119;
                                                if(param1 == "corrosiveray")
                                                {
                                                   _loc44_ = 4284795922;
                                                   if(Boolean(_loc43_) && _loc43_.length > 0)
                                                   {
                                                      _loc44_ = 4278190080 + BoxUtils.getSkinColour(_loc43_,"64CC12");
                                                   }
                                                }
                                                if(param1 == "foodray")
                                                {
                                                   _loc44_ = 4289235024;
                                                   if(Boolean(_loc43_) && _loc43_.length > 0)
                                                   {
                                                      _loc44_ = 4278190080 + BoxUtils.getSkinColour(_loc43_,"A88850");
                                                   }
                                                }
                                                _loc35_ = "laser";
                                                if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                                                {
                                                   _loc35_ = _loc15_.pfx.getParticle();
                                                }
                                                _loc131_ = 30;
                                                while(_loc131_ > 0)
                                                {
                                                   _loc72_ = _loc126_ + _loc131_ / 30 * (_loc128_ - _loc126_);
                                                   _loc73_ = _loc127_ + _loc69_ * (_loc72_ - _loc126_);
                                                   _loc52_ = GameState.particles.addParticles(_loc72_,_loc73_,1,_loc35_,(-_loc126_ + _loc72_) * 0.5,(-_loc127_ + _loc73_) * 0.5,0,0);
                                                   if((Boolean(_loc52_)) && _loc52_.length > 0)
                                                   {
                                                      for each(_loc53_ in _loc52_)
                                                      {
                                                         _loc53_.colour = _loc44_;
                                                         _loc53_.health = 1200;
                                                         _loc53_.fade = 10;
                                                      }
                                                   }
                                                   _loc131_--;
                                                }
                                                Vars.objSize = _loc14_;
                                                return null;
                                             }
                                             if(param1 == "beam")
                                             {
                                                _loc37_ = Properties.objectProperties("beambullet");
                                                _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                                                userData(_loc12_.GetUserData()).trigger = new BeamBullet();
                                                userData(_loc12_.GetUserData()).triggerForce = 200;
                                                userData(_loc12_.GetUserData()).triggerRadius = 5;
                                                userData(_loc12_.GetUserData()).triggerDuration = 0;
                                                userData(_loc12_.GetUserData()).zerograv = true;
                                                userData(_loc12_.GetUserData()).triggered = true;
                                                userData(_loc12_.GetUserData()).ghost = true;
                                                userData(_loc12_.GetUserData()).skin = _loc15_.skin.slice();
                                                userData(_loc12_.GetUserData()).killOnContact = true;
                                                _loc12_.SetXForm(new b2Vec2(param2,param3),_loc11_);
                                                _loc12_.SetLinearVelocity(param7);
                                                Vars.objSize = _loc14_;
                                                return null;
                                             }
                                             if(param1 == "AA")
                                             {
                                                _loc37_ = Properties.objectProperties("beambullet");
                                                _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                                                userData(_loc12_.GetUserData()).trigger = new BeamBullet();
                                                userData(_loc12_.GetUserData()).triggerForce = 50;
                                                userData(_loc12_.GetUserData()).triggerRadius = 0.1;
                                                userData(_loc12_.GetUserData()).triggerDuration = 10;
                                                userData(_loc12_.GetUserData()).zerograv = true;
                                                userData(_loc12_.GetUserData()).triggered = true;
                                                userData(_loc12_.GetUserData()).skin = _loc15_.skin.slice();
                                                userData(_loc12_.GetUserData()).killOnContact = true;
                                                _loc12_.SetXForm(new b2Vec2(param2,param3),_loc11_);
                                                _loc12_.SetLinearVelocity(param7);
                                                Vars.objSize = _loc14_;
                                                return null;
                                             }
                                             if(param1 == "blaster")
                                             {
                                                _loc37_ = Properties.objectProperties("blasterbullet");
                                                _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                                                userData(_loc12_.GetUserData()).trigger = new BlasterBullet();
                                                userData(_loc12_.GetUserData()).triggerForce = 40;
                                                userData(_loc12_.GetUserData()).zerograv = true;
                                                userData(_loc12_.GetUserData()).triggered = true;
                                                userData(_loc12_.GetUserData()).ghost = true;
                                                userData(_loc12_.GetUserData()).skin = _loc15_.skin.slice();
                                                userData(_loc12_.GetUserData()).killOnContact = true;
                                                _loc12_.SetXForm(new b2Vec2(param2,param3),_loc11_);
                                                _loc12_.SetLinearVelocity(param7);
                                                Vars.objSize = _loc14_;
                                                return null;
                                             }
                                             if(param1 == "blasterbeam")
                                             {
                                                _loc37_ = Properties.objectProperties("blasterbeam");
                                                _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                                                _loc22_ = userData(_loc12_.GetUserData());
                                                _loc22_.trigger = new Disc();
                                                _loc22_.triggerCustom = "damage=5000;burn=50;cuts=false;particleSpread=20;sounds=explosion,explosion2,explosion3,explosion4,explosion5";
                                                _loc22_.triggerRadius = 50;
                                                _loc22_.triggerForce = _loc15_.triggerForce;
                                                _loc22_.triggered = true;
                                                _loc22_.zerograv = true;
                                                _loc22_.triggered = true;
                                                _loc22_.skin = _loc15_.skin.slice();
                                             }
                                             else if(param1 == "blasterbullet")
                                             {
                                                _loc37_ = Properties.objectProperties("blasterbeam");
                                                _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                                                _loc22_ = userData(_loc12_.GetUserData());
                                                _loc22_.trigger = new Disc();
                                                _loc22_.triggerCustom = _loc15_.triggerCustom;
                                                _loc22_.triggerRadius = _loc15_.triggerRadius;
                                                _loc22_.triggerForce = _loc15_.triggerForce;
                                                _loc22_.triggered = true;
                                                _loc22_.zerograv = true;
                                                _loc22_.triggered = true;
                                                _loc22_.skin = _loc15_.skin.slice();
                                             }
                                             else if(param1 == "noi" || param1 == "noisybullet")
                                             {
                                                _loc37_ = Properties.objectProperties("noisybullet");
                                                _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                                                userData(_loc12_.GetUserData()).trigger = new NoisyBullet();
                                                userData(_loc12_.GetUserData()).triggered = true;
                                                userData(_loc12_.GetUserData()).unbreakable = true;
                                             }
                                             else if(param1 == "cry" || param1 == "cryobullet")
                                             {
                                                _loc37_ = Properties.objectProperties("cryobullet");
                                                _loc12_ = Spawn.circle(param2,param3,1,_loc37_,[1,1,1]);
                                                userData(_loc12_.GetUserData()).trigger = new CryoBullet();
                                                userData(_loc12_.GetUserData()).triggered = true;
                                             }
                                             else
                                             {
                                                if(param1 == "magnet")
                                                {
                                                   _loc120_ = 1;
                                                   if(_loc15_.flipped)
                                                   {
                                                      _loc120_ = -1;
                                                   }
                                                   _loc61_ = param2 * Physics.scale;
                                                   _loc62_ = param3 * Physics.scale;
                                                   _loc121_ = new b2Vec2(_loc120_ * (-10 * _loc15_.size),-8 * _loc15_.size);
                                                   _loc122_ = new b2Vec2(_loc120_ * (-10 - 1000 * _loc15_.size),-8 * _loc15_.size);
                                                   _loc63_ = BoxUtils.rotateVec(_loc121_,param9.GetAngle());
                                                   _loc64_ = BoxUtils.rotateVec(_loc122_,param9.GetAngle());
                                                   _loc123_ = new b2Vec2(_loc61_ + _loc63_.x,_loc62_ + _loc63_.y);
                                                   _loc124_ = new b2Vec2(_loc61_ + _loc64_.x,_loc62_ + _loc64_.y);
                                                   _loc65_ = GameState.cutter.CustomRaycast(_loc123_,1000 * _loc15_.size,_loc124_,false);
                                                   if(_loc65_.length > 0)
                                                   {
                                                      _loc66_ = _loc65_[0];
                                                      if(_loc15_.trigger is Gun)
                                                      {
                                                         MagnetGun(Gun(_loc15_.trigger).firearm).target.push(_loc66_);
                                                      }
                                                   }
                                                   _loc43_ = _loc15_.skin;
                                                   _loc44_ = 4291348680;
                                                   if(Boolean(_loc43_) && _loc43_.length > 0)
                                                   {
                                                      _loc44_ = 4278190080 + BoxUtils.getSkinColour(_loc43_,"c8c8c8");
                                                   }
                                                   _loc35_ = "laser";
                                                   if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                                                   {
                                                      _loc35_ = _loc15_.pfx.getParticle();
                                                   }
                                                   _loc143_ = b2Vec2(_loc65_[1]).Copy();
                                                   _loc143_.Multiply(Physics.scale);
                                                   _loc52_ = BoxUtils.randomSlopeParticles(_loc35_,_loc143_,_loc123_,Math.random() * 10 + 10,Math.random() * 2);
                                                   if((Boolean(_loc52_)) && _loc52_.length > 0)
                                                   {
                                                      for each(_loc53_ in _loc52_)
                                                      {
                                                         _loc53_.colour = _loc44_;
                                                      }
                                                   }
                                                   Vars.objSize = _loc14_;
                                                   return null;
                                                }
                                                if(param1 == "dis" || param1 == "shr" || param1 == "gro")
                                                {
                                                   _loc120_ = 1;
                                                   if(_loc15_.flipped)
                                                   {
                                                      _loc120_ = -1;
                                                   }
                                                   _loc61_ = param2 * Physics.scale;
                                                   _loc62_ = param3 * Physics.scale;
                                                   _loc121_ = new b2Vec2(_loc120_ * (-30 * _loc15_.size),-8 * _loc15_.size);
                                                   _loc122_ = new b2Vec2(_loc120_ * (-30 - _loc15_.triggerForce * _loc15_.size),-8 * _loc15_.size);
                                                   _loc63_ = BoxUtils.rotateVec(_loc121_,param9.GetAngle());
                                                   _loc64_ = BoxUtils.rotateVec(_loc122_,param9.GetAngle());
                                                   _loc123_ = new b2Vec2(_loc61_ + _loc63_.x,_loc62_ + _loc63_.y);
                                                   _loc124_ = new b2Vec2(_loc61_ + _loc64_.x,_loc62_ + _loc64_.y);
                                                   _loc65_ = GameState.cutter.CustomRaycast(_loc123_,(_loc15_.triggerForce + 30) * _loc15_.size,_loc124_,false);
                                                   _loc66_ = _loc65_[0];
                                                   _loc43_ = _loc15_.skin;
                                                   if(param1 == "dis")
                                                   {
                                                      _loc44_ = 4293895168;
                                                      if(Boolean(_loc43_) && _loc43_.length > 0)
                                                      {
                                                         _loc44_ = 4278190080 + BoxUtils.getSkinColour(_loc43_,"EFA400");
                                                      }
                                                   }
                                                   else
                                                   {
                                                      _loc44_ = 4281482917;
                                                      if(Boolean(_loc43_) && _loc43_.length > 0)
                                                      {
                                                         _loc44_ = 4278190080 + BoxUtils.getSkinColour(_loc43_,"323EA5");
                                                      }
                                                   }
                                                   _loc126_ = _loc123_.x;
                                                   _loc127_ = _loc123_.y;
                                                   _loc128_ = _loc124_.x;
                                                   _loc129_ = _loc124_.y;
                                                   _loc69_ = (_loc129_ - _loc127_) / (_loc128_ - _loc126_);
                                                   _loc35_ = "laser";
                                                   if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
                                                   {
                                                      _loc35_ = _loc15_.pfx.getParticle();
                                                   }
                                                   _loc131_ = 30;
                                                   while(_loc131_ > 0)
                                                   {
                                                      _loc72_ = _loc126_ + _loc131_ / 30 * (_loc128_ - _loc126_);
                                                      _loc73_ = _loc127_ + _loc69_ * (_loc72_ - _loc126_);
                                                      _loc52_ = GameState.particles.addParticles(_loc72_,_loc73_,1,_loc35_,(-_loc126_ + _loc72_) * 0.5,(-_loc127_ + _loc73_) * 0.5,0,0);
                                                      if((Boolean(_loc52_)) && _loc52_.length > 0)
                                                      {
                                                         for each(_loc53_ in _loc52_)
                                                         {
                                                            _loc53_.colour = _loc44_;
                                                         }
                                                      }
                                                      _loc131_--;
                                                   }
                                                   if(Boolean(_loc66_) && Boolean(!_loc66_.IsStatic()) && _loc66_ != param9)
                                                   {
                                                      if(param1 == "shr")
                                                      {
                                                         Body.Scale(_loc66_,0.75);
                                                      }
                                                      else if(param1 == "gro")
                                                      {
                                                         Body.Scale(_loc66_,1 / 0.75);
                                                      }
                                                      else
                                                      {
                                                         Body.Powder(_loc66_,100,0.5,true);
                                                      }
                                                   }
                                                   Vars.objSize = _loc14_;
                                                   return null;
                                                }
                                                if(O.getItem(param1))
                                                {
                                                   _loc12_ = GameState.objects.delayedSpawnObject(param1,param2 * Physics.scale + Math.random() * 4 - 2,param3 * Physics.scale + Math.random() * 4 - 2,0,_loc15_.flipped,true,_loc15_.skin,param9);
                                                   if(_loc12_)
                                                   {
                                                      userData(_loc12_.GetUserData()).ignored.push(param9);
                                                      userData(_loc12_.GetUserData()).ignore = param1;
                                                   }
                                                   _loc11_ += Vars.PI;
                                                }
                                             }
                                          }
                                       }
                                    }
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
            if(!_loc12_)
            {
               Vars.objSize = _loc14_;
               Vars.objDensity = _loc18_;
               return null;
            }
            _loc22_ = userData(_loc12_.GetUserData());
            if(!_loc12_ || !_loc22_)
            {
               Vars.objSize = _loc14_;
               return null;
            }
            _loc23_ = Math.round(Math.random() * param8 - param8 * 0.5);
            _loc24_ = Math.round(Math.random() * param8 - param8 * 0.5);
            if(param1 == "gun" || param1 == "randomGun")
            {
               _loc11_ += 180 * Vars.toRadians;
            }
            if(param1 == "swo" || param1 == "randomSword")
            {
               _loc11_ += 90 * Vars.toRadians * (_loc15_.flipped ? -1 : 1);
            }
            _loc12_.SetBullet(true);
            _loc25_ = new b2Vec2(_loc23_ + param7.x,_loc24_ + param7.y);
            _loc12_.SetLinearVelocity(_loc25_);
            _loc26_ = userData(_loc12_.GetUserData());
            if(Boolean(_loc15_.pfx) && _loc15_.pfx.replaceDefault)
            {
               _loc26_.pfx = _loc15_.pfx;
            }
            if(!_loc26_.triggerCustom)
            {
               _loc26_.triggerCustom = _loc15_.triggerCustom;
            }
            if(!_loc17_ || _loc17_.bulletProperties.length == 0)
            {
               if(!_loc26_.explosive)
               {
                  _loc26_.explosive = _loc15_.explosive;
               }
               if(!_loc26_.implosive)
               {
                  _loc26_.implosive = _loc15_.implosive;
               }
               if(!_loc26_.sticky)
               {
                  _loc26_.sticky = _loc15_.sticky;
               }
               if(!_loc26_.sharp)
               {
                  _loc26_.sharp = _loc15_.sharp;
               }
               if(!_loc26_.breakable)
               {
                  _loc26_.breakable = _loc15_.breakable;
               }
               if(!_loc26_.crumble)
               {
                  _loc26_.crumble = _loc15_.crumble;
               }
               if(!_loc26_.brittle)
               {
                  _loc26_.brittle = _loc15_.brittle;
               }
               if(!_loc26_.flaming)
               {
                  _loc26_.flaming = _loc15_.flaming;
               }
               if(!_loc26_.freezing)
               {
                  _loc26_.freezing = _loc15_.freezing;
               }
               if(!_loc26_.shocking)
               {
                  _loc26_.shocking = _loc15_.shocking;
               }
               if(!_loc26_.healing)
               {
                  _loc26_.healing = _loc15_.healing;
               }
               if(!_loc26_.killing)
               {
                  _loc26_.killing = _loc15_.killing;
               }
               if(!_loc26_.draining)
               {
                  _loc26_.draining = _loc15_.draining;
               }
               if(!_loc26_.dispelling)
               {
                  _loc26_.dispelling = _loc15_.dispelling;
               }
               if(!_loc26_.poisoning)
               {
                  _loc26_.poisoning = _loc15_.poisoning;
               }
               if(!_loc26_.gusting)
               {
                  _loc26_.gusting = _loc15_.gusting;
               }
               if(!_loc26_.rending)
               {
                  _loc26_.rending = _loc15_.rending;
               }
               if(!_loc26_.alchemying)
               {
                  _loc26_.alchemying = _loc15_.alchemying;
               }
               if(!_loc26_.transmuting)
               {
                  _loc26_.transmuting = _loc15_.transmuting;
               }
               if(!_loc26_.critting)
               {
                  _loc26_.critting = _loc15_.critting;
               }
               if(!_loc26_.deleting)
               {
                  _loc26_.deleting = _loc15_.deleting;
               }
               if(!_loc26_.triggering)
               {
                  _loc26_.triggering = _loc15_.triggering;
               }
               if(!_loc26_.cleaning)
               {
                  _loc26_.cleaning = _loc15_.cleaning;
               }
               if(!_loc26_.janitoring)
               {
                  _loc26_.janitoring = _loc15_.janitoring;
               }
               if(!_loc26_.hyping)
               {
                  _loc26_.hyping = _loc15_.hyping;
               }
               if(!_loc26_.suspending)
               {
                  _loc26_.suspending = _loc15_.suspending;
               }
               if(!_loc26_.banning)
               {
                  _loc26_.banning = _loc15_.banning;
               }
               if(!_loc26_.blighting)
               {
                  _loc26_.blighting = _loc15_.blighting;
               }
               if(!_loc26_.bulletproof)
               {
                  _loc26_.bulletproof = _loc15_.bulletproof;
               }
               if(!_loc26_.cauterizing)
               {
                  _loc26_.cauterizing = _loc15_.cauterizing;
               }
               if(!_loc26_.regenerating)
               {
                  _loc26_.regenerating = _loc15_.regenerating;
               }
               if(!_loc26_.disintegrator)
               {
                  _loc26_.disintegrator = _loc15_.disintegrator;
               }
               if(!_loc26_.disintegrating)
               {
                  _loc26_.disintegrating = _loc15_.disintegrating;
               }
               if(!_loc26_.drying)
               {
                  _loc26_.drying = _loc15_.drying;
               }
               if(!_loc26_.frostfiring)
               {
                  _loc26_.frostfiring = _loc15_.frostfiring;
               }
               if(!_loc26_.frying)
               {
                  _loc26_.frying = _loc15_.frying;
               }
               if(!_loc26_.wetting)
               {
                  _loc26_.wetting = _loc15_.wetting;
               }
               if(!_loc26_.glassing)
               {
                  _loc26_.glassing = _loc15_.glassing;
               }
               if(!_loc26_.glitching)
               {
                  _loc26_.glitching = _loc15_.glitching;
               }
               if(!_loc26_.magnetic)
               {
                  _loc26_.magnetic = _loc15_.magnetic;
               }
               if(!_loc26_.oily)
               {
                  _loc26_.oily = _loc15_.oily;
               }
               if(!_loc26_.petrifying)
               {
                  _loc26_.petrifying = _loc15_.petrifying;
               }
               if(!_loc26_.radioactive)
               {
                  _loc26_.radioactive = _loc15_.radioactive;
               }
               if(!_loc26_.sanguine)
               {
                  _loc26_.sanguine = _loc15_.sanguine;
               }
               if(!_loc26_.scorching)
               {
                  _loc26_.scorching = _loc15_.scorching;
               }
               if(!_loc26_.ultrasharp)
               {
                  _loc26_.ultrasharp = _loc15_.ultrasharp;
               }
               if(!_loc26_.triggerOnCut)
               {
                  _loc26_.triggerOnCut = _loc15_.triggerOnCut;
               }
               if(!_loc26_.warming)
               {
                  _loc26_.warming = _loc15_.warming;
               }
               if(!_loc26_.webbing)
               {
                  _loc26_.webbing = _loc15_.webbing;
               }
               if(!_loc26_.spreading)
               {
                  _loc26_.spreading = _loc15_.spreading;
               }
               if(!_loc26_.concussing)
               {
                  _loc26_.concussing = _loc15_.concussing;
               }
            }
            _loc26_.alpha = _loc15_.alpha;
            if(Boolean(_loc17_) && _loc17_.bulletProperties.length > 0)
            {
               _loc26_.setProperties(_loc17_.bulletProperties.join(","));
            }
            if(Boolean(_loc17_) && _loc26_.inheritSettings)
            {
               if(_loc15_.triggerForce)
               {
                  _loc26_.triggerForce = _loc15_.triggerForce;
               }
               if(_loc15_.triggerRadius)
               {
                  _loc26_.triggerRadius = _loc15_.triggerRadius;
               }
               if(_loc15_.triggerDuration)
               {
                  _loc26_.triggerDuration = _loc15_.triggerDuration;
               }
            }
            _loc26_.group = _loc15_.group;
            _loc26_.layer = _loc15_.layer;
            if(_loc15_.aimhacking && !_loc26_.trigger)
            {
               _loc26_.trigger = new AimArrow();
               AimArrow(_loc26_.trigger).SetVelCap(1000,1000);
               _loc26_.triggerRadius = 600;
               if(_loc15_.triggerRadius)
               {
                  _loc26_.triggerRadius = _loc15_.triggerRadius;
               }
               _loc26_.triggerDuration = 0;
               _loc26_.triggered = true;
               _loc26_.connected = _loc15_.connected.slice();
               _loc144_ = BoxUtils.selectCompound(param9);
               _loc26_.connected.push(param9);
               for each(_loc116_ in _loc144_)
               {
                  _loc26_.connected.push(_loc116_);
               }
               _loc145_ = new PFXCenter(_loc12_);
               _loc145_.attachParticles(1,"shock2");
               _loc26_.pfx = _loc145_;
            }
            if(_loc15_.invisibling && Boolean(_loc26_.graphic))
            {
               _loc26_.graphic.alpha = 0.1;
            }
            _loc26_.saveable = false;
            _loc26_.projectile = true;
            _loc26_.projectileName = param1;
            if(!_loc26_.trigger && param1 != "bb" && param1 != "pot" && param1 != "nai" && param1 != "har" && param1 != "fla" && param1 != "arr" && param1 != "smoke" && param1 != "acid" && param1 != "carBig" && param1 != "teleport" && param1 != "snowball")
            {
               _loc26_.trigger = new Trail();
               _loc26_.triggered = true;
            }
            if(!(_loc22_.trigger is DelayedTeleport))
            {
               if(_loc15_.flipped && param10 != 0 && param10 != 180 && param10 != -180)
               {
                  param10 += 180;
               }
               _loc12_.SetXForm(new b2Vec2(param2,param3),_loc11_ + param10 * Vars.toRadians);
            }
            _loc21_++;
         }
         Vars.objSize = _loc14_;
         Vars.objDensity = _loc18_;
         if(_loc15_.flipped)
         {
            Main.instance.forceFlip = false;
         }
         return _loc12_;
      }
      
      public function doll(param1:Number, param2:Number, param3:Number, param4:Number) : Array
      {
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:Array = null;
         var _loc16_:Array = null;
         var _loc17_:Array = null;
         var _loc18_:Number = NaN;
         var _loc19_:userData = null;
         var _loc20_:int = 0;
         var _loc21_:Array = null;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:int = 0;
         var _loc29_:int = 0;
         var _loc30_:int = 0;
         var _loc31_:int = 0;
         var _loc32_:int = 0;
         var _loc33_:int = 0;
         var _loc34_:Array = null;
         var _loc35_:int = 0;
         var _loc36_:int = 0;
         var _loc37_:Array = null;
         var _loc38_:b2Body = null;
         var _loc39_:userData = null;
         var _loc40_:Array = null;
         var _loc41_:jointUserData = null;
         _loc5_ = [[[-12,-12],[12,-12],[12,12],[-12,12]]];
         _loc6_ = [[[-15,-10],[15,-10],[15,10],[-15,10]]];
         _loc7_ = [[[-18,-6.5],[18,-6.5],[18,6.5],[-18,6.5]]];
         _loc8_ = [[[-17,-6],[17,-6],[17,6],[-17,6]]];
         _loc9_ = [[[-7,-22],[7,-22],[7,22],[-7,22]]];
         _loc10_ = [[[-6,-20],[6,-20],[6,20],[-6,20]]];
         _loc11_ = [_loc5_,_loc9_,_loc9_,_loc10_,_loc10_,_loc6_,_loc6_,_loc6_,_loc7_,_loc7_,_loc8_,_loc8_];
         _loc12_ = ["head","L_thigh","R_thigh","L_calf","R_calf","shoulders","stomach","hips","L_arm","R_arm","L_hand","R_hand"];
         _loc13_ = ["head","leg","leg","foot","foot","body","body","body","arm","arm","hand","hand"];
         _loc14_ = ["FFCC99","113399","113399","113399","113399","A0A0A0","A0A0A0","A0A0A0","999999","999999","999999","999999"];
         _loc15_ = [300,150,150,100,100,200,200,200,125,125,100,100];
         _loc16_ = [new b2Vec2(0,0),new b2Vec2(-10,90),new b2Vec2(10,90),new b2Vec2(-8,125),new b2Vec2(8,125),new b2Vec2(0,28),new b2Vec2(0,43),new b2Vec2(0,58),new b2Vec2(-30,24),new b2Vec2(30,24),new b2Vec2(-57,24),new b2Vec2(57,24)];
         _loc17_ = [];
         _loc20_ = 0;
         while(_loc20_ < 12)
         {
            _loc19_ = Properties.objAlive("doll_" + _loc13_[_loc20_],100);
            _loc37_ = [_loc14_[_loc20_]];
            _loc38_ = this.spawnItem(_loc11_[_loc20_],[1],1,_loc19_,param1 + _loc16_[_loc20_].x * param4,param2 + _loc16_[_loc20_].y * param4,0,_loc37_,"none");
            _loc39_ = userData(_loc38_.GetUserData());
            if(_loc12_[_loc20_] == "head")
            {
               _loc39_.trigger = new Equip();
               _loc39_.triggerState = 0;
            }
            _loc39_.triggerCustom = _loc12_[_loc20_];
            _loc18_ = _loc15_[_loc20_] * param4 * 50;
            _loc39_.maxhealth = _loc18_;
            _loc39_.health = _loc18_;
            _loc39_.saveStains = true;
            _loc17_.push(_loc38_);
            _loc40_ = BoxUtils.bodyDimensions(_loc38_);
            _loc39_.width = _loc40_[0];
            _loc39_.height = _loc40_[1];
            _loc20_++;
         }
         _loc21_ = [];
         _loc22_ = 0;
         _loc23_ = 1;
         _loc24_ = 2;
         _loc25_ = 3;
         _loc26_ = 4;
         _loc27_ = 5;
         _loc28_ = 6;
         _loc29_ = 7;
         _loc30_ = 8;
         _loc31_ = 9;
         _loc32_ = 10;
         _loc33_ = 11;
         _loc34_ = [45000,40000,40000,32000,32000,28000,28000,30000,30000,26000,26000];
         _loc21_.push(Joints.Revolution("rag",_loc17_[_loc22_],_loc17_[_loc27_],param1 + 0 * param4,param2 + 15 * param4,-30,30,false));
         _loc21_.push(Joints.Revolution("rag",_loc17_[_loc27_],_loc17_[_loc28_],param1 + 0 * param4,param2 + 35 * param4,-5,5,false));
         _loc21_.push(Joints.Revolution("rag",_loc17_[_loc28_],_loc17_[_loc29_],param1 + 0 * param4,param2 + 50 * param4,-5,5,false));
         _loc21_.push(Joints.Revolution("rag",_loc17_[_loc29_],_loc17_[_loc23_],param1 + -8 * param4,param2 + 68 * param4,-25,45,false));
         _loc21_.push(Joints.Revolution("rag",_loc17_[_loc29_],_loc17_[_loc24_],param1 + 8 * param4,param2 + 68 * param4,-45,25,false));
         _loc21_.push(Joints.Revolution("rag",_loc17_[_loc23_],_loc17_[_loc25_],param1 + -8 * param4,param2 + 105 * param4,-100,100,false));
         _loc21_.push(Joints.Revolution("rag",_loc17_[_loc24_],_loc17_[_loc26_],param1 + 8 * param4,param2 + 105 * param4,-100,100,false));
         _loc21_.push(Joints.Revolution("rag",_loc17_[_loc27_],_loc17_[_loc30_],param1 + -18 * param4,param2 + 24 * param4,-85,130,false));
         _loc21_.push(Joints.Revolution("rag",_loc17_[_loc27_],_loc17_[_loc31_],param1 + 18 * param4,param2 + 24 * param4,-130,85,false));
         _loc21_.push(Joints.Revolution("rag",_loc17_[_loc30_],_loc17_[_loc32_],param1 + -45 * param4,param2 + 24 * param4,-130,130,false));
         _loc21_.push(Joints.Revolution("rag",_loc17_[_loc31_],_loc17_[_loc33_],param1 + 45 * param4,param2 + 24 * param4,-130,130,false));
         _loc35_ = int(_loc21_.length);
         _loc36_ = 0;
         while(_loc36_ < _loc35_)
         {
            _loc41_ = jointUserData(b2RevoluteJoint(_loc21_[_loc36_]).GetUserData());
            _loc41_.cuttable = false;
            _loc41_.forceLimit = _loc34_[_loc36_] * param4 * param4 * 2;
            _loc41_.defaultFL = _loc41_.forceLimit;
            _loc36_++;
         }
         BoxUtils.rotateAroundPoint(new b2Vec2(param1 / Physics.scale,param2 / Physics.scale),param3,_loc17_);
         ++Main.instance.dollNumber;
         this.Equips(_loc17_[_loc32_]);
         this.Equips(_loc17_[_loc33_]);
         if(GameState.environment is OpenWorld)
         {
            OpenWorld(GameState.environment).head = _loc17_[_loc22_];
            OpenWorld(GameState.environment).stomach = _loc17_[_loc28_];
            OpenWorld(GameState.environment).shoulders = _loc17_[_loc27_];
            OpenWorld(GameState.environment).hips = _loc17_[_loc29_];
            OpenWorld(GameState.environment).arm_L = _loc17_[_loc30_];
            OpenWorld(GameState.environment).arm_R = _loc17_[_loc31_];
            OpenWorld(GameState.environment).foot_R = _loc17_[_loc26_];
            OpenWorld(GameState.environment).foot_L = _loc17_[_loc25_];
            userData(b2Body(_loc17_[_loc22_]).GetUserData()).unbreakable = true;
            userData(b2Body(_loc17_[_loc28_]).GetUserData()).unbreakable = true;
            userData(b2Body(_loc17_[_loc27_]).GetUserData()).unbreakable = true;
            userData(b2Body(_loc17_[_loc29_]).GetUserData()).unbreakable = true;
            userData(b2Body(_loc17_[_loc30_]).GetUserData()).unbreakable = true;
            userData(b2Body(_loc17_[_loc31_]).GetUserData()).unbreakable = true;
            userData(b2Body(_loc17_[_loc26_]).GetUserData()).unbreakable = true;
            userData(b2Body(_loc17_[_loc25_]).GetUserData()).unbreakable = true;
            userData(b2Body(_loc17_[_loc33_]).GetUserData()).unbreakable = true;
            userData(b2Body(_loc17_[_loc32_]).GetUserData()).unbreakable = true;
            userData(b2Body(_loc17_[_loc24_]).GetUserData()).unbreakable = true;
            userData(b2Body(_loc17_[_loc23_]).GetUserData()).unbreakable = true;
            userData(b2Body(_loc17_[_loc22_]).GetUserData()).resistConcuss = true;
            userData(b2Body(_loc17_[_loc25_]).GetUserData()).resistConcuss = true;
            userData(b2Body(_loc17_[_loc26_]).GetUserData()).resistConcuss = true;
            userData(b2Body(_loc17_[_loc25_]).GetUserData()).trigger = new OpenWorldLeg();
            userData(b2Body(_loc17_[_loc26_]).GetUserData()).trigger = new OpenWorldLeg();
         }
         return _loc17_;
      }
      
      public function buffDoll(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc5_:Item = null;
         var _loc6_:Item = null;
         var _loc7_:Item = null;
         var _loc8_:Item = null;
         var _loc9_:Item = null;
         var _loc10_:Item = null;
         var _loc11_:Item = null;
         var _loc12_:Item = null;
         var _loc13_:Vector.<Item> = null;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc16_:* = undefined;
         var _loc17_:* = undefined;
         var _loc18_:Array = null;
         var _loc19_:Vector.<b2Vec2> = null;
         var _loc20_:Array = null;
         var _loc21_:Number = NaN;
         var _loc22_:userData = null;
         var _loc23_:int = 0;
         var _loc24_:Array = null;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:int = 0;
         var _loc29_:int = 0;
         var _loc30_:int = 0;
         var _loc31_:int = 0;
         var _loc32_:int = 0;
         var _loc33_:int = 0;
         var _loc34_:int = 0;
         var _loc35_:int = 0;
         var _loc36_:int = 0;
         var _loc37_:Array = null;
         var _loc38_:int = 0;
         var _loc39_:int = 0;
         var _loc40_:* = undefined;
         var _loc41_:b2Body = null;
         var _loc42_:userData = null;
         var _loc43_:Array = null;
         var _loc44_:jointUserData = null;
         _loc5_ = O.getItem("buffhead");
         _loc6_ = O.getItem("buffchest");
         _loc7_ = O.getItem("bufftorso");
         _loc8_ = O.getItem("buffhips");
         _loc9_ = O.getItem("buffarm");
         _loc10_ = O.getItem("buffhand");
         _loc11_ = O.getItem("buffleg");
         _loc12_ = O.getItem("bufffoot");
         _loc13_ = new Vector.<Item>();
         _loc13_.push(_loc5_);
         _loc13_.push(_loc12_);
         _loc13_.push(_loc12_);
         _loc13_.push(_loc11_);
         _loc13_.push(_loc11_);
         _loc13_.push(_loc7_);
         _loc13_.push(_loc8_);
         _loc13_.push(_loc9_);
         _loc13_.push(_loc9_);
         _loc13_.push(_loc10_);
         _loc13_.push(_loc10_);
         _loc13_.push(_loc6_);
         _loc14_ = ["head","L_calf","R_calf","L_thigh","R_thigh","stomach","hips","L_arm","R_arm","L_hand","R_hand","shoulders"];
         _loc15_ = ["head","foot","foot","leg","leg","body","body","arm","arm","hand","hand","body"];
         _loc16_ = ["head","foot","foot","leg","leg","torso","hips","arm","arm","hand","hand","chest"];
         _loc17_ = [false,true,false,true,false,false,false,true,false,true,false,false];
         _loc18_ = [300,150,150,100,100,200,200,200,125,125,100,100];
         _loc19_ = new Vector.<b2Vec2>();
         _loc19_.push(new b2Vec2(0,0));
         _loc19_.push(new b2Vec2(-16,114));
         _loc19_.push(new b2Vec2(16,114));
         _loc19_.push(new b2Vec2(-17,81));
         _loc19_.push(new b2Vec2(17,81));
         _loc19_.push(new b2Vec2(0,46));
         _loc19_.push(new b2Vec2(0,54));
         _loc19_.push(new b2Vec2(-38,20));
         _loc19_.push(new b2Vec2(34,20));
         _loc19_.push(new b2Vec2(-70,21));
         _loc19_.push(new b2Vec2(68,21));
         _loc19_.push(new b2Vec2(0,22));
         _loc20_ = [];
         _loc23_ = 0;
         while(_loc23_ < 12)
         {
            _loc22_ = Properties.objAlive("doll_" + _loc15_[_loc23_],100);
            _loc22_.saveName = "buff" + _loc16_[_loc23_];
            _loc40_ = _loc13_[_loc23_].vertices;
            if(_loc17_[_loc23_])
            {
               _loc40_ = GeneralUtils.flipArray(_loc40_);
            }
            _loc41_ = this.spawnItem(_loc40_,[1],param4 * _loc13_[_loc23_].scale,_loc22_,param1 + _loc19_[_loc23_].x * param4,param2 + _loc19_[_loc23_].y * param4,0,_loc13_[_loc23_].colours,"none");
            _loc42_ = userData(_loc41_.GetUserData());
            if(_loc14_[_loc23_] == "head")
            {
               _loc42_.trigger = new Equip();
               _loc42_.triggerState = 0;
            }
            _loc21_ = _loc18_[_loc23_] * param4 * 100;
            _loc42_.maxhealth = _loc21_;
            _loc42_.health = _loc21_;
            _loc42_.saveStains = true;
            _loc20_.push(_loc41_);
            _loc43_ = BoxUtils.bodyDimensions(_loc41_);
            _loc42_.width = _loc43_[0];
            _loc42_.height = _loc43_[1];
            _loc23_++;
         }
         _loc24_ = [];
         _loc25_ = 0;
         _loc26_ = 1;
         _loc27_ = 2;
         _loc28_ = 3;
         _loc29_ = 4;
         _loc30_ = 5;
         _loc31_ = 6;
         _loc32_ = 7;
         _loc33_ = 8;
         _loc34_ = 9;
         _loc35_ = 10;
         _loc36_ = 11;
         _loc37_ = [45000,40000,40000,32000,32000,28000,28000,30000,30000,26000,26000];
         _loc24_.push(Joints.Revolution("rag",_loc20_[_loc25_],_loc20_[_loc36_],param1 + 0 * param4,param2 + 15 * param4,-20,20));
         _loc24_.push(Joints.Revolution("rag",_loc20_[_loc36_],_loc20_[_loc30_],param1 + 0 * param4,param2 + 35 * param4,-5,5));
         _loc24_.push(Joints.Revolution("rag",_loc20_[_loc30_],_loc20_[_loc31_],param1 + 0 * param4,param2 + 50 * param4,-5,5));
         _loc24_.push(Joints.Revolution("rag",_loc20_[_loc31_],_loc20_[_loc28_],param1 + -12 * param4,param2 + 64 * param4,-25,45));
         _loc24_.push(Joints.Revolution("rag",_loc20_[_loc31_],_loc20_[_loc29_],param1 + 12 * param4,param2 + 64 * param4,-45,25));
         _loc24_.push(Joints.Revolution("rag",_loc20_[_loc28_],_loc20_[_loc26_],param1 + -16 * param4,param2 + 110 * param4,-100,100));
         _loc24_.push(Joints.Revolution("rag",_loc20_[_loc29_],_loc20_[_loc27_],param1 + 16 * param4,param2 + 110 * param4,-100,100));
         _loc24_.push(Joints.Revolution("rag",_loc20_[_loc36_],_loc20_[_loc32_],param1 + -22 * param4,param2 + 22 * param4,-85,130));
         _loc24_.push(Joints.Revolution("rag",_loc20_[_loc36_],_loc20_[_loc33_],param1 + 22 * param4,param2 + 22 * param4,-130,85));
         _loc24_.push(Joints.Revolution("rag",_loc20_[_loc32_],_loc20_[_loc34_],param1 + -54 * param4,param2 + 22 * param4,-130,10));
         _loc24_.push(Joints.Revolution("rag",_loc20_[_loc33_],_loc20_[_loc35_],param1 + 54 * param4,param2 + 22 * param4,-10,130));
         _loc38_ = int(_loc24_.length);
         _loc39_ = 0;
         while(_loc39_ < _loc38_)
         {
            _loc44_ = jointUserData(b2RevoluteJoint(_loc24_[_loc39_]).GetUserData());
            _loc44_.cuttable = false;
            _loc44_.forceLimit = _loc37_[_loc39_] * param4 * param4 * 2;
            _loc44_.defaultFL = _loc44_.forceLimit;
            _loc39_++;
         }
         BoxUtils.rotateAroundPoint(new b2Vec2(param1 / Physics.scale,param2 / Physics.scale),param3,_loc20_);
         ++Main.instance.dollNumber;
         this.Equips(_loc20_[_loc34_]);
         this.Equips(_loc20_[_loc35_]);
      }
      
      public function Equips(param1:b2Body) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:Array = null;
         var _loc5_:b2Body = null;
         var _loc6_:userData = null;
         var _loc7_:b2Body = null;
         var _loc8_:userData = null;
         var _loc9_:b2Vec2 = null;
         var _loc10_:b2Vec2 = null;
         var _loc11_:Number = NaN;
         var _loc2_:userData = userData(param1.GetUserData());
         _loc3_ = param1.GetPosition().Copy();
         _loc4_ = BoxUtils.selectCompound(param1);
         for each(_loc7_ in _loc4_)
         {
            _loc6_ = userData(_loc7_.GetUserData());
            if(_loc6_.name == "doll_head")
            {
               _loc5_ = _loc7_;
               break;
            }
         }
         if(!_loc5_)
         {
            return;
         }
         _loc8_ = userData(param1.GetUserData());
         _loc8_.trigger = new Equip();
         _loc8_.trigger.init(param1,_loc8_);
         _loc9_ = new b2Vec2(0,-1);
         _loc10_ = new b2Vec2(0,1);
         _loc9_ = BoxUtils.rotateVec(_loc9_,_loc5_.GetAngle());
         _loc10_ = BoxUtils.rotateVec(_loc10_,_loc5_.GetAngle());
         _loc9_.Add(_loc5_.GetPosition());
         _loc10_.Add(_loc5_.GetPosition());
         _loc11_ = GeneralUtils.determinant(_loc9_.x,_loc9_.y,_loc10_.x,_loc10_.y,_loc3_.x,_loc3_.y);
         if(_loc11_ > 0)
         {
            _loc8_.triggerState = -1;
         }
         else
         {
            _loc8_.triggerState = 1;
         }
      }
      
      private function flattenArrays(param1:Array) : Array
      {
         var _loc2_:* = undefined;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:* = undefined;
         _loc2_ = param1;
         _loc3_ = [];
         _loc4_ = int(_loc2_.length);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            for each(_loc6_ in _loc2_[_loc5_])
            {
               _loc3_.push(_loc6_);
            }
            _loc5_++;
         }
         return _loc3_;
      }
   }
}

