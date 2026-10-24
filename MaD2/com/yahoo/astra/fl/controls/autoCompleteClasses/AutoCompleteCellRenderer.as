package com.yahoo.astra.fl.controls.autoCompleteClasses
{
   import fl.controls.listClasses.CellRenderer;
   import flash.display.Sprite;
   
   public class AutoCompleteCellRenderer extends CellRenderer
   {
      
      private var darkBG:uint;
      
      private var lightBG:uint;
      
      public function AutoCompleteCellRenderer()
      {
         super();
         super.drawTextFormat();
         this.lightBG = GameState.ui.menuMain.BACKGROUNDCOLOUR;
         this.darkBG = GameState.ui.menuMain.BACKGROUNDCOLOUR * 0.9;
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(GameState.ui.menuMain.BACKGROUNDCOLOUR);
         _loc1_.graphics.drawRect(0,0,10,10);
         _loc1_.graphics.endFill();
         setStyle("background",_loc1_);
      }
      
      override protected function drawTextFormat() : void
      {
      }
      
      override protected function drawBackground() : void
      {
         if(_listData.index % 2 == 0 || Boolean(_data.noReadabilityTint))
         {
            setStyle("upSkin","TreeCellRenderer_upSkinDark");
         }
         else
         {
            setStyle("upSkin","TreeCellRenderer_upSkin");
         }
         super.drawBackground();
      }
   }
}

