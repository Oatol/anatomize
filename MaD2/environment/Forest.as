package environment
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   
   public class Forest extends Environment
   {
      
      public function Forest()
      {
         super(GameState.width,GameState.height);
         _name = "forest";
         gravity = 20;
         wind = 0;
         temperature = 24;
         _borderLeft = -2800;
         _borderRight = 2800;
         _backgroundColour = 6461124;
         _wallColour = 4621065;
         _background = new BitmapData(1600,600,false);
         _roof = false;
         _walls = false;
         _wallL = false;
         _wallR = false;
         enableParticles = false;
         this.setupBackground();
      }
      
      override public function setupBackground() : void
      {
         super.setupBackground();
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(14201088);
         _loc1_.graphics.drawCircle(750,100,100);
         _background.draw(_loc1_,_loc1_.transform.matrix);
         this.initItems();
         backgroundDone();
      }
      
      private function initItems() : void
      {
         var _loc1_:Item = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Vector.<Array> = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:uint = 0;
         var _loc12_:b2Body = null;
         var _loc13_:Matrix = null;
         var _loc6_:int = 0;
         while(_loc6_ < clutterDensity * 0.2)
         {
            _loc1_ = O.getItem("grasstuft");
            _loc2_ = 0.05 + random() * 0.06 - 0.03;
            _loc3_ = random() * 2400 - 800;
            _loc4_ = _height - 20 + _loc2_ * 40;
            _loc5_ = new Vector.<Array>();
            _loc8_ = (_wallColour >> 16 & 0xFF) + random() * 20 - 10;
            _loc9_ = (_wallColour >> 8 & 0xFF) + random() * 20 - 10;
            _loc10_ = (_wallColour & 0xFF) + random() * 20 - 10;
            if(_loc8_ > 255)
            {
               _loc8_ = 255;
            }
            if(_loc9_ > 255)
            {
               _loc9_ = 255;
            }
            if(_loc10_ > 255)
            {
               _loc10_ = 255;
            }
            if(_loc8_ < 0)
            {
               _loc8_ = 0;
            }
            if(_loc9_ < 0)
            {
               _loc9_ = 0;
            }
            if(_loc10_ < 0)
            {
               _loc10_ = 0;
            }
            _loc11_ = uint(_loc8_ << 16 | _loc9_ << 8 | _loc10_);
            _loc5_ = new Vector.<Array>();
            _loc5_.push(["468309",_loc11_.toString(16)]);
            _loc12_ = GameState.objects.spawnItem(_loc1_.vertices,[0],_loc2_,Properties.objBurn("grasstuft"),-500,-500,0,_loc1_.colours,"none",_loc5_);
            userData(_loc12_.GetUserData()).ghost = true;
            _loc12_.SetXForm(new b2Vec2(_loc3_ / Physics.scale,_loc4_ / Physics.scale),(random() * 10 - 5) * Vars.toRadians);
            if(random() > 0.9)
            {
               userData(_loc12_.GetUserData()).layer = 2;
            }
            else
            {
               userData(_loc12_.GetUserData()).layer = 0;
            }
            GraphicUtils.addGraphicToLayer(userData(_loc12_.GetUserData()));
            _defaultBodies.push(_loc12_);
            _loc6_++;
         }
         _loc7_ = 0;
         while(_loc7_ < clutterDensity * 0.1)
         {
            if(random() > 0.9)
            {
               _loc1_ = O.getItem("deadtree");
            }
            else
            {
               _loc1_ = O.getItem("tree");
            }
            _loc5_ = new Vector.<Array>();
            _loc8_ = 16;
            _loc9_ = 78 + random() * 20 - 10;
            _loc10_ = 23;
            _loc5_.push(["104e17",uint(_loc8_ << 16 | _loc9_ << 8 | _loc10_).toString(16)]);
            _loc5_.push(["105017",uint(_loc8_ << 16 | _loc9_ + (random() * 4 - 2) >> 0 << 8 | _loc10_).toString(16)]);
            _loc2_ = 1 + random() * 0.6 - 0.3;
            _loc3_ = random() * 2400 - 800;
            _loc4_ = _height - _loc2_ * 175;
            _loc12_ = GameState.objects.spawnItem(_loc1_.vertices,[0],_loc2_,Properties.objBurn("tree"),-500,-500,0,_loc1_.colours,"none",_loc5_);
            userData(_loc12_.GetUserData()).ghost = true;
            _loc12_.SetXForm(new b2Vec2(_loc3_ / Physics.scale,_loc4_ / Physics.scale),(random() * 10 - 5) * Vars.toRadians);
            if(random() > 0.9)
            {
               userData(_loc12_.GetUserData()).layer = 2;
            }
            else
            {
               userData(_loc12_.GetUserData()).layer = 0;
            }
            GraphicUtils.addGraphicToLayer(userData(_loc12_.GetUserData()));
            _defaultBodies.push(_loc12_);
            _loc7_++;
         }
         _loc7_ = 0;
         while(_loc7_ < random() * 20)
         {
            _loc5_ = new Vector.<Array>();
            _loc8_ = 16;
            _loc9_ = 78 + random() * 20 - 10;
            _loc10_ = 23;
            _loc5_.push(["BEE8F7",GraphicUtils.scalehex(12511479,1 + random() * 0.2 - 0.1).toString(16)]);
            _loc2_ = 0.4 + random() * 0.4 - 0.2;
            _loc3_ = random() * 2400 + 200;
            _loc4_ = random() * 100 + 100 + _loc2_ * 50;
            _loc1_ = O.getItem("cloud");
            _loc12_ = GameState.objects.spawnItem(_loc1_.vertices,[0],_loc2_,"cloud",_loc3_,_loc4_,0,_loc1_.colours,"none",_loc5_);
            _loc13_ = new Matrix();
            _loc13_.rotate((random() * 360 - 720) * Vars.toRadians);
            _loc13_.translate(_loc3_,_loc4_);
            _background.draw(userData(_loc12_.GetUserData()).graphic,_loc13_);
            Body.Destroy(_loc12_,"environment");
            _loc7_++;
         }
         setupBackgroundFiller(2000,_wallColour);
      }
      
      override public function setupWalls() : void
      {
         super.setupWalls();
         updateWalls();
      }
      
      override public function update() : void
      {
         super.update();
      }
   }
}

