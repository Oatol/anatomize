package
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class Grid extends Sprite
   {
      
      internal var scroll:Point = new Point();
      
      internal var gridC:int;
      
      internal var gridR:int;
      
      internal var numC:int;
      
      internal var numR:int;
      
      internal var gridS:int;
      
      public function Grid()
      {
         super();
      }
      
      public function Redraw() : void
      {
         visible = true;
         mouseEnabled = false;
         graphics.clear();
         this.Update();
         var _loc1_:uint = 4282203053;
         if(World.toggleBlueprint == 0)
         {
            _loc1_ = 4282203453;
         }
         this.Draw(Tweak.GridSize,_loc1_);
         this.Update();
      }
      
      public function Draw(param1:int = 30, param2:uint = 4210752) : void
      {
         if(World.toggleGrid == 0)
         {
            return;
         }
         if(IO.incrementalLoading)
         {
            return;
         }
         graphics.lineStyle(1,param2);
         param1 *= Main.instance.cam.scaleX;
         this.gridS = param1;
         this.gridC = -3;
         this.gridR = -3;
         this.numC = GameState.width / param1 + 1;
         this.numR = GameState.height / param1 + 1;
         addEventListener(Event.ENTER_FRAME,this.drawGrid);
      }
      
      private function drawGrid(param1:Event) : void
      {
         if(this.gridC < this.numC)
         {
            ++this.gridC;
            graphics.moveTo(this.gridC * this.gridS,-this.gridS * 2);
            graphics.lineTo(this.gridC * this.gridS,this.gridS * this.numR);
         }
         if(this.gridR < this.numR)
         {
            ++this.gridR;
            graphics.moveTo(-this.gridS * 2,this.gridR * this.gridS);
            graphics.lineTo(this.gridS * this.numC,this.gridR * this.gridS);
         }
         if(this.gridC >= this.numC && this.gridR >= this.numR)
         {
            removeEventListener(Event.ENTER_FRAME,this.drawGrid);
         }
      }
      
      public function Finish() : *
      {
         var _loc1_:int = 0;
         while(_loc1_ < 1000)
         {
            this.drawGrid(null);
            if(this.gridC >= this.numC && this.gridR >= this.numR)
            {
               break;
            }
            _loc1_++;
         }
      }
      
      public function Update() : void
      {
         if(int(Math.abs(Main.instance.cam.y / this.gridS)) > 0)
         {
            if(Main.instance.cam.y < 0)
            {
               this.scroll.y = -int(Main.instance.cam.y / this.gridS) * this.gridS;
            }
            else
            {
               this.scroll.y = -int(Main.instance.cam.y / this.gridS) * this.gridS;
            }
         }
         if(int(Math.abs(Main.instance.cam.x / this.gridS)) > 0)
         {
            if(Main.instance.cam.y < 0)
            {
               this.scroll.x = -int(Main.instance.cam.x / this.gridS) * this.gridS;
            }
            else
            {
               this.scroll.x = -int(Main.instance.cam.x / this.gridS) * this.gridS;
            }
         }
         x = Main.instance.cam.x + this.scroll.x;
         y = Main.instance.cam.y + this.scroll.y;
      }
   }
}

