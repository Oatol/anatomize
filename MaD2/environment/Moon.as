package environment
{
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class Moon extends Environment
   {
      
      public function Moon()
      {
         super(GameState.width,GameState.height);
         _name = "moon";
         gravity = 8;
         wind = 0;
         temperature = 1;
         _borderTop = 2000;
         _borderLeft = -2800;
         _borderRight = 2800;
         _backgroundColour = 0;
         _wallColour = 5592405;
         _background = new BitmapData(3200,_height,false);
         enableParticles = false;
         _walls = false;
         _wallL = false;
         _wallR = false;
         _roof = false;
         enableWind = false;
         enableFiller = false;
         this.setupBackground();
      }
      
      override public function setupBackground() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Vector.<Array> = null;
         var _loc6_:Item = null;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:Matrix = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:uint = 0;
         var _loc14_:b2Body = null;
         super.setupBackground();
         _background.lock();
         _loc1_ = 0;
         while(_loc1_ < clutterDensity)
         {
            _loc7_ = random() * _background.width;
            _loc8_ = random() * _background.height;
            _background.setPixel(_loc7_,_loc8_,16777215);
            _background.setPixel(_loc7_ + 1,_loc8_,16777215);
            _background.setPixel(_loc7_,_loc8_ + 1,16777215);
            _background.setPixel(_loc7_ - 1,_loc8_,16777215);
            _background.setPixel(_loc7_,_loc8_ - 1,16777215);
            _loc1_++;
         }
         _background.unlock();
         _loc1_ = 0;
         while(_loc1_ < clutterDensity * 0.1)
         {
            _loc3_ = random() * 2400 - 800;
            _loc4_ = GameState.height;
            _loc9_ = new Matrix();
            _loc5_ = new Vector.<Array>();
            _loc6_ = O.getItem("coal");
            _loc2_ = 0.2 + random() * random() * random();
            _loc4_ -= _loc2_ * random() * 30;
            _loc10_ = (_wallColour >> 16 & 0xFF) - 10;
            _loc11_ = (_wallColour >> 8 & 0xFF) - 10;
            _loc12_ = (_wallColour & 0xFF) - random() * 20;
            if(_loc10_ > 255)
            {
               _loc10_ = 255;
            }
            if(_loc11_ > 255)
            {
               _loc11_ = 255;
            }
            if(_loc12_ > 255)
            {
               _loc12_ = 255;
            }
            if(_loc10_ < 0)
            {
               _loc10_ = 0;
            }
            if(_loc11_ < 0)
            {
               _loc11_ = 0;
            }
            if(_loc12_ < 0)
            {
               _loc12_ = 0;
            }
            _loc13_ = uint(_loc10_ << 16 | _loc11_ << 8 | _loc12_);
            _loc5_.push(["252525",_loc13_.toString(16)]);
            _loc9_.rotate((random() * 720 - 360) * Vars.toRadians);
            _loc14_ = GameState.objects.spawnItem(_loc6_.vertices,[0],_loc2_,"moonrock",_loc3_,_loc4_,0,_loc6_.colours,"none",_loc5_);
            _loc9_.translate(_loc3_,_loc4_);
            _defaultBodies.push(_loc14_);
            _loc1_++;
         }
         setupBackgroundFiller(1000,_wallColour);
         backgroundDone();
      }
      
      override public function setupWalls() : void
      {
         super.setupWalls();
         updateWalls();
      }
   }
}

