package environment
{
   import Box2D.Common.Math.b2Vec2;
   import flash.display.BitmapData;
   
   public class Max_Lab extends Environment
   {
      
      public function Max_Lab()
      {
         var _loc1_:Number = NaN;
         super(GameState.width,GameState.height);
         _name = "ultralab";
         gravity = 20;
         wind = 0;
         temperature = 37;
         _loc1_ = 9000;
         _minPan = new b2Vec2(-_loc1_ - 500,-_loc1_ - 500);
         _maxPan = new b2Vec2(_loc1_ + 500,_loc1_ + 500);
         _minScale = 0.07;
         _borderTop = _loc1_;
         _borderLeft = -_loc1_;
         _borderRight = _loc1_;
         _backgroundColour = 0;
         _wallColour = 7829367;
         _background = new BitmapData(GameState.width,GameState.height,false,_backgroundColour);
         _scrollBG = false;
         enableParticles = false;
         enableFiller = false;
         backgroundGore = true;
         wallStains = false;
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

