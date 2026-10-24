package environment
{
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class Sand extends Environment
   {
      
      private var sandstorm:ParticleSystem;
      
      public function Sand()
      {
         super(GameState.width,GameState.height);
         _name = "desert";
         gravity = 20;
         wind = 0;
         temperature = 42;
         autoWind = true;
         _borderTop = 2000;
         _borderLeft = -2800;
         _borderRight = 2800;
         this.sandstorm = new ParticleSystem("sandstorm",_width,_height,R.getSprite("p_sand"));
         this.sandstorm.useWorldGravity = false;
         this.sandstorm.particleFade = 1;
         this.sandstorm.particleFadeRandom = 10;
         this.sandstorm.particleHealth = 1000;
         this.sandstorm.particleRestitution = 0.5;
         this.sandstorm.particleFriction = 0.9;
         this.sandstorm.particleWander = 0.4;
         this.sandstorm.particleCollide = false;
         _particleSystems.push(this.sandstorm);
         _backgroundColour = 8697570;
         _wallColour = 15060574;
         _background = new BitmapData(_width * 2,_height,false);
         _walls = false;
         _wallL = false;
         _wallR = false;
         _roof = false;
         this.setupBackground();
      }
      
      override public function setupBackground() : void
      {
         var _loc4_:Number = NaN;
         super.setupBackground();
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16763904);
         _loc1_.graphics.drawCircle(400,100,100);
         _background.draw(_loc1_,_loc1_.transform.matrix);
         var _loc2_:int = 0;
         while(_loc2_ < 60)
         {
            _loc4_ = GameState.width * 0.5 + Math.random() * (Math.random() * borderRight * 2 + borderLeft);
            this.sandstorm.addParticles(1,_loc4_,_height - Math.random() * 10,wind,-2,4,4);
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(_loc3_ < 10)
         {
            this.sandstorm.update(Vars.gravity,Vars.wind,TimeLord.speed);
            _loc3_++;
         }
         this.initItems();
         setupBackgroundFiller(2000,_wallColour);
         backgroundDone();
      }
      
      private function initItems() : void
      {
         var _loc1_:Item = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Vector.<Array> = null;
         var _loc10_:Boolean = false;
         var _loc11_:b2Body = null;
         var _loc12_:userData = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:uint = 0;
         var _loc6_:int = clutterDensity * 0.01 * (5 + random() * 20) >> 0;
         var _loc7_:Number = _width * -0.5;
         var _loc8_:Number = _width * 1.5;
         var _loc9_:int = 0;
         while(_loc9_ < _loc6_)
         {
            _loc5_ = new Vector.<Array>();
            _loc3_ = random() * _loc8_ * 2 + _loc7_ * 2;
            _loc10_ = false;
            if(random() > 0.95)
            {
               _loc1_ = O.getItem("palmtree");
               _loc2_ = 0.6 + random() * random() * random();
               _loc4_ = _height - _loc2_ * 375;
               random();
            }
            else
            {
               _loc1_ = O.getItem("coal");
               _loc2_ = 0.2 + random() * random() * (random() * 2 - 1);
               _loc4_ = _height - random() * (20 + _loc2_ * 30);
               _loc13_ = (_wallColour >> 16 & 0xFF) - 10;
               _loc14_ = (_wallColour >> 8 & 0xFF) - 10;
               _loc15_ = (_wallColour & 0xFF) - 10;
               if(_loc13_ > 255)
               {
                  _loc13_ = 255;
               }
               if(_loc14_ > 255)
               {
                  _loc14_ = 255;
               }
               if(_loc15_ > 255)
               {
                  _loc15_ = 255;
               }
               if(_loc13_ < 0)
               {
                  _loc13_ = 0;
               }
               if(_loc14_ < 0)
               {
                  _loc14_ = 0;
               }
               if(_loc15_ < 0)
               {
                  _loc15_ = 0;
               }
               _loc16_ = uint(_loc13_ << 16 | _loc14_ << 8 | _loc15_);
               _loc5_ = new Vector.<Array>();
               _loc5_.push(["252525",GraphicUtils.scalehex(_loc16_,1 + random() * 0.2 - 0.1).toString(16)]);
               _loc10_ = true;
               random();
            }
            _loc11_ = GameState.objects.spawnItem(_loc1_.vertices,[0],_loc2_,Properties.objBurn("sandclutter"),_loc3_,_loc4_,0,_loc1_.colours,"none",_loc5_);
            _loc12_ = userData(_loc11_.GetUserData());
            random();
            if(!_loc10_)
            {
               _loc12_.layer = seed > 116640 ? 0 : 2;
               _loc12_.group = 999;
            }
            GraphicUtils.addGraphicToLayer(_loc12_);
            _defaultBodies.push(_loc11_);
            _loc9_++;
         }
      }
      
      override public function setupWalls() : void
      {
         super.setupWalls();
         updateWalls();
      }
      
      override public function update() : void
      {
         var _loc1_:Number = NaN;
         if(_particles)
         {
            _loc1_ = Math.random() * (Math.random() * borderRight * 2 + borderLeft);
            this.sandstorm.addParticles(1,_loc1_,_height - Math.random() * 10,wind,-2,4,4);
         }
         super.update();
      }
   }
}

