package environment
{
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class Sky extends Environment
   {
      
      private var rain:ParticleSystem;
      
      public function Sky()
      {
         super(GameState.width,GameState.height);
         _name = "sky";
         spawnHeight = 300;
         gravity = 20;
         wind = 0;
         temperature = 10;
         autoWind = true;
         enableFiller = false;
         enableWalls = false;
         _borderTop = 1200;
         _borderLeft = -2000;
         _borderRight = 2000;
         this.rain = new ParticleSystem("rain",_width,_height,R.getSprite("p_water"));
         this.rain.useWorldGravity = false;
         this.rain.particleGravity = 2;
         this.rain.particleFade = 1;
         this.rain.particleFadeRandom = 10;
         this.rain.particleHealth = 1000;
         this.rain.particleRestitution = 0;
         this.rain.particleFriction = 0.9;
         this.rain.particleWander = 0.2;
         _particleSystems.push(this.rain);
         _backgroundColour = 26316;
         _wallColour = 12511479;
         _background = new BitmapData(_width,_borderTop,false);
         _walls = false;
         _wallL = false;
         _wallR = false;
         _roof = false;
         _floor = false;
         this.setupBackground();
         windDir = 1;
         windForce = 2;
         windCap = 10;
      }
      
      override public function setupBackground() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Vector.<Array> = null;
         var _loc6_:Item = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:b2Body = null;
         super.setupBackground();
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(15330246);
         _loc1_.graphics.drawCircle(_width * 0.5 * random() + 100,100 + random() * 100,100);
         _background.draw(_loc1_,_loc1_.transform.matrix);
         var _loc7_:int = 220;
         var _loc8_:int = 220;
         var _loc9_:int = clutterDensity * 0.01 * (8 + random() * 12) >> 0;
         _loc10_ = 0;
         while(_loc10_ < _loc9_)
         {
            _loc2_ = 0.2 + random() * 0.4;
            if(random() > 0.5)
            {
               _loc3_ = random() * _width * 0.2;
            }
            else
            {
               _loc3_ = _width * 0.8 + random() * _width * 0.2;
            }
            if(random() > 0.3)
            {
               _loc4_ = random() * 100 + 500;
            }
            else
            {
               _loc4_ = random() * _height;
            }
            if(!Body.GetOne(_loc3_ / Physics.scale,_loc4_ / Physics.scale,true))
            {
               _loc5_ = new Vector.<Array>();
               _loc6_ = O.getItem("cloud");
               _loc4_ -= _loc2_ * 150;
               _loc11_ = 230 + random() * 25;
               _loc5_.push(["BEE8F7",uint(_loc11_ << 16 | _loc11_ << 8 | _loc11_).toString(16)]);
               _loc12_ = GameState.objects.spawnItem(_loc6_.vertices,[0],_loc2_,"cloud",_loc3_,_loc4_,0,_loc6_.colours,"none",_loc5_);
               _defaultBodies.push(_loc12_);
            }
            _loc10_++;
         }
         _loc10_ = 0;
         while(_loc10_ < _loc9_)
         {
            _loc2_ = 0.2 + random() * 0.4;
            _loc3_ = random() * 2500 - 1250;
            _loc4_ = random() * 2500 - 1250;
            if(!Body.GetOne(_loc3_ / Physics.scale,_loc4_ / Physics.scale,true))
            {
               _loc5_ = new Vector.<Array>();
               _loc6_ = O.getItem("cloud");
               _loc4_ -= _loc2_ * 150;
               _loc11_ = 230 + random() * 25;
               _loc5_.push(["BEE8F7",uint(_loc11_ << 16 | _loc11_ << 8 | _loc11_).toString(16)]);
               _loc12_ = GameState.objects.spawnItem(_loc6_.vertices,[0],_loc2_,"cloud",_loc3_,_loc4_,0,_loc6_.colours,"none",_loc5_);
               _defaultBodies.push(_loc12_);
            }
            _loc10_++;
         }
         backgroundDone();
      }
      
      override public function setupWalls() : void
      {
         super.setupWalls();
         updateWalls();
      }
      
      override public function update() : void
      {
         var _loc1_:b2Body = null;
         if(_particles)
         {
            for each(_loc1_ in _defaultBodies)
            {
               if(Math.random() > 0.99)
               {
                  this.rain.addParticles(1,userData(_loc1_.GetUserData()).size * (Math.random() * 300 - 150) + _loc1_.GetPosition().x * Physics.scale,_loc1_.GetPosition().y * Physics.scale,0,0,4,4);
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

