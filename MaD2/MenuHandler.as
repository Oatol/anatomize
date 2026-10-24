package
{
   public class MenuHandler
   {
      
      private var menus:Vector.<Window>;
      
      private var menuNames:Vector.<String>;
      
      public function MenuHandler()
      {
         super();
         this.menus = new Vector.<Window>();
         this.menuNames = new Vector.<String>();
      }
      
      public function addMenu(param1:Window) : *
      {
         this.menus.push(param1);
         this.menuNames.push(param1.name);
      }
      
      public function delMenu(param1:Window) : void
      {
         var _loc2_:int = this.getMenuIndexByName(param1.name);
         if(_loc2_ == -1)
         {
            return;
         }
         this.menus.splice(_loc2_,1);
         this.menuNames.splice(_loc2_,1);
      }
      
      private function getMenuIndexByName(param1:String) : int
      {
         return this.menuNames.indexOf(param1);
      }
      
      private function getMenuByName(param1:String) : Window
      {
         var _loc2_:int = this.getMenuIndexByName(param1);
         if(_loc2_ == -1)
         {
            return null;
         }
         return this.menus[_loc2_];
      }
      
      public function getMenu(param1:String) : Window
      {
         return this.getMenuByName(param1);
      }
      
      public function toggleVisible(param1:String) : *
      {
         var _loc2_:Window = this.getMenuByName(param1);
         if(_loc2_)
         {
            _loc2_.visible = !_loc2_.visible;
         }
      }
      
      public function closeAll() : void
      {
         var _loc1_:Window = null;
         for each(_loc1_ in this.menus)
         {
            _loc1_.close();
         }
      }
      
      public function toggleAll() : void
      {
         var _loc1_:Window = null;
         for each(_loc1_ in this.menus)
         {
            if(_loc1_.alpha == 0)
            {
               _loc1_.alpha = 1;
            }
            else
            {
               _loc1_.alpha = 0;
            }
         }
      }
      
      public function toggleAllSliders(param1:Boolean) : void
      {
         var _loc2_:Window = null;
         for each(_loc2_ in this.menus)
         {
            _loc2_.toggleAllSliders(param1);
         }
      }
      
      public function resetDocks() : void
      {
         var _loc1_:Window = null;
         for each(_loc1_ in this.menus)
         {
            _loc1_.undocked = false;
         }
      }
      
      public function isDragging() : Boolean
      {
         var _loc1_:Window = null;
         for each(_loc1_ in this.menus)
         {
            if(_loc1_.dragging)
            {
               return true;
            }
         }
         return false;
      }
      
      public function menuDragging() : Window
      {
         var _loc1_:Window = null;
         for each(_loc1_ in this.menus)
         {
            if(_loc1_.dragging)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function setScale(param1:Number) : void
      {
         var _loc2_:Window = null;
         Tweak.UIScale = param1;
         for each(_loc2_ in this.menus)
         {
            _loc2_.scaleX = _loc2_.scaleY = param1;
         }
      }
      
      public function setAlpha(param1:Number) : void
      {
         var _loc2_:Window = null;
         for each(_loc2_ in this.menus)
         {
            _loc2_.setAlpha(param1);
            _loc2_.redraw();
         }
      }
      
      public function redraw() : void
      {
         var _loc1_:Window = null;
         for each(_loc1_ in this.menus)
         {
            _loc1_.redraw();
         }
      }
   }
}

