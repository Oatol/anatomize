package environment
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import triggers.SnowBall;
   
   public class Snow extends Environment
   {
      
      private var rain:ParticleSystem;
      
      private var randomColour:uint;
      
      public function Snow()
      {
         super(GameState.width,GameState.height);
         spawnHeight = 220;
         _name = "snow";
         gravity = 20;
         wind = 0;
         temperature = 1;
         _borderLeft = -800;
         _borderRight = 1600;
         this.rain = new ParticleSystem("rain",_width,_height,R.getSprite("p_gas"));
         this.rain.useWorldGravity = false;
         this.rain.particleGravity = 0.5;
         this.rain.particleFade = 1;
         this.rain.particleFadeRandom = 10;
         this.rain.particleHealth = 1000;
         this.rain.particleRestitution = 0;
         this.rain.particleFriction = 0.9;
         this.rain.particleWander = 0.5;
         _particleSystems.push(this.rain);
         _backgroundColour = 10269650;
         _wallColour = 12899563;
         _background = new BitmapData(_width,_height,false);
         _scrollBG = false;
         _walls = false;
         _wallL = false;
         _wallR = false;
         _roof = false;
         _floor = false;
         this.setupBackground();
      }
      
      override public function setupBackground() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Vector.<Array> = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:Matrix = null;
         var _loc17_:b2Body = null;
         super.setupBackground();
         var _loc1_:Number = 1;
         var _loc5_:Item = O.getItem("treetrunk");
         var _loc6_:Item = O.getItem("slipperyslope");
         var _loc7_:int = clutterDensity * 0.01 * (3 + random() * 6) >> 0;
         _loc3_ = 0;
         _loc2_ = _width * 0.5;
         _loc8_ = (_wallColour >> 16 & 0xFF) + random() * 10 - 5;
         _loc9_ = (_wallColour >> 8 & 0xFF) + random() * 10 - 5;
         _loc10_ = (_wallColour & 0xFF) + random() * 10 - 5;
         this.randomColour = uint(_loc8_ << 16 | _loc9_ << 8 | _loc10_);
         _loc4_ = new Vector.<Array>();
         _loc4_.push(["5b3d2b",this.randomColour.toString(16)]);
         _loc4_.push(["d4eaf4",this.randomColour.toString(16)]);
         _loc3_ = _height;
         var _loc11_:* = Vars.objFriction;
         Vars.objFriction = 0.1;
         var _loc12_:b2Body = GameState.objects.spawnItem(_loc5_.vertices,[0],_loc1_,"treetrunk",_width * 0.5,_loc3_,90 * Vars.toRadians,_loc5_.colours,"none",_loc4_);
         var _loc13_:b2Body = GameState.objects.spawnItem(_loc6_.vertices,[0],2.5 + random() * 2.5,"slope",-_width * (0.5 + random() * 0.5) + _loc6_.width,_height * 0.9,0,_loc6_.colours,"none",_loc4_);
         var _loc14_:b2Body = GameState.objects.spawnItem(GeneralUtils.flipArray(_loc6_.vertices),[0],2.5 + random() * 2.5,"slope",_width * (1.5 + random() * 0.5) - _loc6_.width,_height * 0.9,0,_loc6_.colours,"none",_loc4_);
         Vars.objFriction = _loc11_;
         _defaultBodies.push(_loc12_);
         _defaultBodies.push(_loc13_);
         _defaultBodies.push(_loc14_);
         _loc15_ = 0;
         while(_loc15_ < _loc7_)
         {
            _loc1_ = 0.1 + random() * random() * random() * 0.5;
            _loc2_ = random() * _width * 2 - _width * 0.5;
            _loc3_ = b2Vec2(GameState.cutter.CustomRaycast(new b2Vec2(_loc2_,200),500,new b2Vec2(_loc2_,1000),false,"laser")[1]).y * Physics.scale;
            _loc3_ -= _loc1_ * 60;
            _loc16_ = new Matrix();
            _loc4_ = new Vector.<Array>();
            _loc5_ = O.getItem("snowball");
            _loc8_ = 60 + random() * 10 - 5;
            _loc9_ = 55 + random() * 10 - 5;
            _loc10_ = 50 + random() * 10 - 5;
            _loc4_.push(["d4eaf4",GraphicUtils.scalehex(this.randomColour,1 + random() * 0.05 - 0.1).toString(16)]);
            _loc17_ = GameState.objects.spawnItem(_loc5_.vertices,[0.5],_loc1_,"snowball",_loc2_,_loc3_,0,_loc5_.colours,"none",_loc4_);
            userData(_loc17_.GetUserData()).saveable = false;
            userData(_loc17_.GetUserData()).trigger = new SnowBall();
            userData(_loc17_.GetUserData()).triggerRadius = 100;
            userData(_loc17_.GetUserData()).triggerCollide = 1200 * _loc1_;
            _defaultBodies.push(_loc17_);
            _loc15_++;
         }
         _loc15_ = 0;
         while(_loc15_ < random() * 20)
         {
            _loc4_ = new Vector.<Array>();
            _loc8_ = 16;
            _loc9_ = 78 + random() * 20 - 10;
            _loc10_ = 23;
            _loc4_.push(["BEE8F7",GraphicUtils.scalehex(12511479,1 + random() * 0.2 - 0.1).toString(16)]);
            _loc1_ = 0.4 + random() * 0.4 - 0.2;
            _loc2_ = random() * 2400 + 200;
            _loc3_ = random() * 100 + 100 + _loc1_ * 50;
            _loc5_ = O.getItem("cloud");
            _loc17_ = GameState.objects.spawnItem(_loc5_.vertices,[0],_loc1_,"cloud",_loc2_,_loc3_,0,_loc5_.colours,"none",_loc4_);
            _loc16_ = new Matrix();
            _loc16_.rotate((random() * 360 - 720) * Vars.toRadians);
            _loc16_.translate(_loc2_,_loc3_);
            _background.draw(userData(_loc17_.GetUserData()).graphic,_loc16_);
            Body.Destroy(_loc17_,"environment");
            _loc15_++;
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
         if(_particles)
         {
            this.rain.addParticles(1,borderLeft + Math.random() * (borderRight + GameState.width * 0.5),-Math.random() * 10,0,0,4,4);
         }
         super.update();
      }
   }
}

