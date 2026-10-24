package environment
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class IceHole extends Environment
   {
      
      private var rain:ParticleSystem;
      
      private var randomColour:uint;
      
      public function IceHole()
      {
         super(GameState.width,GameState.height);
         _name = "icehole";
         gravity = 20;
         wind = 0;
         temperature = -20;
         _borderLeft = 150;
         _borderRight = 650;
         _borderTop = 1700;
         spawnX = 400;
         spawnHeight = -1100;
         autoPan = true;
         autoPanOffset = new b2Vec2(0,-900);
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
         _backgroundColour = 14149611;
         _wallColour = 9486802;
         _background = new BitmapData(_width,1200,false);
         enableWalls = false;
         _floor = false;
         _walls = false;
         _wallL = false;
         _wallR = false;
         _roof = false;
         this.setupBackground();
      }
      
      override public function setupBackground() : void
      {
         var _loc1_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Vector.<Array> = null;
         var _loc6_:Item = null;
         var _loc14_:userData = null;
         var _loc16_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:uint = 0;
         var _loc22_:b2Body = null;
         super.setupBackground();
         _loc1_ = 3;
         var _loc2_:Matrix = new Matrix();
         var _loc7_:* = Vars.objFriction;
         var _loc8_:* = Vars.objSize;
         Vars.objFriction = 0.01;
         this.randomColour = GraphicUtils.scalehex(_wallColour,1 + random() * 0.1 - 0.05);
         _loc3_ = _width * 0.5;
         _loc3_ -= 120;
         _loc4_ = 1400;
         _loc1_ = 5;
         _loc5_ = new Vector.<Array>();
         _loc5_.push(["5b3d2b",GraphicUtils.scalehex(this.randomColour,0.95).toString(16)]);
         _loc6_ = O.getItem("trunk");
         var _loc9_:b2Body = GameState.objects.spawnItem(_loc6_.vertices,[0],_loc1_,"treetrunk",-500,-500,0,_loc6_.colours,"none",_loc5_);
         userData(_loc9_.GetUserData()).ghost = true;
         userData(_loc9_.GetUserData()).layer = 0;
         GraphicUtils.addGraphicToLayer(userData(_loc9_.GetUserData()));
         userData(_loc9_.GetUserData()).group = 999;
         _loc9_.SetXForm(new b2Vec2(_loc3_ / Physics.scale,_loc4_ / Physics.scale),0);
         _loc4_ = 1350;
         _loc3_ = 100;
         _loc5_ = new Vector.<Array>();
         _loc5_.push(["5b3d2b",this.randomColour.toString(16)]);
         _loc5_.push(["252525",this.randomColour.toString(16)]);
         var _loc10_:uint = this.randomColour;
         GameState.environmenting = false;
         _loc6_ = O.getItem("treetrunk");
         _loc1_ = 2;
         var _loc11_:b2Body = GameState.objects.spawnItem(_loc6_.vertices,[0],_loc1_ / _loc8_,"treetrunk",_loc3_,_loc4_,-3 * Vars.toRadians,_loc6_.colours,"none",_loc5_.slice());
         _loc3_ = _width - 100;
         var _loc12_:b2Body = GameState.objects.spawnItem(_loc6_.vertices,[0],_loc1_ / _loc8_,"treetrunk",_loc3_,_loc4_,3 * Vars.toRadians,_loc6_.colours,"none",_loc5_.slice());
         _loc1_ = 5;
         _loc3_ = _width * 0.5;
         _loc4_ = 2220;
         _loc6_ = O.getItem("blob");
         var _loc13_:b2Body = GameState.objects.spawnItem(_loc6_.vertices,[0],_loc1_ / _loc8_,"coal",_loc3_,_loc4_,10 * Vars.toRadians,_loc6_.colours,"none",_loc5_.slice());
         GameState.environmenting = true;
         Vars.objFriction = _loc7_;
         Vars.objSize = _loc8_;
         _defaultBodies.push(_loc9_);
         _defaultBodies.push(_loc11_);
         _defaultBodies.push(_loc12_);
         _defaultBodies.push(_loc13_);
         _loc14_ = userData(_loc11_.GetUserData());
         _loc14_.layer = 2;
         GraphicUtils.addGraphicToLayer(_loc14_);
         _loc14_ = userData(_loc12_.GetUserData());
         _loc14_.layer = 2;
         GraphicUtils.addGraphicToLayer(_loc14_);
         var _loc15_:int = clutterDensity * 0.01 * (5 + random() * 20) >> 0;
         _loc16_ = 0;
         while(_loc16_ < _loc15_)
         {
            _loc3_ = random() * _width;
            _loc4_ = random() * 2000 + 400;
            if(_loc3_ > _width * 0.5 && _loc3_ < _width * 0.75)
            {
               _loc3_ += random() * _width * 0.2 + _width * 0.1;
            }
            if(_loc3_ < _width * 0.5 && _loc3_ > _width * 0.25)
            {
               _loc3_ -= random() * _width * 0.2 + _width * 0.1;
            }
            _loc2_ = new Matrix();
            _loc5_ = new Vector.<Array>();
            _loc6_ = O.getItem("icicle");
            _loc1_ = 0.25 + random() * random() * random() * 0.75;
            _loc18_ = (_wallColour >> 16 & 0xFF) + 10;
            _loc19_ = (_wallColour >> 8 & 0xFF) + 10;
            _loc20_ = (_wallColour & 0xFF) + 20;
            if(_loc18_ > 255)
            {
               _loc18_ = 255;
            }
            if(_loc19_ > 255)
            {
               _loc19_ = 255;
            }
            if(_loc20_ > 255)
            {
               _loc20_ = 255;
            }
            if(_loc18_ < 0)
            {
               _loc18_ = 0;
            }
            if(_loc19_ < 0)
            {
               _loc19_ = 0;
            }
            if(_loc20_ < 0)
            {
               _loc20_ = 0;
            }
            _loc21_ = uint(_loc18_ << 16 | _loc19_ << 8 | _loc20_);
            _loc5_ = new Vector.<Array>();
            _loc5_.push(["4abce2",GraphicUtils.scalehex(_loc21_,1 + random() * 0.1).toString(16)]);
            _loc5_.push(["49bbe2",GraphicUtils.scalehex(_loc21_,1 + random() * 0.1).toString(16)]);
            _loc22_ = GameState.objects.spawnItem(_loc6_.vertices,[0],_loc1_,"icicle",-500,-500,0,_loc6_.colours,"none",_loc5_);
            _loc22_.SetXForm(new b2Vec2(_loc3_ / Physics.scale,_loc4_ / Physics.scale),(random() * 120 - 60) * Vars.toRadians);
            if(random() > 0.5)
            {
               userData(_loc22_.GetUserData()).layer = 2;
               GraphicUtils.addGraphicToLayer(userData(_loc22_.GetUserData()));
            }
            _defaultBodies.push(_loc22_);
            _loc16_++;
         }
         var _loc17_:int = 0;
         while(_loc17_ < 20)
         {
            this.rain.addParticles(1,borderLeft + Math.random() * (borderRight + GameState.width * 0.5),Math.random() * 600,0,0,4,4);
            _loc17_++;
         }
         _loc16_ = 0;
         while(_loc16_ < 10)
         {
            this.rain.update(Vars.gravity,Vars.wind,TimeLord.speed);
            _loc16_++;
         }
         setupBackgroundFillerLeft(380,2450,2000,_loc10_);
         setupBackgroundFillerRight(380,2450,2000,_loc10_);
         backgroundDone();
      }
      
      override public function setupWalls() : void
      {
         super.setupWalls();
         updateWalls();
      }
      
      override public function update() : void
      {
         var _loc1_:MyLittleParticle = null;
         if(_particles)
         {
            this.rain.addParticles(1,borderLeft + Math.random() * borderRight,-10 - _height,0,0,4,4);
         }
         for each(_loc1_ in this.rain.holder)
         {
            if(!(_loc1_.x > _width * 0.3 && _loc1_.x < _width * 0.7))
            {
               if(_loc1_.y > -_height + 650)
               {
                  _loc1_.health -= 10;
               }
            }
         }
         super.update();
      }
   }
}

