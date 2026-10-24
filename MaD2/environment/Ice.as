package environment
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   
   public class Ice extends Environment
   {
      
      private var rain:ParticleSystem;
      
      public function Ice()
      {
         super(GameState.width,GameState.height);
         _name = "ice";
         gravity = 20;
         wind = 0;
         temperature = -20;
         _borderLeft = -2800;
         _borderRight = 2800;
         _borderTop = 1000;
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
         _backgroundColour = 13235455;
         _wallColour = 12572395;
         _background = new BitmapData(1600,_height,false);
         _walls = false;
         _wallL = false;
         _wallR = false;
         _roof = false;
         this.setupBackground();
      }
      
      override public function setupBackground() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Vector.<Array> = null;
         var _loc6_:Item = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc10_:int = 0;
         var _loc13_:b2Body = null;
         var _loc14_:userData = null;
         var _loc15_:int = 0;
         var _loc16_:uint = 0;
         var _loc17_:Matrix = null;
         super.setupBackground();
         super.setupBackgroundFiller(2000,_wallColour);
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(GraphicUtils.scalehex(_backgroundColour,1.1));
         _loc1_.graphics.drawCircle(650,400,80);
         _background.draw(_loc1_,_loc1_.transform.matrix);
         _loc7_ = 180;
         _loc8_ = 190;
         var _loc9_:int = clutterDensity * 0.01 * (10 + random() * 40) >> 0;
         _loc10_ = 0;
         while(_loc10_ < _loc9_)
         {
            _loc3_ = random() * 2400 - 800;
            _loc4_ = 600;
            if(!Body.GetOne(_loc3_ / Physics.scale,_loc4_ / Physics.scale,true))
            {
               _loc5_ = new Vector.<Array>();
               if(random() > 0.3)
               {
                  _loc6_ = O.getItem("icicle");
                  _loc2_ = 0.25 + random() * random() * (random() * 1.5);
                  _loc4_ -= _loc2_ * 150;
                  _loc7_ = _wallColour >> 16 & 0xFF;
                  _loc8_ = _wallColour >> 8 & 0xFF;
                  _loc15_ = (_wallColour & 0xFF) + 10;
                  if(_loc7_ > 255)
                  {
                     _loc7_ = 255;
                  }
                  if(_loc8_ > 255)
                  {
                     _loc8_ = 255;
                  }
                  if(_loc15_ > 255)
                  {
                     _loc15_ = 255;
                  }
                  if(_loc7_ < 0)
                  {
                     _loc7_ = 0;
                  }
                  if(_loc8_ < 0)
                  {
                     _loc8_ = 0;
                  }
                  if(_loc15_ < 0)
                  {
                     _loc15_ = 0;
                  }
                  _loc16_ = uint(_loc7_ << 16 | _loc8_ << 8 | _loc15_);
                  _loc5_ = new Vector.<Array>();
                  _loc5_.push(["4abce2",GraphicUtils.scalehex(_loc16_,1 + random() * 0.1).toString(16)]);
                  _loc5_.push(["49bbe2",GraphicUtils.scalehex(_loc16_,1 + random() * 0.1).toString(16)]);
               }
               else
               {
                  _loc6_ = O.getItem("coal");
                  _loc2_ = 0.5 + random() * random() * (random() * 2);
                  _loc4_ -= 20 + _loc2_ * 30;
                  _loc7_ = (_wallColour >> 16 & 0xFF) - 10;
                  _loc8_ = (_wallColour >> 8 & 0xFF) - 10;
                  _loc15_ = _wallColour & 0xFF;
                  if(_loc7_ > 255)
                  {
                     _loc7_ = 255;
                  }
                  if(_loc8_ > 255)
                  {
                     _loc8_ = 255;
                  }
                  if(_loc15_ > 255)
                  {
                     _loc15_ = 255;
                  }
                  if(_loc7_ < 0)
                  {
                     _loc7_ = 0;
                  }
                  if(_loc8_ < 0)
                  {
                     _loc8_ = 0;
                  }
                  if(_loc15_ < 0)
                  {
                     _loc15_ = 0;
                  }
                  _loc16_ = uint(_loc7_ << 16 | _loc8_ << 8 | _loc15_);
                  _loc5_ = new Vector.<Array>();
                  _loc5_.push(["252525",GraphicUtils.scalehex(_loc16_,1 + random() * 0.1).toString(16)]);
               }
               _loc13_ = GameState.objects.spawnItem(_loc6_.vertices,[0],_loc2_,"icicle",-500,-500,0,_loc6_.colours,"none",_loc5_);
               _loc14_ = userData(_loc13_.GetUserData());
               _loc14_.group = 999;
               _loc13_.SetXForm(new b2Vec2(_loc3_ / Physics.scale,_loc4_ / Physics.scale),(random() * 120 - 60) * Vars.toRadians);
               _loc14_.layer = random() > 0.2 ? 0 : 2;
               GraphicUtils.addGraphicToLayer(_loc14_);
               _defaultBodies.push(_loc13_);
            }
            _loc10_++;
         }
         var _loc11_:int = 0;
         while(_loc11_ < _loc9_)
         {
            _loc6_ = O.getItem("icicle");
            _loc2_ = 0.2 + random() * random() * (random() * 1);
            _loc3_ = random() * 2400 - 800;
            _loc4_ = 600 - _loc2_ * 150;
            _loc7_ = _wallColour >> 16 & 0xFF;
            _loc8_ = _wallColour >> 8 & 0xFF;
            _loc15_ = (_wallColour & 0xFF) + 10;
            if(_loc7_ > 255)
            {
               _loc7_ = 255;
            }
            if(_loc8_ > 255)
            {
               _loc8_ = 255;
            }
            if(_loc15_ > 255)
            {
               _loc15_ = 255;
            }
            if(_loc7_ < 0)
            {
               _loc7_ = 0;
            }
            if(_loc8_ < 0)
            {
               _loc8_ = 0;
            }
            if(_loc15_ < 0)
            {
               _loc15_ = 0;
            }
            _loc16_ = uint(_loc7_ << 16 | _loc8_ << 8 | _loc15_);
            _loc5_ = new Vector.<Array>();
            _loc5_.push(["4abce2",GraphicUtils.scalehex(_loc16_,1.1 + random() * 0.1).toString(16)]);
            _loc5_.push(["49bbe2",GraphicUtils.scalehex(_loc16_,1.1 + random() * 0.1).toString(16)]);
            _loc13_ = GameState.objects.spawnItem(_loc6_.vertices,[0],_loc2_,"icicle",-500,-500,0,_loc6_.colours,"none",_loc5_);
            _loc17_ = new Matrix();
            _loc17_.scale(_loc2_,_loc2_);
            _loc17_.rotate((random() * 80 - 40) * Vars.toRadians);
            _loc17_.translate(_loc3_,_loc4_);
            _background.draw(userData(_loc13_.GetUserData()).graphic,_loc17_);
            Body.Destroy(_loc13_,"environment");
            _loc11_++;
         }
         var _loc12_:int = 0;
         while(_loc12_ < 20)
         {
            this.rain.addParticles(1,borderLeft + Math.random() * (borderRight + GameState.width * 0.5),Math.random() * 600,0,0,4,4);
            _loc12_++;
         }
         _loc10_ = 0;
         while(_loc10_ < 10)
         {
            this.rain.update(Vars.gravity,Vars.wind,TimeLord.speed);
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
         var _loc1_:Number = NaN;
         var _loc2_:* = undefined;
         if(_particles)
         {
            _loc1_ = GameState.width * 0.5 + Math.random() * (Math.random() * borderRight * 2 + borderLeft);
            _loc2_ = (-50 - Main.instance.cam.y) / Main.instance.cam.scaleX;
            this.rain.addParticles(1,_loc1_,_loc2_,0,0,4,4);
         }
         super.update();
      }
   }
}

