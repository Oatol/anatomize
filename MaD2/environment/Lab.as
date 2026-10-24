package environment
{
   import flash.display.BitmapData;
   
   public class Lab extends Environment
   {
      
      public function Lab()
      {
         super(GameState.width,GameState.height);
         _name = "lab";
         gravity = 20;
         wind = 0;
         temperature = 37;
         _backgroundColour = 0;
         _wallColour = 7829367;
         _background = new BitmapData(_width,_height,false);
         _background.fillRect(_background.rect,_backgroundColour);
         enableParticles = false;
         enableFiller = false;
         backgroundGore = true;
      }
      
      override public function setupBackground() : void
      {
         super.setupBackground();
         backgroundDone();
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

