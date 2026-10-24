package environment
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class Cave extends Environment
   {
      
      private var rain:ParticleSystem;
      
      private var randomColour:uint;
      
      public function Cave()
      {
         super(GameState.width,GameState.height);
         spawnHeight = 252;
         _name = "cave";
         gravity = 20;
         wind = 0;
         temperature = 20;
         autoWind = false;
         enableWalls = false;
         _borderLeft = -2800;
         _borderRight = 2800;
         this.rain = new ParticleSystem("rain",_width,_height,R.getSprite("p_gas"));
         this.rain.useWorldGravity = false;
         this.rain.particleGravity = 0.5;
         this.rain.particleFade = 1;
         this.rain.particleFadeRandom = 10;
         this.rain.particleHealth = 1000;
         this.rain.particleRestitution = 0;
         this.rain.particleFriction = 0.9;
         this.rain.particleWander = 0.2;
         _particleSystems.push(this.rain);
         _backgroundColour = 2169881;
         _wallColour = 4799798;
         _background = new BitmapData(_width * 2,_height,false);
         _walls = false;
         _wallL = false;
         _wallR = false;
         _roof = false;
         _floor = false;
         enableParticles = false;
         enableWind = false;
         this.setupBackground();
      }
      
      override public function setupBackground() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Vector.<Array> = null;
         var _loc5_:Item = null;
         var _loc16_:Number = NaN;
         var _loc17_:Matrix = null;
         var _loc18_:b2Body = null;
         var _loc19_:b2Vec2 = null;
         var _loc20_:Bitmap = null;
         super.setupBackground();
         var _loc1_:Number = 2;
         var _loc6_:int = clutterDensity * 0.01 * (8 + random() * 12) >> 0;
         _loc5_ = O.getItem("treetrunk");
         _loc3_ = 0;
         _loc2_ = 0;
         this.randomColour = _wallColour;
         _loc4_ = new Vector.<Array>();
         _loc4_.push(["5b3d2b",this.randomColour.toString(16)]);
         var _loc7_:b2Body = GameState.objects.spawnItem(_loc5_.vertices,[0],_loc1_,"treetrunk",_loc2_,_loc3_,90 * Vars.toRadians,_loc5_.colours,"none",_loc4_);
         _loc3_ = _height;
         var _loc8_:b2Body = GameState.objects.spawnItem(_loc5_.vertices,[0],_loc1_,"treetrunk",_loc2_,_loc3_,90 * Vars.toRadians,_loc5_.colours,"none",_loc4_);
         _loc3_ = 0;
         _loc2_ = 1920;
         var _loc9_:b2Body = GameState.objects.spawnItem(_loc5_.vertices,[0],_loc1_,"treetrunk",_loc2_,_loc3_,90 * Vars.toRadians,_loc5_.colours,"none",_loc4_);
         _loc3_ = _height;
         var _loc10_:b2Body = GameState.objects.spawnItem(_loc5_.vertices,[0],_loc1_,"treetrunk",_loc2_,_loc3_,90 * Vars.toRadians,_loc5_.colours,"none",_loc4_);
         _loc3_ = 0;
         _loc2_ = -1910;
         var _loc11_:b2Body = GameState.objects.spawnItem(_loc5_.vertices,[0],_loc1_,"treetrunk",_loc2_,_loc3_,90 * Vars.toRadians,_loc5_.colours,"none",_loc4_);
         _loc3_ = _height;
         var _loc12_:b2Body = GameState.objects.spawnItem(_loc5_.vertices,[0],_loc1_,"treetrunk",_loc2_,_loc3_,90 * Vars.toRadians,_loc5_.colours,"none",_loc4_);
         userData(_loc7_.GetUserData()).layer = 2;
         userData(_loc8_.GetUserData()).layer = 2;
         userData(_loc9_.GetUserData()).layer = 2;
         userData(_loc10_.GetUserData()).layer = 2;
         userData(_loc11_.GetUserData()).layer = 2;
         userData(_loc12_.GetUserData()).layer = 2;
         GraphicUtils.addGraphicToLayer(userData(_loc7_.GetUserData()));
         GraphicUtils.addGraphicToLayer(userData(_loc8_.GetUserData()));
         GraphicUtils.addGraphicToLayer(userData(_loc9_.GetUserData()));
         GraphicUtils.addGraphicToLayer(userData(_loc10_.GetUserData()));
         GraphicUtils.addGraphicToLayer(userData(_loc11_.GetUserData()));
         GraphicUtils.addGraphicToLayer(userData(_loc12_.GetUserData()));
         _defaultBodies.push(_loc7_);
         _defaultBodies.push(_loc8_);
         _defaultBodies.push(_loc9_);
         _defaultBodies.push(_loc10_);
         _defaultBodies.push(_loc11_);
         _defaultBodies.push(_loc12_);
         var _loc13_:int = 0;
         while(_loc13_ < _loc6_)
         {
            _loc16_ = random();
            if(_loc16_ > 0.8)
            {
               _loc1_ = 0.2 + random() * random() * 0.4;
               _loc2_ = random() * _width * 2 - _width * 0.5;
               _loc3_ = 100 + random() * 100 * _loc1_;
               if(!Body.GetOne(_loc2_,_loc3_))
               {
                  Main.instance.forceFlip = random() > 0.5;
                  _loc17_ = new Matrix();
                  _loc4_ = new Vector.<Array>();
                  _loc5_ = O.getItem("stalactite");
                  _loc4_.push(["372b23",GraphicUtils.scalehex(this.randomColour,1 + random() * 0.05 - 0.1).toString(16)]);
                  _loc4_.push(["33261e",GraphicUtils.scalehex(this.randomColour,1 + random() * 0.1 - 0.2).toString(16)]);
                  _loc18_ = GameState.objects.spawnItem(_loc5_.vertices,[0],_loc1_,"stalagmite",_loc2_,_loc3_,(random() * 20 - 10) * Vars.toRadians,_loc5_.colours,"none",_loc4_);
                  _defaultBodies.push(_loc18_);
               }
            }
            else if(_loc16_ > 0.6)
            {
               _loc1_ = 0.2 + random() * random() * 0.4;
               _loc2_ = random() * _width * 2 - _width * 0.5;
               _loc3_ = _height - 80 - random() * 100 * _loc1_;
               if(!Body.GetOne(_loc2_,_loc3_))
               {
                  Main.instance.forceFlip = random() > 0.5;
                  _loc17_ = new Matrix();
                  _loc4_ = new Vector.<Array>();
                  _loc5_ = O.getItem("stalagmite");
                  _loc4_.push(["372b23",GraphicUtils.scalehex(this.randomColour,1 + random() * 0.05 - 0.1).toString(16)]);
                  _loc4_.push(["33261e",GraphicUtils.scalehex(this.randomColour,1 + random() * 0.1 - 0.2).toString(16)]);
                  _loc18_ = GameState.objects.spawnItem(_loc5_.vertices,[0],_loc1_,"stalagmite",_loc2_,_loc3_,(random() * 20 - 10) * Vars.toRadians,_loc5_.colours,"none",_loc4_);
                  _defaultBodies.push(_loc18_);
               }
            }
            else
            {
               _loc1_ = 0.1 + random() * random() * 0.2;
               _loc2_ = _width * 2 * random();
               _loc3_ = _height - random() * 360 * _loc1_;
               _loc17_ = new Matrix();
               _loc4_ = new Vector.<Array>();
               _loc5_ = O.getItem("coal");
               _loc4_.push(["252525",GraphicUtils.scalehex(this.randomColour,1 + random() * 0.2 - 0.1).toString(16)]);
               _loc18_ = GameState.objects.spawnItem(_loc5_.vertices,[0],_loc1_,"coal",_loc2_,_loc3_,(random() * 120 - 60) * Vars.toRadians,_loc5_.colours,"none",_loc4_);
               _loc19_ = _loc7_.GetLocalPoint(_loc7_.GetWorldCenter()).Copy();
               _loc19_.Multiply(Physics.scale);
               _loc20_ = Bitmap(userData(_loc7_.GetUserData()).graphic.getChildByName("effects"));
               if(_loc20_)
               {
                  _loc19_.x -= _loc20_.x;
                  _loc19_.y -= _loc20_.y;
               }
               _loc17_ = new Matrix();
               _loc17_.rotate((random() * 60 - 30) * Vars.toRadians);
               if(random() > 0.5)
               {
                  _loc17_.translate(_loc19_.x + random() * 100,_loc19_.y + random() * _width * 2 - _width * 0.5);
                  if(_loc20_)
                  {
                     BoxUtils.getEffectBMD(_loc7_).draw(userData(_loc18_.GetUserData()).graphic,_loc17_);
                  }
               }
               else
               {
                  _loc17_.translate(_loc19_.x - random() * 100,_loc19_.y + random() * _width * 2 - _width * 0.5);
                  if(_loc20_)
                  {
                     BoxUtils.getEffectBMD(_loc8_).draw(userData(_loc18_.GetUserData()).graphic,_loc17_);
                  }
               }
               Body.Destroy(_loc18_,"environment");
            }
            _loc13_++;
         }
         var _loc14_:int = 0;
         while(_loc14_ < _loc6_ * 0.5)
         {
            _loc1_ = 0.2 + random() * random() * 0.4;
            _loc2_ = borderLeft + random() * (borderRight + GameState.width * 0.5);
            _loc3_ = 100 + random() * 100 * _loc1_;
            if(!Body.GetOne(_loc2_,_loc3_))
            {
               Main.instance.forceFlip = random() > 0.5;
               _loc17_ = new Matrix();
               _loc4_ = new Vector.<Array>();
               _loc5_ = O.getItem("stalactite");
               _loc4_.push(["372b23",GraphicUtils.scalehex(this.randomColour,1 + random() * 0.05 - 0.1).toString(16)]);
               _loc4_.push(["33261e",GraphicUtils.scalehex(this.randomColour,1 + random() * 0.1 - 0.2).toString(16)]);
               _loc18_ = GameState.objects.spawnItem(_loc5_.vertices,[0],_loc1_,"stalagmite",_loc2_,_loc3_,(random() * 20 - 10) * Vars.toRadians,_loc5_.colours,"none",_loc4_);
               _defaultBodies.push(_loc18_);
            }
            _loc14_++;
         }
         var _loc15_:int = 0;
         while(_loc15_ < _loc6_ * 0.5)
         {
            _loc1_ = 0.2 + random() * random() * 0.4;
            _loc2_ = borderLeft + random() * (borderRight + GameState.width * 0.5);
            _loc3_ = _height - 80 - random() * 100 * _loc1_;
            if(!Body.GetOne(_loc2_,_loc3_))
            {
               Main.instance.forceFlip = random() > 0.5;
               _loc17_ = new Matrix();
               _loc4_ = new Vector.<Array>();
               _loc5_ = O.getItem("stalagmite");
               _loc4_.push(["372b23",GraphicUtils.scalehex(this.randomColour,1 + random() * 0.05 - 0.1).toString(16)]);
               _loc4_.push(["33261e",GraphicUtils.scalehex(this.randomColour,1 + random() * 0.1 - 0.2).toString(16)]);
               _loc18_ = GameState.objects.spawnItem(_loc5_.vertices,[0],_loc1_,"stalagmite",_loc2_,_loc3_,(random() * 20 - 10) * Vars.toRadians,_loc5_.colours,"none",_loc4_);
               _defaultBodies.push(_loc18_);
            }
            _loc15_++;
         }
         setupBackgroundFiller(1000,_wallColour);
         setupBackgroundFillerTop(1000,_wallColour);
         backgroundDone();
      }
      
      override public function setupWalls() : void
      {
         super.setupWalls();
         this.updateWalls();
      }
      
      override public function updateWalls() : void
      {
         super.updateWalls();
         seed = Vars.seed;
      }
   }
}

