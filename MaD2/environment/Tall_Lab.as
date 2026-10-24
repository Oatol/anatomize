package environment
{
   import flash.display.BitmapData;
   
   public class Tall_Lab extends Environment
   {
      
      public function Tall_Lab()
      {
         super(GameState.width,GameState.height);
         _name = "talllab";
         gravity = 20;
         wind = 0;
         temperature = 37;
         _borderTop = 1200;
         _backgroundColour = 0;
         _wallColour = 7829367;
         _background = new BitmapData(GameState.width,GameState.height,false,_backgroundColour);
         _scrollBG = false;
         enableParticles = false;
         enableFiller = false;
         backgroundGore = true;
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

