package environment
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class Jungle extends Environment
   {
      
      private var rain:ParticleSystem;
      
      public function Jungle()
      {
         super(GameState.width,GameState.height);
         _name = "jungle";
         gravity = 20;
         wind = 0;
         temperature = 10;
         autoWind = false;
         _borderLeft = -2800;
         _borderRight = 2800;
         _borderTop = 1200;
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
         _backgroundColour = 6389892;
         _wallColour = 5401870;
         _background = new BitmapData(_width,_borderTop,false);
         _walls = false;
         _wallL = false;
         _wallR = false;
         _roof = false;
         enableParticles = false;
         this.setupBackground();
      }
      
      override public function setupBackground() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Vector.<Array> = null;
         var _loc5_:Item = null;
         var _loc12_:Boolean = false;
         var _loc13_:Matrix = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:b2Body = null;
         var _loc18_:Number = NaN;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:Vector.<b2Body> = null;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:b2Body = null;
         var _loc26_:int = 0;
         var _loc27_:* = undefined;
         var _loc28_:userData = null;
         var _loc29_:b2Vec2 = null;
         super.setupBackground();
         random();
         random();
         var _loc1_:Number = 1.2;
         var _loc6_:int = clutterDensity * 0.01 * (8 + random() * 12) >> 0;
         _loc5_ = O.getItem("treetrunk");
         _loc3_ = 0;
         _loc2_ = 0;
         var _loc7_:b2Body = GameState.objects.spawnItem(_loc5_.vertices,[0],_loc1_,"treetrunk",-500,-500,0,_loc5_.colours,"none");
         _loc7_.SetXForm(new b2Vec2(_loc2_ / Physics.scale,_loc3_ / Physics.scale),0);
         userData(_loc7_.GetUserData()).ghost = true;
         userData(_loc7_.GetUserData()).layer = 0;
         GraphicUtils.addGraphicToLayer(userData(_loc7_.GetUserData()));
         _loc2_ = _width;
         var _loc8_:b2Body = GameState.objects.spawnItem(_loc5_.vertices,[0],_loc1_,"treetrunk",-500,-500,0,_loc5_.colours,"none");
         userData(_loc8_.GetUserData()).ghost = true;
         _loc8_.SetXForm(new b2Vec2(_loc2_ / Physics.scale,_loc3_ / Physics.scale),0);
         userData(_loc8_.GetUserData()).layer = 0;
         GraphicUtils.addGraphicToLayer(userData(_loc8_.GetUserData()));
         _defaultBodies.push(_loc7_);
         _defaultBodies.push(_loc8_);
         var _loc9_:int = 0;
         while(_loc9_ < 6)
         {
            _loc1_ = 0.6 + random() * 0.4;
            _loc12_ = Main.instance.forceFlip;
            _loc2_ = -_width * 0.3 + _width * _loc9_ * 0.3;
            _loc3_ = -_height + random() * 50;
            _loc13_ = new Matrix();
            _loc4_ = new Vector.<Array>();
            _loc5_ = O.getItem("leaves");
            _loc14_ = 140 + random() * 20 - 10;
            _loc15_ = 170 + random() * 20 - 10;
            _loc16_ = 40 + random() * 20 - 10;
            _loc4_.push(["8aaa25",uint(_loc14_ << 16 | _loc15_ << 8 | _loc16_).toString(16)]);
            _loc17_ = GameState.objects.spawnItem(_loc5_.vertices,[0],_loc1_,"leaves",_loc2_,_loc3_,(random() * 60 - 30) * Vars.toRadians,_loc5_.colours,"none",_loc4_);
            userData(_loc17_.GetUserData()).ghost = true;
            _defaultBodies.push(_loc17_);
            Main.instance.forceFlip = _loc12_;
            _loc9_++;
         }
         var _loc10_:int = 0;
         while(_loc10_ < _loc6_)
         {
            _loc18_ = random();
            if(_loc18_ > 0.7)
            {
               _loc1_ = 0.2 + random() * 0.2;
               if(random() > 0.5)
               {
                  Main.instance.forceFlip = false;
                  _loc2_ = _width - random() * _width * 0.3;
               }
               else
               {
                  Main.instance.forceFlip = true;
                  _loc2_ = random() * _width * 0.3;
               }
               _loc3_ = _height - random() * 60 * _loc1_;
               _loc13_ = new Matrix();
               _loc4_ = new Vector.<Array>();
               _loc5_ = O.getItem("spikybush");
               _loc3_ -= _loc1_ * 150;
               _loc19_ = 60 + random() * 20 - 10;
               _loc20_ = 90 + random() * 20 - 10;
               _loc21_ = 40 + random() * 20 - 10;
               _loc14_ = 90 + random() * 40 - 20;
               _loc15_ = 60 + random() * 40 - 20;
               _loc16_ = 40 + random() * 40 - 20;
               _loc4_.push(["5b3d2b",uint(_loc14_ << 16 | _loc15_ << 8 | _loc16_).toString(16)]);
               _loc4_.push(["38592a",uint(_loc19_ << 16 | _loc20_ << 8 | _loc21_).toString(16)]);
               _loc17_ = GameState.objects.spawnItem(_loc5_.vertices,[0],_loc1_,"spikybush",_loc2_,_loc3_,(random() * 60 - 30) * Vars.toRadians,_loc5_.colours,"none",_loc4_);
               _defaultBodies.push(_loc17_);
            }
            else if(_loc18_ > 0.3)
            {
               _loc1_ = 0.3 + random() * 0.2;
               _loc12_ = Main.instance.forceFlip;
               if(random() > 0.5)
               {
                  Main.instance.forceFlip = false;
                  _loc2_ = _width - 180 * (_loc1_ / 0.5) + random() * 50 * (_loc1_ / 0.5);
               }
               else
               {
                  Main.instance.forceFlip = true;
                  _loc2_ = 180 * (_loc1_ / 0.5) + random() * -50 * (_loc1_ / 0.5);
               }
               _loc3_ = -_height * 0.5 + random() * _height;
               _loc13_ = new Matrix();
               _loc4_ = new Vector.<Array>();
               _loc5_ = O.getItem("branch");
               _loc14_ = 90 + random() * 20 - 10;
               _loc15_ = 60 + random() * 20 - 10;
               _loc16_ = 40 + random() * 20 - 10;
               _loc4_.push(["5b3d2b",uint(_loc14_ << 16 | _loc15_ << 8 | _loc16_).toString(16)]);
               _loc17_ = GameState.objects.spawnItem(_loc5_.vertices,[0],_loc1_,"branch",_loc2_,_loc3_,(random() * 60 - 30) * Vars.toRadians,_loc5_.colours,"none",_loc4_);
               _defaultBodies.push(_loc17_);
               Main.instance.forceFlip = _loc12_;
            }
            else
            {
               _loc22_ = new Vector.<b2Body>();
               _loc23_ = 5;
               _loc24_ = random() * 150;
               if(Math.random() > 0.5)
               {
                  _loc2_ = _width * 0.8 - random() * _width * 0.3;
               }
               else
               {
                  _loc2_ = _width * 0.2 + random() * _width * 0.3;
               }
               _loc3_ = -_height + 200 + random() * 50;
               _loc26_ = 0;
               while(_loc26_ < _loc23_)
               {
                  _loc27_ = "8aaa25";
                  _loc28_ = Properties.objectProperties(_loc27_);
                  _loc29_ = BoxUtils.rotateVec(new b2Vec2(0,-(_loc23_ * _loc24_ * 0.5) + _loc26_ * _loc24_),0);
                  _loc25_ = Spawn.circle(_loc2_ + _loc29_.x,_loc3_ + _loc29_.y,2,_loc28_,[_loc26_ == 0 ? 0 : 2,1,1]);
                  if(_loc25_)
                  {
                     userData(_loc25_.GetUserData()).sticky = true;
                     _loc22_.push(_loc25_);
                     _defaultBodies.push(_loc25_);
                  }
                  _loc26_++;
               }
               _loc26_ = 0;
               while(_loc26_ < _loc22_.length - 1)
               {
                  Joints.Distance("vinejoint",_loc22_[_loc26_],_loc22_[_loc26_ + 1],_loc22_[_loc26_].GetPosition(),_loc22_[_loc26_ + 1].GetPosition(),10,1.9);
                  _loc26_++;
               }
            }
            _loc10_++;
         }
         var _loc11_:int = 0;
         while(_loc11_ < 10)
         {
            _loc1_ = 0.3 + random() * 0.2;
            _loc12_ = Main.instance.forceFlip;
            if(random() > 0.5)
            {
               Main.instance.forceFlip = true;
               _loc2_ = _width + 150 * (_loc1_ / 0.5) + random() * 50 * (_loc1_ / 0.5);
            }
            else
            {
               Main.instance.forceFlip = false;
               _loc2_ = -100 * (_loc1_ / 0.5) + random() * -50 * (_loc1_ / 0.5);
            }
            _loc3_ = -_height * 0.5 + random() * _height;
            _loc13_ = new Matrix();
            _loc4_ = new Vector.<Array>();
            _loc5_ = O.getItem("branch");
            _loc14_ = 90 + random() * 20 - 10;
            _loc15_ = 60 + random() * 20 - 10;
            _loc16_ = 40 + random() * 20 - 10;
            _loc4_.push(["5b3d2b",uint(_loc14_ << 16 | _loc15_ << 8 | _loc16_).toString(16)]);
            _loc17_ = GameState.objects.spawnItem(_loc5_.vertices,[0],_loc1_,"branch",_loc2_,_loc3_,(random() * 60 - 30) * Vars.toRadians,_loc5_.colours,"none",_loc4_);
            _defaultBodies.push(_loc17_);
            Main.instance.forceFlip = _loc12_;
            _loc11_++;
         }
         setupBackgroundFiller(1000,_wallColour);
         backgroundDone();
      }
      
      override public function setupWalls() : void
      {
         super.setupWalls();
         updateWalls();
      }
      
      override public function update() : void
      {
         if(autoWind)
         {
            wind += windDir * (Math.random() * windForce - windForce * 0.5);
            if(wind > windCap || wind < -windCap)
            {
               wind = windDir * windCap;
               windDir *= -1;
            }
            Vars.wind = wind;
         }
         super.update();
      }
   }
}

