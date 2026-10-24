package environment
{
   import flash.display.BitmapData;
   
   public class Big_Lab extends Environment
   {
      
      public function Big_Lab()
      {
         super(GameState.width,GameState.height);
         _name = "biglab";
         gravity = 20;
         wind = 0;
         temperature = 37;
         _borderLeft = -GameState.width * 0.5;
         _borderRight = GameState.width * 1.5;
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

