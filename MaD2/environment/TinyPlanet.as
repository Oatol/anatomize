package environment
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   
   public class TinyPlanet extends Environment
   {
      
      public function TinyPlanet()
      {
         super(GameState.width,GameState.height);
         _name = "tinyplanet";
         gravity = 2;
         wind = 0;
         temperature = 1;
         _backgroundColour = 0;
         _wallColour = 4473924;
         _borderLeft = -2000;
         _borderRight = 2000;
         _borderTop = 2000;
         _background = new BitmapData(1600,1600,false);
         enableParticles = false;
         enableWind = false;
         enableFiller = false;
         this.setupBackground();
      }
      
      override public function setupBackground() : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Vector.<Array> = null;
         var _loc6_:Item = null;
         var _loc7_:uint = 0;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         super.setupBackground();
         _background.fillRect(_background.rect,_backgroundColour);
         _background.lock();
         var _loc1_:int = 0;
         while(_loc1_ < clutterDensity)
         {
            _loc13_ = random() * _background.width;
            _loc14_ = random() * _background.height;
            _background.setPixel(_loc13_,_loc14_,16777215);
            _background.setPixel(_loc13_ + 1,_loc14_,16777215);
            _background.setPixel(_loc13_,_loc14_ + 1,16777215);
            _background.setPixel(_loc13_ - 1,_loc14_,16777215);
            _background.setPixel(_loc13_,_loc14_ - 1,16777215);
            _loc1_++;
         }
         _background.unlock();
         var _loc2_:Number = 1;
         _loc6_ = O.getItem("dodecagon");
         _loc4_ = _height * 0.5;
         _loc3_ = _width * 0.5;
         var _loc8_:int = (_wallColour >> 16 & 0xFF) + random() * 10 - 5;
         var _loc9_:int = (_wallColour >> 8 & 0xFF) + random() * 10 - 5;
         var _loc10_:int = (_wallColour & 0xFF) + random() * 10 - 5;
         _loc7_ = uint(_loc8_ << 16 | _loc9_ << 8 | _loc10_);
         _loc5_ = new Vector.<Array>();
         _loc5_.push(["505050",_loc7_.toString(16)]);
         var _loc11_:b2Body = GameState.objects.spawnItem(_loc6_.vertices,[0],_loc2_,"planet",_loc3_,_loc4_,90 * Vars.toRadians,_loc6_.colours,"none",_loc5_);
         var _loc12_:b2Body = GameState.objects.spawnItem(_loc6_.vertices,[0],_loc2_,"planet",_loc3_,_loc4_,45 * Vars.toRadians,_loc6_.colours,"none",_loc5_);
         _defaultBodies.push(_loc11_);
         _defaultBodies.push(_loc12_);
         backgroundDone();
      }
      
      override public function setupWalls() : void
      {
         super.setupWalls();
         _walls = false;
         _wallL = false;
         _wallR = false;
         _roof = false;
         _floor = false;
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
         var _loc4_:b2Body = null;
         var _loc5_:userData = null;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         super.update();
         var _loc1_:Number = 500;
         var _loc2_:b2Vec2 = new b2Vec2(_width * 0.5,_height * 0.5);
         var _loc3_:Array = Body.GetAroundPoint(_loc2_,_loc1_,_loc1_,false);
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = userData(_loc4_.GetUserData());
            _loc6_ = _loc2_.x / Physics.scale - _loc4_.GetWorldCenter().x;
            _loc7_ = _loc2_.y / Physics.scale - _loc4_.GetWorldCenter().y;
            _loc8_ = _loc6_ * _loc6_ + _loc7_ * _loc7_;
            _loc4_.ApplyForce(new b2Vec2(_loc6_ * Vars.gravity,_loc7_ * Vars.gravity),_loc4_.GetWorldCenter());
         }
      }
   }
}

