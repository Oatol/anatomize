package environment
{
   import Box2D.Collision.Shapes.b2PolygonDef;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import flash.display.BitmapData;
   
   public class Environment
   {
      
      private var _gravity:Number;
      
      private var _wind:Number;
      
      private var _temperature:Number;
      
      protected var _borderLeft:Number;
      
      protected var _borderRight:Number;
      
      protected var _borderTop:Number;
      
      protected var _borderBottom:Number;
      
      protected var _background:BitmapData;
      
      protected var _backgroundColour:uint;
      
      protected var _wallColour:uint;
      
      protected var _wallBodies:Vector.<b2Body> = new Vector.<b2Body>();
      
      protected var _defaultBodies:Vector.<b2Body> = new Vector.<b2Body>();
      
      protected var _particleSystems:Vector.<ParticleSystem> = new Vector.<ParticleSystem>();
      
      protected var _width:Number;
      
      protected var _height:Number;
      
      protected var _name:String;
      
      protected var wallThickness:Number = 16;
      
      protected var _walls:Boolean;
      
      protected var _wallL:Boolean;
      
      protected var _wallR:Boolean;
      
      protected var _floor:Boolean;
      
      protected var _roof:Boolean;
      
      protected var _particles:Boolean;
      
      protected var _scrollBG:Boolean = true;
      
      protected var _loop:Boolean = false;
      
      protected var _autoWind:Boolean = false;
      
      private var _filler:Boolean = true;
      
      public var enableFiller:Boolean = true;
      
      public var enableWind:Boolean = true;
      
      public var enableParticles:Boolean = true;
      
      public var enableClutter:Boolean = true;
      
      public var enableSeed:Boolean = true;
      
      public var enableWalls:Boolean = true;
      
      public var enableBackground:Boolean = true;
      
      public var seed:Number = 42;
      
      public var clutterDensity:Number = 100;
      
      public var spawnX:Number = 400;
      
      public var spawnHeight:Number = 162;
      
      public var backgroundGore:Boolean = false;
      
      public var wallStains:Boolean = true;
      
      public var autoPan:Boolean = false;
      
      public var autoPanOffset:b2Vec2 = new b2Vec2();
      
      protected var windDir:int = 1;
      
      public var windForce:int = 1;
      
      protected var windCap:int = 50;
      
      protected var _contentName:String;
      
      protected var _loadContent:String;
      
      protected var _minPan:b2Vec2 = new b2Vec2(-3200,-3200);
      
      protected var _maxPan:b2Vec2 = new b2Vec2(3200,3200);
      
      protected var _minScale:Number = 0.25;
      
      public function Environment(param1:Number, param2:Number)
      {
         super();
         this._width = param1;
         this._height = param2;
         this._borderLeft = 0;
         this._borderRight = this._width;
         this._borderTop = this._height;
         this._temperature = 20;
         this._wind = 0;
         this._gravity = 20;
         this._floor = true;
         this._roof = true;
         this._walls = false;
         this._particles = true;
         this._wallL = true;
         this._wallR = true;
         this.spawnX = GameState.width * 0.5;
      }
      
      public function random() : Number
      {
         this.seed = (this.seed * 9301 + 49297) % 233280;
         return this.seed / 233280;
      }
      
      public function update() : void
      {
         var _loc1_:ParticleSystem = null;
         for each(_loc1_ in this._particleSystems)
         {
            if(_loc1_.particles != 0)
            {
               _loc1_.update(Vars.gravity,Vars.wind,TimeLord.speed);
            }
         }
         if(this._autoWind)
         {
            this.wind += this.windDir * (Math.random() * this.windForce - this.windForce * 0.5);
            if(this.wind > this.windCap || this.wind < -this.windCap)
            {
               this.wind = this.windDir * this.windCap;
               this.windDir *= -1;
            }
            if(Math.random() > 0.995)
            {
               this.windDir *= -1;
            }
            Vars.wind = this.wind;
         }
      }
      
      public function updateWalls() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:* = undefined;
         for each(_loc1_ in this._wallBodies)
         {
            Body.Destroy(_loc1_,"modifying walls",true);
         }
         this._wallBodies = new Vector.<b2Body>();
         _loc2_ = new Vector.<Array>();
         _loc2_.push(["777777",this._wallColour.toString(16)]);
         if(this._floor)
         {
            this._wallBodies.push(Spawn.Walls("d",1,0.2,this.wallThickness,_loc2_,this.wallStains));
         }
         if(this._wallL)
         {
            this._wallBodies.push(Spawn.Walls("l",1,0.2,this.wallThickness,_loc2_,this.wallStains));
         }
         if(this._wallR)
         {
            this._wallBodies.push(Spawn.Walls("r",1,0.2,this.wallThickness,_loc2_,this.wallStains));
         }
         if(this._walls)
         {
            this._wallBodies.push(Spawn.Walls("l",1,0.2,this.wallThickness,_loc2_,this.wallStains));
            this._wallBodies.push(Spawn.Walls("r",1,0.2,this.wallThickness,_loc2_,this.wallStains));
         }
         if(this._roof)
         {
            this._wallBodies.push(Spawn.Walls("u",1,0.2,this.wallThickness,_loc2_,this.wallStains));
         }
      }
      
      public function get background() : BitmapData
      {
         return this._background;
      }
      
      protected function set background(param1:BitmapData) : void
      {
         this._background = param1;
      }
      
      public function setupWalls() : void
      {
      }
      
      public function setupBackground() : void
      {
         var _loc1_:b2Body = null;
         GameState.environmenting = true;
         if(this._background)
         {
            this._background.fillRect(this._background.rect,this._backgroundColour);
         }
         this.seed = Vars.seed;
         for each(_loc1_ in this._defaultBodies)
         {
            Body.Destroy(_loc1_,"environment change",true);
         }
         this._defaultBodies = new Vector.<b2Body>();
         Main.instance.stage.color = this._backgroundColour;
      }
      
      public function setupBackgroundFiller(param1:Number, param2:uint) : *
      {
         if(!this._filler)
         {
            return;
         }
         var _loc3_:b2Body = null;
         var _loc4_:b2BodyDef = new b2BodyDef();
         var _loc5_:b2PolygonDef = new b2PolygonDef();
         _loc4_.position.Set((this.borderRight + this.borderLeft) * 0.5 / Physics.scale,(GameState.height + param1 * 0.5 - 5) / Physics.scale);
         _loc4_.userData = Properties.objectProperties("wall");
         _loc3_ = Physics.world.CreateBody(_loc4_);
         _loc5_.userData = Properties.shapeProperties("777777");
         _loc5_.SetAsBox((this.borderRight - this.borderLeft) * 0.5 / Physics.scale,param1 * 0.5 / Physics.scale);
         _loc3_.CreateShape(_loc5_);
         userData(_loc3_.GetUserData()).skin = new Vector.<Array>();
         userData(_loc3_.GetUserData()).skin.push(["777777",param2.toString(16)]);
         userData(_loc3_.GetUserData()).width = this.borderRight - this.borderLeft;
         userData(_loc3_.GetUserData()).height = 1000;
         userData(_loc3_.GetUserData()).stainless = true;
         userData(_loc3_.GetUserData()).graphic = BoxUtils.bodyToSprite(_loc3_,_loc3_.GetUserData().size);
         userData(_loc3_.GetUserData()).graphic.x = _loc3_.GetPosition().x * Physics.scale;
         userData(_loc3_.GetUserData()).graphic.y = _loc3_.GetPosition().y * Physics.scale;
         Main.instance.itemSprite.addChild(userData(_loc3_.GetUserData()).graphic);
         this._defaultBodies.push(_loc3_);
      }
      
      public function setupBackgroundFillerTop(param1:Number, param2:uint) : *
      {
         if(!this._filler)
         {
            return;
         }
         var _loc3_:b2Body = null;
         var _loc4_:b2BodyDef = new b2BodyDef();
         var _loc5_:b2PolygonDef = new b2PolygonDef();
         _loc4_.position.Set((this.borderRight + this.borderLeft) * 0.5 / Physics.scale,(-param1 * 0.5 + 5) / Physics.scale);
         _loc4_.userData = Properties.objectProperties("wall");
         _loc3_ = Physics.world.CreateBody(_loc4_);
         _loc5_.userData = Properties.shapeProperties("777777");
         _loc5_.SetAsBox((this.borderRight - this.borderLeft) * 0.5 / Physics.scale,param1 * 0.5 / Physics.scale);
         _loc3_.CreateShape(_loc5_);
         userData(_loc3_.GetUserData()).skin = new Vector.<Array>();
         userData(_loc3_.GetUserData()).skin.push(["777777",param2.toString(16)]);
         userData(_loc3_.GetUserData()).width = this.borderRight - this.borderLeft;
         userData(_loc3_.GetUserData()).height = 1000;
         userData(_loc3_.GetUserData()).stainless = true;
         userData(_loc3_.GetUserData()).graphic = BoxUtils.bodyToSprite(_loc3_,_loc3_.GetUserData().size);
         userData(_loc3_.GetUserData()).graphic.x = _loc3_.GetPosition().x * Physics.scale;
         userData(_loc3_.GetUserData()).graphic.y = _loc3_.GetPosition().y * Physics.scale;
         Main.instance.itemSprite.addChild(userData(_loc3_.GetUserData()).graphic);
         this._defaultBodies.push(_loc3_);
      }
      
      public function setupBackgroundFillerLeft(param1:Number, param2:Number, param3:Number, param4:uint) : *
      {
         if(!this._filler)
         {
            return;
         }
         var _loc5_:b2Body = null;
         var _loc6_:b2BodyDef = new b2BodyDef();
         var _loc7_:b2PolygonDef = new b2PolygonDef();
         _loc6_.position.Set((this.borderLeft - param3 * 0.5 + 5) / Physics.scale,((param2 + param1) * 0.5 + 5) / Physics.scale);
         _loc6_.userData = Properties.objectProperties("wall");
         _loc5_ = Physics.world.CreateBody(_loc6_);
         _loc7_.userData = Properties.shapeProperties("777777");
         _loc7_.SetAsBox(param3 * 0.5 / Physics.scale,(param2 - param1) * 0.5 / Physics.scale);
         _loc5_.CreateShape(_loc7_);
         userData(_loc5_.GetUserData()).skin = new Vector.<Array>();
         userData(_loc5_.GetUserData()).skin.push(["777777",param4.toString(16)]);
         userData(_loc5_.GetUserData()).width = param3;
         userData(_loc5_.GetUserData()).height = param2 - param1;
         userData(_loc5_.GetUserData()).stainless = true;
         userData(_loc5_.GetUserData()).graphic = BoxUtils.bodyToSprite(_loc5_,_loc5_.GetUserData().size);
         userData(_loc5_.GetUserData()).graphic.x = _loc5_.GetPosition().x * Physics.scale;
         userData(_loc5_.GetUserData()).graphic.y = _loc5_.GetPosition().y * Physics.scale;
         Main.instance.itemSprite.addChild(userData(_loc5_.GetUserData()).graphic);
         this._defaultBodies.push(_loc5_);
      }
      
      public function setupBackgroundFillerRight(param1:Number, param2:Number, param3:Number, param4:uint) : *
      {
         if(!this._filler)
         {
            return;
         }
         var _loc5_:b2Body = null;
         var _loc6_:b2BodyDef = new b2BodyDef();
         var _loc7_:b2PolygonDef = new b2PolygonDef();
         _loc6_.position.Set((this.borderRight + param3 * 0.5 - 5) / Physics.scale,((param2 + param1) * 0.5 + 5) / Physics.scale);
         _loc6_.userData = Properties.objectProperties("wall");
         _loc5_ = Physics.world.CreateBody(_loc6_);
         _loc7_.userData = Properties.shapeProperties("777777");
         _loc7_.SetAsBox(param3 * 0.5 / Physics.scale,(param2 - param1) * 0.5 / Physics.scale);
         _loc5_.CreateShape(_loc7_);
         userData(_loc5_.GetUserData()).skin = new Vector.<Array>();
         userData(_loc5_.GetUserData()).skin.push(["777777",param4.toString(16)]);
         userData(_loc5_.GetUserData()).width = param3;
         userData(_loc5_.GetUserData()).height = param2 - param1;
         userData(_loc5_.GetUserData()).stainless = true;
         userData(_loc5_.GetUserData()).graphic = BoxUtils.bodyToSprite(_loc5_,_loc5_.GetUserData().size);
         userData(_loc5_.GetUserData()).graphic.x = _loc5_.GetPosition().x * Physics.scale;
         userData(_loc5_.GetUserData()).graphic.y = _loc5_.GetPosition().y * Physics.scale;
         Main.instance.itemSprite.addChild(userData(_loc5_.GetUserData()).graphic);
         this._defaultBodies.push(_loc5_);
      }
      
      public function backgroundDone() : *
      {
         GameState.environmenting = false;
      }
      
      public function get gravity() : Number
      {
         return this._gravity;
      }
      
      public function set gravity(param1:Number) : void
      {
         this._gravity = param1;
      }
      
      public function get wind() : Number
      {
         return this._wind;
      }
      
      public function set wind(param1:Number) : void
      {
         this._wind = param1;
      }
      
      public function get loadContent() : String
      {
         return this._loadContent;
      }
      
      public function set loadContent(param1:*) : void
      {
         this._loadContent = param1;
      }
      
      public function get contentName() : String
      {
         return this._contentName;
      }
      
      public function set contentName(param1:String) : void
      {
         this._contentName = param1;
      }
      
      public function get minPan() : b2Vec2
      {
         return this._minPan;
      }
      
      public function get maxPan() : b2Vec2
      {
         return this._maxPan;
      }
      
      public function get minScale() : Number
      {
         return this._minScale;
      }
      
      public function get temperature() : Number
      {
         return this._temperature;
      }
      
      public function set temperature(param1:Number) : void
      {
         this._temperature = param1;
      }
      
      public function get wallBodies() : Vector.<b2Body>
      {
         return this._wallBodies;
      }
      
      protected function set wallBodies(param1:Vector.<b2Body>) : void
      {
         this._wallBodies = param1;
      }
      
      public function get defaultBodies() : Vector.<b2Body>
      {
         return this._defaultBodies;
      }
      
      public function set defaultBodies(param1:Vector.<b2Body>) : void
      {
         this._defaultBodies = param1;
      }
      
      public function get particleSystems() : Vector.<ParticleSystem>
      {
         return this._particleSystems;
      }
      
      protected function set particleSystems(param1:Vector.<ParticleSystem>) : void
      {
         this._particleSystems = param1;
      }
      
      public function get borderLeft() : Number
      {
         return this._borderLeft;
      }
      
      public function get borderRight() : Number
      {
         return this._borderRight;
      }
      
      public function get borderTop() : Number
      {
         return this._borderTop;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function get backgroundColour() : uint
      {
         return this._backgroundColour;
      }
      
      public function get wallColour() : uint
      {
         return this._wallColour;
      }
      
      public function get walls() : Boolean
      {
         return this._walls;
      }
      
      public function set walls(param1:Boolean) : void
      {
         this._walls = param1;
         this.updateWalls();
      }
      
      public function get floor() : Boolean
      {
         return this._floor;
      }
      
      public function set floor(param1:Boolean) : void
      {
         this._floor = param1;
         this.updateWalls();
      }
      
      public function get roof() : Boolean
      {
         return this._roof;
      }
      
      public function set roof(param1:Boolean) : void
      {
         this._roof = param1;
         this.updateWalls();
      }
      
      public function set backgroundColour(param1:uint) : void
      {
         this._backgroundColour = param1;
         if(!this._background)
         {
            this._background = new BitmapData(this._width,this._height,false,this._backgroundColour);
         }
         else
         {
            this.seed = Vars.seed;
            this.setupBackground();
         }
      }
      
      public function set wallColour(param1:uint) : void
      {
         this._wallColour = param1;
         this.updateWalls();
         if(this._background)
         {
            this.seed = Vars.seed;
            this.setupBackground();
         }
      }
      
      public function get particles() : Boolean
      {
         return this._particles;
      }
      
      public function set particles(param1:Boolean) : void
      {
         this._particles = param1;
      }
      
      public function get scrollBG() : Boolean
      {
         return this._scrollBG;
      }
      
      public function get loop() : Boolean
      {
         return this._loop;
      }
      
      public function set loop(param1:Boolean) : void
      {
         this._loop = param1;
      }
      
      public function get autoWind() : Boolean
      {
         return this._autoWind;
      }
      
      public function set autoWind(param1:Boolean) : void
      {
         this._autoWind = param1;
      }
      
      public function get wallL() : Boolean
      {
         return this._wallL;
      }
      
      public function set wallL(param1:Boolean) : void
      {
         this._wallL = param1;
         this.updateWalls();
      }
      
      public function get wallR() : Boolean
      {
         return this._wallR;
      }
      
      public function set wallR(param1:Boolean) : void
      {
         this._wallR = param1;
         this.updateWalls();
      }
      
      public function get filler() : Boolean
      {
         return this._filler;
      }
      
      public function set filler(param1:Boolean) : void
      {
         this._filler = param1;
         this.setupBackground();
      }
   }
}

