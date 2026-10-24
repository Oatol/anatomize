package environment
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class Fire extends Environment
   {
      
      private var rain:ParticleSystem;
      
      private var rain2:ParticleSystem;
      
      public function Fire()
      {
         super(GameState.width,GameState.height);
         _name = "fire";
         gravity = 20;
         wind = 0;
         temperature = 80;
         _borderLeft = -2800;
         _borderRight = 2800;
         _roof = false;
         _walls = false;
         _wallL = false;
         _wallR = false;
         this.rain = new ParticleSystem("rain",_width,_height,R.getSprite("p_fireyellow"));
         this.rain2 = new ParticleSystem("rain2",_width,_height,R.getSprite("p_smoke"));
         this.rain.useWorldGravity = false;
         this.rain.particleGravity = 1;
         this.rain.particleFade = 1;
         this.rain.particleFadeRandom = 10;
         this.rain.particleHealth = 1000;
         this.rain.particleWander = 0.2;
         this.rain2.useWorldGravity = false;
         this.rain2.particleGravity = 0.5;
         this.rain2.particleFade = 1;
         this.rain2.particleFadeRandom = 10;
         this.rain2.particleHealth = 1000;
         this.rain2.particleRestitution = 0;
         this.rain2.particleFriction = 0.9;
         this.rain2.particleWander = 1;
         _particleSystems.push(this.rain);
         _particleSystems.push(this.rain2);
         _backgroundColour = 3679006;
         _wallColour = 3682608;
         _background = new BitmapData(1600,_height,false);
         this.setupBackground();
      }
      
      override public function setupBackground() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Vector.<Array> = null;
         var _loc5_:Item = null;
         var _loc6_:int = 0;
         var _loc7_:b2Body = null;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         super.setupBackground();
         _loc2_ = -_width;
         _loc6_ = 0;
         while(_loc6_ < 24)
         {
            _loc4_ = new Vector.<Array>();
            _loc5_ = O.getItem("coal");
            _loc1_ = 0.5 + random() * random() * (random() * 1 - 0.5);
            _loc2_ = random() * (random() * borderRight * 2 + borderLeft);
            _loc3_ = 600 - (20 + _loc1_ * 30);
            _loc11_ = 30 + random() * 20;
            _loc12_ = _loc11_ - random() * 20;
            _loc4_.push(["252525",uint(_loc11_ << 16 | _loc12_ << 8 | _loc12_).toString(16)]);
            _loc7_ = GameState.objects.spawnItem(_loc5_.vertices,[0],_loc1_,"coal",-500,-500,0,_loc5_.colours,"none",_loc4_);
            userData(_loc7_.GetUserData()).ghost = true;
            _loc7_.SetXForm(new b2Vec2(_loc2_ / Physics.scale,_loc3_ / Physics.scale),(random() * 720 - 360) * Vars.toRadians);
            if(random() > 0.9)
            {
               userData(_loc7_.GetUserData()).layer = 2;
            }
            else
            {
               userData(_loc7_.GetUserData()).layer = 0;
            }
            GraphicUtils.addGraphicToLayer(userData(_loc7_.GetUserData()));
            _defaultBodies.push(_loc7_);
            _loc6_++;
         }
         _loc4_ = new Vector.<Array>();
         _loc4_.push(["285F0C",GraphicUtils.scalehex(_wallColour,0.95).toString(16)]);
         _loc2_ = 600;
         _loc3_ = 550;
         _loc1_ = 8;
         _loc5_ = O.getItem("minivolcano");
         _loc7_ = GameState.objects.spawnItem(_loc5_.vertices,[0],_loc1_,"coal",_loc2_,_loc3_,0,_loc5_.colours,"none",_loc4_);
         var _loc8_:Matrix = new Matrix();
         _loc8_.rotate(_loc7_.GetAngle());
         _loc8_.translate(_loc7_.GetPosition().x * Physics.scale,_loc7_.GetPosition().y * Physics.scale);
         _background.draw(userData(_loc7_.GetUserData()).graphic,_loc8_);
         Body.Destroy(_loc7_,"environment");
         _loc10_ = 0;
         while(_loc10_ < 50)
         {
            _loc9_ = Math.random() * (Math.random() * borderRight * 2 + borderLeft);
            this.rain.addParticles(1,_loc9_,Math.random() * 600,0,0,4,4);
            _loc10_++;
         }
         _loc6_ = 0;
         while(_loc6_ < 10)
         {
            this.rain.update(Vars.gravity,Vars.wind,TimeLord.speed);
            _loc6_++;
         }
         _loc10_ = 0;
         while(_loc10_ < 50)
         {
            _loc9_ = Math.random() * (Math.random() * borderRight * 2 + borderLeft);
            this.rain2.addParticles(1,_loc9_,Math.random() * 600,0,0,4,4);
            _loc10_++;
         }
         _loc6_ = 0;
         while(_loc6_ < 10)
         {
            this.rain2.update(Vars.gravity,Vars.wind,TimeLord.speed);
            _loc6_++;
         }
         setupBackgroundFiller(2000,_wallColour);
         backgroundDone();
      }
      
      override public function setupWalls() : void
      {
         var _loc1_:b2Body = null;
         super.setupWalls();
         updateWalls();
         for each(_loc1_ in _wallBodies)
         {
            userData(_loc1_.GetUserData()).conductivity = 0.02;
            userData(_loc1_.GetUserData()).ignition = 9000;
            userData(_loc1_.GetUserData()).temperature = 120;
         }
      }
      
      override public function update() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:Number = NaN;
         var _loc3_:* = undefined;
         if(_particles)
         {
            _loc2_ = Math.random() * (Math.random() * borderRight * 2 + borderLeft);
            _loc3_ = (-50 - Main.instance.cam.y) / Main.instance.cam.scaleX;
            if(Math.random() > 0.5)
            {
               this.rain.addParticles(1,_loc2_,_loc3_,0,0,4,4);
            }
            _loc2_ = Math.random() * (Math.random() * borderRight * 2 + borderLeft);
            this.rain2.addParticles(1,_loc2_,_loc3_,0,0,4,4);
            _loc2_ = Math.random() * (Math.random() * borderRight * 2 + borderLeft);
            this.rain2.addParticles(1,_loc2_,_loc3_,0,0,4,4);
         }
         for each(_loc1_ in _wallBodies)
         {
            if(userData(_loc1_.GetUserData()).temperature < 120)
            {
               ++userData(_loc1_.GetUserData()).temperature;
            }
         }
         super.update();
      }
   }
}

