package environment
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   
   public class Slope extends Environment
   {
      
      private var rain:ParticleSystem;
      
      private var randomColour:uint;
      
      public function Slope()
      {
         super(GameState.width,GameState.height);
         autoPan = true;
         spawnX = -850;
         spawnHeight = 760;
         autoPanOffset = new b2Vec2(0,-900);
         _name = "slope";
         gravity = 20;
         wind = 0;
         temperature = 1;
         _borderLeft = -1600;
         _borderRight = 2700;
         _borderTop = 1200;
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
         _backgroundColour = 11586789;
         _wallColour = 13294579;
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
         var _loc1_:Vector.<Array> = null;
         super.setupBackground();
         var _loc2_:Item = O.getItem("sleddingslope");
         var _loc3_:int = clutterDensity * 0.01 * (3 + random() * 6) >> 0;
         var _loc4_:int = (_wallColour >> 16 & 0xFF) + random() * 10 - 5;
         var _loc5_:int = (_wallColour >> 8 & 0xFF) + random() * 10 - 5;
         var _loc6_:int = (_wallColour & 0xFF) + random() * 10 - 5;
         this.randomColour = uint(_loc4_ << 16 | _loc5_ << 8 | _loc6_);
         _loc1_ = new Vector.<Array>();
         _loc1_.push(["5b3d2b",this.randomColour.toString(16)]);
         _loc1_.push(["d4eaf4",this.randomColour.toString(16)]);
         _loc1_.push(["505050",this.randomColour.toString(16)]);
         var _loc7_:* = Vars.objFriction;
         var _loc8_:* = Vars.objSize;
         Vars.objFriction = 0.1;
         var _loc9_:Number = 4;
         GameState.environmenting = false;
         var _loc10_:int = World.togglePreciseEffects;
         World.togglePreciseEffects = 1;
         var _loc11_:b2Body = GameState.objects.spawnItem(_loc2_.vertices,[0],_loc9_ / _loc8_,"sleddingslope",-8,_height * 0.8,0,_loc2_.colours,"none",_loc1_);
         Vars.objFriction = _loc7_;
         Vars.objSize = _loc8_;
         World.togglePreciseEffects = _loc10_;
         GameState.environmenting = true;
         _defaultBodies.push(_loc11_);
         setupBackgroundFiller(2000,this.randomColour);
         backgroundDone();
      }
      
      override public function setupWalls() : void
      {
         super.setupWalls();
         updateWalls();
      }
      
      override public function update() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:* = undefined;
         if(_particles)
         {
            _loc1_ = Math.random() * (Math.random() * borderRight * 2 + borderLeft);
            _loc2_ = (-50 - Main.instance.cam.y) / Main.instance.cam.scaleX;
            this.rain.addParticles(1,_loc1_,_loc2_,0,0,4,4);
         }
         super.update();
      }
   }
}

