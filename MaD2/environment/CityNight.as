package environment
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   
   public class CityNight extends Environment
   {
      
      public function CityNight()
      {
         super(GameState.width,GameState.height);
         _name = "citynight";
         gravity = 20;
         wind = 0;
         temperature = 24;
         _borderLeft = -2800;
         _borderRight = 2800;
         _backgroundColour = 2236962;
         _wallColour = 5592405;
         _background = new BitmapData(1600,600,false);
         _roof = false;
         _walls = false;
         _wallL = false;
         _wallR = false;
         _loop = true;
         enableParticles = false;
         this.setupBackground();
      }
      
      override public function setupBackground() : void
      {
         super.setupBackground();
         var _loc1_:b2Vec2 = new b2Vec2(random() * 850 + 150,random() * 150 + 100);
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.beginFill(12301988);
         _loc2_.graphics.drawCircle(_loc1_.x,_loc1_.y,100);
         _loc2_.graphics.beginFill(_backgroundColour);
         _loc2_.graphics.drawCircle(random() * 100 - 50 + _loc1_.x,random() * 100 - 50 + _loc1_.y,random() * 50 - 25 + 100);
         _background.draw(_loc2_,_loc2_.transform.matrix);
         this.initItems();
         backgroundDone();
      }
      
      private function initItems() : void
      {
         var _loc1_:Item = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:b2Body = null;
         var _loc11_:Matrix = null;
         var _loc5_:Vector.<Array> = _loc5_ = new Vector.<Array>();
         _loc6_ = 0;
         while(_loc6_ < random() * 20 + 10)
         {
            _loc5_ = new Vector.<Array>();
            _loc7_ = 16;
            _loc8_ = 78 + random() * 20 - 10;
            _loc9_ = 23;
            _loc5_.push(["BEE8F7",GraphicUtils.scalehex(10066329,0.8 + random() * 0.2 - 0.1).toString(16)]);
            _loc2_ = 0.4 + random() * 0.4 - 0.2;
            _loc3_ = random() * 2400 + 200;
            _loc4_ = random() * 100 + 100 + _loc2_ * 50;
            _loc1_ = O.getItem("cloud");
            if(random() > 0.33)
            {
               _loc1_ = O.getItem("downwardscloud");
            }
            if(random() > 0.33)
            {
               _loc1_ = O.getItem("longcloud");
            }
            _loc10_ = GameState.objects.spawnItem(_loc1_.vertices,[0],_loc2_,_loc1_.name,_loc3_,_loc4_,0,_loc1_.colours,"none",_loc5_);
            _loc11_ = new Matrix();
            _loc11_.rotate((random() * 360 - 720) * Vars.toRadians);
            _loc11_.translate(_loc3_,_loc4_);
            _background.draw(userData(_loc10_.GetUserData()).graphic,_loc11_);
            Body.Destroy(_loc10_,"environment");
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < 5)
         {
            _loc5_ = new Vector.<Array>();
            _loc7_ = 16;
            _loc8_ = 78 + random() * 20 - 10;
            _loc9_ = 23;
            _loc2_ = 2;
            _loc3_ = 50 + 250 * _loc6_;
            _loc4_ = 520;
            _loc5_.push(["edd5a7",GraphicUtils.scalehex(15586727,1 + random() * 0.2 - 0.1).toString(16)]);
            _loc5_.push(["3c3f47",GraphicUtils.scalehex(2895928,1 + random() * 0.2 - 0.1).toString(16)]);
            _loc1_ = O.getItem("cityskyline4");
            if(random() > 0.33)
            {
               _loc1_ = O.getItem("cityskyline3");
            }
            if(random() > 0.33)
            {
               _loc1_ = O.getItem("cityskyline2");
            }
            _loc10_ = GameState.objects.spawnItem(_loc1_.vertices,[1],_loc2_,_loc1_.name,_loc3_,_loc4_,0,_loc1_.colours,"none",_loc5_);
            _loc11_ = new Matrix();
            _loc11_.translate(_loc3_,_loc4_);
            _background.draw(userData(_loc10_.GetUserData()).graphic,_loc11_);
            Body.Destroy(_loc10_,"environment");
            _loc6_++;
         }
         setupBackgroundFiller(600,_wallColour);
      }
      
      override public function setupWalls() : void
      {
         super.setupWalls();
         updateWalls();
      }
   }
}

