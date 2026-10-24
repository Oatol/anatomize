package environment
{
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import triggers.PoisonBullet;
   
   public class Poison extends Environment
   {
      
      private var rain:ParticleSystem;
      
      private var randomColour:uint;
      
      public function Poison()
      {
         super(GameState.width,GameState.height);
         spawnHeight = 252;
         _name = "poison";
         gravity = 20;
         wind = 0;
         temperature = 20;
         autoWind = false;
         _borderLeft = -2800;
         _borderRight = 2800;
         this.rain = new ParticleSystem("rain",_width,_height,R.getSprite("p_poisongas"));
         this.rain.useWorldGravity = false;
         this.rain.particleGravity = 0.05;
         this.rain.particleFade = 1;
         this.rain.particleFadeRandom = 2;
         this.rain.particleHealth = 1000;
         this.rain.particleRestitution = 0;
         this.rain.particleFriction = 0.99;
         this.rain.particleWander = 0;
         this.rain.particleCollide = false;
         _particleSystems.push(this.rain);
         _backgroundColour = 5929506;
         _wallColour = 7185683;
         _background = new BitmapData(1600,1000,false);
         _walls = false;
         _wallL = false;
         _wallR = false;
         _roof = false;
         _floor = true;
         this.setupBackground();
      }
      
      override public function setupBackground() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Vector.<Array> = null;
         var _loc5_:Item = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc12_:Number = NaN;
         var _loc13_:Matrix = null;
         var _loc14_:b2Body = null;
         var _loc15_:uint = 0;
         super.setupBackground();
         var _loc1_:Number = 2;
         var _loc6_:int = clutterDensity * 0.05 * (8 + random() * 12) >> 0;
         _loc3_ = _height;
         _loc2_ = _width * 0.5;
         _loc7_ = (_wallColour >> 16 & 0xFF) + random() * 10 - 5;
         _loc8_ = (_wallColour >> 8 & 0xFF) + random() * 10 - 5;
         _loc9_ = (_wallColour & 0xFF) + random() * 10 - 5;
         if(_loc7_ > 255)
         {
            _loc7_ = 255;
         }
         if(_loc8_ > 255)
         {
            _loc8_ = 255;
         }
         if(_loc9_ > 255)
         {
            _loc9_ = 255;
         }
         if(_loc7_ < 0)
         {
            _loc7_ = 0;
         }
         if(_loc8_ < 0)
         {
            _loc8_ = 0;
         }
         if(_loc9_ < 0)
         {
            _loc9_ = 0;
         }
         this.randomColour = uint(_loc7_ << 16 | _loc8_ << 8 | _loc9_);
         var _loc10_:int = 0;
         for(; _loc10_ < _loc6_; _loc10_++)
         {
            _loc12_ = random();
            if(_loc12_ > 0.4)
            {
               _loc1_ = 0.1 + random() * random() * 0.2;
               _loc2_ = borderLeft + random() * borderRight * 2;
               _loc3_ = _height - 10;
               if(Body.GetOne(_loc2_,_loc3_))
               {
                  continue;
               }
               Main.instance.forceFlip = random() > 0.5;
               _loc13_ = new Matrix();
               _loc4_ = new Vector.<Array>();
               _loc5_ = O.getItem("hexadecagon");
               _loc4_.push(["505050",GraphicUtils.scalehex(this.randomColour,1 + random() * 0.05 - 0.1).toString(16)]);
               _loc14_ = GameState.objects.spawnItem(_loc5_.vertices,[0],_loc1_,"snowpile2",_loc2_,_loc3_,(random() * 6 - 3) * Vars.toRadians,_loc5_.colours,"none",_loc4_);
               _defaultBodies.push(_loc14_);
            }
            else
            {
               _loc1_ = 0.04 + random() * random() * 0.16;
               _loc2_ = borderLeft + random() * borderRight * 2;
               _loc3_ = _height - 30 - random() * 20 * _loc1_;
               if(Body.GetOne(_loc2_,_loc3_))
               {
                  continue;
               }
               Main.instance.forceFlip = random() > 0.5;
               _loc13_ = new Matrix();
               _loc4_ = new Vector.<Array>();
               _loc5_ = O.getItem("amanita2");
               _loc4_.push(["faf9d8",GraphicUtils.scalehex(this.randomColour,1 + random() * 0.1 - 0.2).toString(16)]);
               _loc4_.push(["bdbba1",GraphicUtils.scalehex(this.randomColour,1 + random() * 0.1).toString(16)]);
               _loc4_.push(["dcdab9",GraphicUtils.scalehex(this.randomColour,1 + random() * 0.2).toString(16)]);
               _loc4_.push(["edebc9",GraphicUtils.scalehex(this.randomColour,1 + random() * 0.1 - 0.1).toString(16)]);
               _loc4_.push(["842119",GraphicUtils.scalehex(this.randomColour,1 + random() * 0.1).toString(16)]);
               _loc14_ = GameState.objects.spawnItem(_loc5_.vertices,[0],_loc1_,"amanita",_loc2_,_loc3_,(random() * 20 - 10) * Vars.toRadians,_loc5_.colours,"none",_loc4_);
               userData(_loc14_.GetUserData()).trigger = new PoisonBullet();
               userData(_loc14_.GetUserData()).triggerContact = 100;
               userData(_loc14_.GetUserData()).triggerRadius = 45 * _loc1_ * 25;
               userData(_loc14_.GetUserData()).triggerDuration = 40 * _loc1_ * 20;
               _defaultBodies.push(_loc14_);
            }
            if(random() > 0.7)
            {
               userData(_loc14_.GetUserData()).layer = 2;
            }
            else
            {
               userData(_loc14_.GetUserData()).layer = 0;
            }
            GraphicUtils.addGraphicToLayer(userData(_loc14_.GetUserData()));
         }
         var _loc11_:int = 0;
         while(_loc11_ < _loc6_ * 0.25)
         {
            _loc5_ = O.getItem("blob");
            _loc1_ = 0.5 + random() * random() * (random() * 2);
            _loc2_ = random() * 1000 + 150 * _loc1_;
            _loc3_ = 600 - _loc1_ * 50;
            _loc7_ = _wallColour >> 16 & 0xFF;
            _loc8_ = _wallColour >> 8 & 0xFF;
            _loc9_ = (_wallColour & 0xFF) + 10;
            if(_loc7_ > 255)
            {
               _loc7_ = 255;
            }
            if(_loc8_ > 255)
            {
               _loc8_ = 255;
            }
            if(_loc9_ > 255)
            {
               _loc9_ = 255;
            }
            if(_loc7_ < 0)
            {
               _loc7_ = 0;
            }
            if(_loc8_ < 0)
            {
               _loc8_ = 0;
            }
            if(_loc9_ < 0)
            {
               _loc9_ = 0;
            }
            _loc15_ = uint(_loc7_ << 16 | _loc8_ << 8 | _loc9_);
            _loc4_ = new Vector.<Array>();
            _loc4_.push(["252525",GraphicUtils.scalehex(_loc15_,0.6 + random() * 0.2 - 0.1).toString(16)]);
            _loc14_ = GameState.objects.spawnItem(_loc5_.vertices,[0],_loc1_,"icicle",-500,-500,0,_loc5_.colours,"none",_loc4_);
            _loc13_ = new Matrix();
            _loc13_.scale(_loc1_,_loc1_);
            _loc13_.rotate((random() * 80 - 40) * Vars.toRadians);
            _loc13_.translate(_loc2_,_loc3_);
            _background.draw(userData(_loc14_.GetUserData()).graphic,_loc13_);
            Body.Destroy(_loc14_,"environment");
            _loc11_++;
         }
         setupBackgroundFiller(2000,_wallColour);
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
         this.setupBackground();
      }
      
      override public function update() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Vector.<MyLittleParticle> = null;
         var _loc3_:b2Body = null;
         var _loc4_:int = 0;
         if(_particles && Math.random() > 0.9)
         {
            _loc1_ = Math.random() * (Math.random() * borderRight * 2 + borderLeft);
            _loc2_ = this.rain.addParticles(1,_loc1_,_height - Math.random() * 10 - 10,0,-1.5,0.5,0.5);
            if(_loc2_[0])
            {
               _loc2_[0].friction = 0.99;
               _loc2_[0].wanderX = 0.5;
               _loc2_[0].wanderY = 0.01;
            }
            if(Math.random() > 0.9)
            {
               for each(_loc3_ in _defaultBodies)
               {
                  if(Math.random() >= 0.99)
                  {
                     _loc4_ = 0;
                     while(_loc4_ < Math.random() * 10 + 2)
                     {
                        _loc2_ = this.rain.addParticles(1,userData(_loc3_.GetUserData()).size * (Math.random() * 40 - 20) + _loc3_.GetPosition().x * Physics.scale,_loc3_.GetPosition().y * Physics.scale,0,-20,12,10);
                        if(_loc2_[0])
                        {
                           _loc2_[0].friction = 0.8;
                           _loc2_[0].wanderX = 2;
                           _loc2_[0].wanderY = 1;
                        }
                        _loc4_++;
                     }
                  }
               }
            }
         }
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

