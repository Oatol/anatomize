package com.yahoo.astra.fl.controls
{
   import com.yahoo.astra.fl.controls.autoCompleteClasses.AutoCompleteCellRenderer;
   import com.yahoo.astra.fl.events.DropdownEvent;
   import fl.controls.List;
   import fl.controls.TextInput;
   import fl.controls.listClasses.CellRenderer;
   import fl.data.DataProvider;
   import fl.events.ListEvent;
   import fl.events.ScrollEvent;
   import fl.transitions.easing.*;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.ui.Keyboard;
   import flash.utils.*;
   
   public class AutoComplete extends TextInput
   {
      
      public static var createAccessibilityImplementation:Function;
      
      private var showingDropdown:Boolean = false;
      
      private var filteredData:Array;
      
      private var _dropdown:List;
      
      private var _oldIndex:int;
      
      private var _showingDropdown:Boolean = false;
      
      private var _selectedIndexOnDropdown:int = -1;
      
      private var bRemoveDropdown:Boolean = false;
      
      private var inTween:Boolean = false;
      
      private var bInKeyDown:Boolean = false;
      
      private var selectedItemSet:Boolean;
      
      private var triggerEvent:Event;
      
      private var dropdownClosed:Boolean = true;
      
      private var cursorPosition:Number = 0;
      
      private var prevIndex:Number = -1;
      
      private var removeHighlight:Boolean = false;
      
      private var _showDropdown:Boolean = false;
      
      private var _unfilteredDataProvider:DataProvider;
      
      private var _defaultPopUpRenderer:Class = List;
      
      private var _popUpRenderer:Class = this._defaultPopUpRenderer;
      
      private var _dataProvider:DataProvider;
      
      private var _dropdownWidth:Number = 100;
      
      private var _labelField:String = "label";
      
      private var labelFieldChanged:Boolean;
      
      private var _labelFunction:Function;
      
      private var labelFunctionChanged:Boolean;
      
      private var _rowCount:int = 6;
      
      private var _filterFunction:Function;
      
      private var filterFunctionChanged:Boolean = true;
      
      private var _autoFillEnabled:Boolean;
      
      private var autoFillEnabledChanged:Boolean;
      
      private var _minCharsForCompletion:int = 0;
      
      private var continuation:Boolean = false;
      
      private var _typedText:String = "";
      
      protected var typedTextChanged:Boolean;
      
      private var _dropdownEnabled:Boolean = true;
      
      private var emphasize:String = "";
      
      public var keysEnabled:Boolean = false;
      
      public function AutoComplete()
      {
         this._filterFunction = this.defaultFilterFunction;
         super();
         addEventListener("unload",this.unloadHandler);
         addEventListener("addedToStage",this.stageAdded);
         textField.addEventListener(MouseEvent.MOUSE_DOWN,this.close);
      }
      
      private function get isShowingDropdown() : Boolean
      {
         return this._showingDropdown;
      }
      
      protected function get unfilteredDataProvider() : DataProvider
      {
         return this._unfilteredDataProvider;
      }
      
      protected function set unfilteredDataProvider(param1:DataProvider) : void
      {
         this._unfilteredDataProvider = param1;
      }
      
      public function get popUpRenderer() : Class
      {
         return this._popUpRenderer;
      }
      
      public function set popUpRenderer(param1:Class) : void
      {
         this._popUpRenderer = param1;
      }
      
      public function get dataProvider() : DataProvider
      {
         return this._dataProvider;
      }
      
      public function set dataProvider(param1:DataProvider) : void
      {
         this._dataProvider = param1;
         this.dropdown.dataProvider = param1;
         this.unfilteredDataProvider = param1.clone();
      }
      
      public function get selectedIndex() : int
      {
         return this._dropdown.selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         this._dropdown.selectedIndex = param1;
         if(param1 >= 0)
         {
            text = this.selectedLabel;
            setSelection(text.length,text.length);
            textField.scrollH = 0;
            this.removeHighlight = false;
            if(!this.bInKeyDown)
            {
               this.updateDataProvider(false);
            }
            this.typedTextChanged = true;
            this._dropdown.scrollToSelected();
            invalidate();
            this.applyEmphasis();
         }
      }
      
      public function get selectedItem() : Object
      {
         return this._dropdown.selectedItem;
      }
      
      public function set selectedItem(param1:Object) : void
      {
         this._dropdown.selectedItem = param1;
      }
      
      public function get dropdown() : List
      {
         return this.getDropdown();
      }
      
      protected function get dropdownWidth() : Number
      {
         return this._dropdownWidth;
      }
      
      protected function set dropdownWidth(param1:Number) : void
      {
         if(this._dropdownWidth == param1)
         {
            return;
         }
         this._dropdownWidth = param1;
         if(this._dropdown)
         {
            this._dropdown.setSize(param1,this.dropdownHeight);
         }
         dispatchEvent(new Event("dropdownWidthChanged"));
      }
      
      protected function get dropdownHeight() : Number
      {
         return this._dropdown.rowCount * this._dropdown.rowHeight;
      }
      
      public function get labelField() : String
      {
         return this._labelField;
      }
      
      public function set labelField(param1:String) : void
      {
         this._labelField = param1;
         this.labelFieldChanged = true;
         invalidate();
         drawLayout();
         dispatchEvent(new Event("labelFieldChanged"));
      }
      
      public function get labelFunction() : Function
      {
         return this._labelFunction;
      }
      
      public function set labelFunction(param1:Function) : void
      {
         this._labelFunction = param1;
         this.labelFunctionChanged = true;
         invalidate();
         dispatchEvent(new Event("labelFunctionChanged"));
      }
      
      public function get rowCount() : int
      {
         return Math.max(1,Math.min(this.dropdown.dataProvider.length,this._rowCount));
      }
      
      public function set rowCount(param1:int) : void
      {
         this._rowCount = param1;
         if(this._dropdown)
         {
            this._dropdown.rowCount = param1;
         }
      }
      
      public function get selectedLabel() : String
      {
         var _loc1_:Object = this.selectedItem;
         return this.itemToLabel(_loc1_);
      }
      
      public function get filterFunction() : Function
      {
         return this._filterFunction;
      }
      
      public function set filterFunction(param1:Function) : void
      {
         if(param1 != null)
         {
            this._filterFunction = param1;
            this.filterFunctionChanged = true;
            invalidate();
            dispatchEvent(new Event("filterFunctionChange"));
         }
         else
         {
            this._filterFunction = this.defaultFilterFunction;
         }
      }
      
      public function get autoFillEnabled() : Boolean
      {
         return this._autoFillEnabled;
      }
      
      public function set autoFillEnabled(param1:Boolean) : void
      {
         this._autoFillEnabled = param1;
         this.autoFillEnabledChanged = true;
      }
      
      public function get minCharsForCompletion() : int
      {
         return this._minCharsForCompletion;
      }
      
      public function set minCharsForCompletion(param1:int) : void
      {
         this._minCharsForCompletion = param1;
      }
      
      protected function get typedText() : String
      {
         return this._typedText;
      }
      
      protected function set typedText(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         this._typedText = param1;
         this.typedTextChanged = true;
         this.updateDataProvider();
         if(this.autoFillEnabled && this.dropdown.visible && this.typedText != "")
         {
            _loc2_ = this.itemToLabel(this.dataProvider.getItemAt(0));
            _loc3_ = _loc2_.toLowerCase().indexOf(text.toLowerCase());
            if(_loc3_ == 0)
            {
               _loc4_ = _loc2_.substr(text.length);
               if(!this.removeHighlight)
               {
                  text += _loc4_;
                  setSelection(text.length,this._typedText.length);
                  textField.scrollH = 0;
               }
               else
               {
                  setSelection(text.length,text.length);
                  textField.scrollH = 0;
               }
               this.removeHighlight = false;
            }
         }
         this.emphasize = this._typedText;
         this.applyEmphasis();
         dispatchEvent(new Event("typedTextChange"));
      }
      
      public function get dropdownEnabled() : Boolean
      {
         return this._dropdownEnabled;
      }
      
      public function set dropdownEnabled(param1:Boolean) : void
      {
         this._dropdownEnabled = param1;
      }
      
      protected function defaultFilterFunction(param1:*, param2:int = 0, param3:Array = null) : Boolean
      {
         var _loc8_:Array = null;
         var _loc4_:String = this.itemToLabel(param1).toLowerCase();
         var _loc5_:String = text.toLowerCase();
         var _loc6_:int = _loc4_.indexOf(_loc5_);
         var _loc7_:Boolean = _loc6_ != -1;
         if(_loc6_ == -1)
         {
            _loc8_ = String(param1.tag).toLowerCase().split(",");
            if(_loc8_.indexOf(_loc5_) != -1)
            {
               _loc7_ = true;
            }
         }
         return _loc7_;
      }
      
      private function templateFilterFunction(param1:*) : Boolean
      {
         var _loc2_:Boolean = false;
         if(this.filterFunction != null)
         {
            _loc2_ = this.filterFunction(param1,this.typedText);
         }
         return _loc2_;
      }
      
      override protected function draw() : void
      {
         super.draw();
         if(!this._showingDropdown && this.inTween)
         {
            this.bRemoveDropdown = true;
         }
         if(this.labelFieldChanged)
         {
            if(this._dropdown)
            {
               this._dropdown.labelField = this._labelField;
            }
         }
         if(this.labelFunctionChanged)
         {
            if(this._dropdown)
            {
               this._dropdown.labelFunction = this._labelFunction;
            }
         }
      }
      
      private function updateDataProvider(param1:Boolean = true) : void
      {
         if(!this._dropdown)
         {
            this.getDropdown();
         }
         if(this.typedText.length <= this.minCharsForCompletion && !this.bInKeyDown)
         {
            this.displayDropdown(false);
            return;
         }
         this.filteredData = this.unfilteredDataProvider.toArray();
         this.filteredData = this.filteredData.filter(this.filterFunction);
         this.filteredData.sort(Array.CASEINSENSITIVE);
         this.filteredData.sort(this.exactSort);
         this._dropdown.dataProvider = new DataProvider(this.filteredData);
         this.positionDropdown();
         if(param1)
         {
            if(this._dropdown.dataProvider.length > 0)
            {
               this.open();
            }
            else
            {
               this.close();
            }
         }
         this._dataProvider = this._dropdown.dataProvider;
      }
      
      internal function exactSort(param1:*, param2:*) : int
      {
         if(String(param1.label).toLowerCase() == this.typedText.toLowerCase())
         {
            return -1;
         }
         if(String(param2.label).toLowerCase() == this.typedText.toLowerCase())
         {
            return 1;
         }
         return 0;
      }
      
      public function itemToLabel(param1:Object) : String
      {
         var _loc2_:String = null;
         if(param1 == null)
         {
            return "";
         }
         if(this.labelFunction != null)
         {
            return this.labelFunction(param1);
         }
         if(typeof param1 == "object")
         {
            try
            {
               if(param1[this.labelField] != null)
               {
                  param1 = param1[this.labelField];
               }
            }
            catch(e:Error)
            {
            }
         }
         else if(typeof param1 == "xml")
         {
            try
            {
               if(param1[this.labelField].length() != 0)
               {
                  param1 = param1[this.labelField];
               }
            }
            catch(e:Error)
            {
            }
         }
         if(typeof param1 == "string")
         {
            _loc2_ = String(param1);
         }
         try
         {
            return param1.toString();
         }
         catch(e:Error)
         {
         }
         return " ";
      }
      
      protected function applyEmphasis() : void
      {
         var _loc5_:Object = null;
         var _loc6_:CellRenderer = null;
         var _loc7_:TextFormat = null;
         var _loc8_:TextFormat = null;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         this.dropdown.drawNow();
         var _loc1_:String = this.emphasize.toLowerCase();
         var _loc2_:int = int(this.dropdown.dataProvider.length);
         var _loc3_:uint = 1118481;
         if(World.toggleDarkMode)
         {
            _loc3_ = 15658734;
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = this.dropdown.dataProvider.getItemAt(_loc4_);
            _loc6_ = CellRenderer(this.dropdown.itemToCellRenderer(_loc5_));
            _loc7_ = new TextFormat();
            _loc7_.color = _loc3_;
            _loc7_.size = Window.FONTSIZE;
            _loc7_.align = TextFormatAlign.CENTER;
            _loc8_ = new TextFormat();
            _loc8_.color = _loc3_;
            _loc8_.size = Window.FONTSIZE;
            _loc8_.align = TextFormatAlign.CENTER;
            _loc8_.bold = true;
            if(_loc6_)
            {
               _loc6_.textField.setTextFormat(_loc7_);
               _loc6_.textField.height = this._dropdown.rowHeight;
               _loc9_ = this.itemToLabel(_loc5_);
               _loc10_ = _loc9_.toLowerCase().indexOf(_loc1_);
               if(_loc10_ != -1 && _loc1_.length > 0)
               {
                  _loc6_.textField.setTextFormat(_loc8_,_loc10_,_loc10_ + _loc1_.length);
               }
            }
            _loc4_++;
         }
      }
      
      public function open() : void
      {
         this.displayDropdown(true);
      }
      
      public function close(param1:* = null, param2:Boolean = false) : void
      {
         if(this._showingDropdown)
         {
            if(this._dropdown)
            {
               if(param2)
               {
                  if(this._dropdown.selectedIndex < 0)
                  {
                     this._dropdown.selectedIndex = 0;
                  }
                  this.selectedIndex = this._dropdown.selectedIndex;
               }
               this.displayDropdown(false,param1);
               this.showingDropdown = false;
               invalidate();
            }
         }
      }
      
      private function hasDropdown() : Boolean
      {
         return this._dropdown != null;
      }
      
      private function getDropdown() : List
      {
         if(!this.hasDropdown())
         {
            this._dropdown = new this._popUpRenderer();
            this._dropdown.visible = false;
            this._dropdown.focusEnabled = false;
            if(World.toggleDarkMode == 1)
            {
               this._dropdown.setStyle("skin","AutoCompleteSkinDark");
            }
            else
            {
               this._dropdown.setStyle("skin","AutoCompleteSkin");
            }
            this._dropdown.setStyle("cellRenderer",AutoCompleteCellRenderer);
            if(!this.dataProvider)
            {
               this.dataProvider = new DataProvider();
            }
            this.selectedIndex = -1;
            this._oldIndex = this.selectedIndex;
            this._dropdown.labelField = this._labelField;
            this._dropdown.labelFunction = this._labelFunction;
            this._dropdown.addEventListener(ScrollEvent.SCROLL,this.dropdown_scrollHandler);
            this._dropdown.addEventListener(ListEvent.ITEM_ROLL_OVER,this.dropdown_itemRollOverHandler);
            this._dropdown.addEventListener(ListEvent.ITEM_ROLL_OUT,this.dropdown_itemRollOutHandler);
            this._dropdown.addEventListener(Event.CHANGE,this.dropdown_changeHandler);
            this._dropdown.validateNow();
         }
         return this._dropdown;
      }
      
      protected function displayDropdown(param1:Boolean, param2:Event = null) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Function = null;
         var _loc5_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         if(param1 == this._showingDropdown)
         {
            return;
         }
         if(param1)
         {
            this._selectedIndexOnDropdown = this.selectedIndex;
            this.getDropdown();
            _loc7_ = this._dropdown.selectedIndex;
            _loc8_ = this._dropdown.verticalScrollPosition;
            _loc8_ = _loc7_ - 1;
            _loc8_ = Math.min(Math.max(_loc8_,0),this._dropdown.maxVerticalScrollPosition);
            this._dropdown.verticalScrollPosition = _loc8_;
            this.bRemoveDropdown = false;
            this._showingDropdown = param1;
            _loc4_ = getStyle("openEasingFunction") as Function;
            _loc9_ = getStyleValue("focusRectPadding") as Number;
            this.dropdownWidth = width + 2 * (_loc9_ + getStyleValue("borderThickness"));
         }
         else if(this._dropdown)
         {
            this._showingDropdown = param1;
            _loc4_ = getStyle("closeEasingFunction") as Function;
            this._showingDropdown = param1;
         }
         this.inTween = true;
         if(param1)
         {
            if(this._dropdown.dataProvider.length < 1 || length < 1)
            {
               this._dropdown.dataProvider = this.unfilteredDataProvider.clone();
            }
            this.positionDropdown();
            this._dropdown.alpha = 1;
            this._dropdown.visible = true;
            _loc5_ = Math.max(1,getStyle("openDuration") as Number);
         }
         else if(!param1 && this._dropdown.visible)
         {
            _loc5_ = Math.max(1,getStyle("closeDuration") as Number);
            this.onTweenEnd(0);
         }
         var _loc6_:DropdownEvent = new DropdownEvent(this._showingDropdown ? DropdownEvent.OPEN : DropdownEvent.CLOSE);
         _loc6_.triggerEvent = param2;
         dispatchEvent(_loc6_);
      }
      
      private function dispatchChangeEvent(param1:Event, param2:int, param3:int) : void
      {
         var _loc4_:Event = null;
         if(param2 != param3)
         {
            _loc4_ = param1 is ListEvent ? param1 : new ListEvent("change");
            dispatchEvent(_loc4_);
         }
      }
      
      private function stageAdded(param1:Event) : void
      {
         stage.addChild(this.dropdown);
         stage.addEventListener("mouseDown",this.dropdown_mouseDownOutsideHandler);
         textField.embedFonts = true;
         this.applyEmphasis();
      }
      
      private function destroyDropdown() : void
      {
         if(Boolean(this._dropdown) && !this._showingDropdown)
         {
            stage.removeChild(this._dropdown);
            this._dropdown = null;
         }
      }
      
      private function positionDropdown() : void
      {
         var _loc1_:Point = new Point(-(getStyleValue("focusRectPadding") + getStyle("borderThickness")),height + getStyleValue("focusRectPadding") + getStyle("borderThickness"));
         _loc1_ = localToGlobal(_loc1_);
         if(this._dropdown.rowCount != this.rowCount)
         {
            this._dropdown.rowCount = this.rowCount;
         }
         if(_loc1_.y + this.dropdownHeight > stage.stageHeight && _loc1_.y > this.dropdownHeight)
         {
            _loc1_.y -= height + this.dropdownHeight + getStyleValue("focusRectPadding") + getStyle("borderThickness");
         }
         if(this._dropdown.x != _loc1_.x || this._dropdown.y != _loc1_.y)
         {
            this._dropdown.move(_loc1_.x,_loc1_.y);
         }
      }
      
      override protected function handleChange(param1:Event) : void
      {
         this.typedText = text;
         super.handleChange(param1);
      }
      
      override protected function focusOutHandler(param1:FocusEvent) : void
      {
         if(this._showingDropdown && Boolean(this._dropdown))
         {
            if(!param1.relatedObject || !this._dropdown.contains(param1.relatedObject))
            {
               this.close(null,false);
            }
         }
         super.focusOutHandler(param1);
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc2_:int = 0;
         if(!this.keysEnabled)
         {
            return;
         }
         if(param1.keyCode == Keyboard.ENTER)
         {
            if(this._showingDropdown)
            {
               this.close(null,true);
               param1.stopPropagation();
            }
         }
         else if(param1.keyCode == Keyboard.UP || param1.keyCode == Keyboard.DOWN || param1.keyCode == Keyboard.PAGE_UP || param1.keyCode == Keyboard.PAGE_DOWN)
         {
            if(this._dropdown.visible)
            {
               _loc2_ = this.selectedIndex;
               this.bInKeyDown = this._showingDropdown;
               if(this._dropdown)
               {
                  if(this._dropdown.selectedIndex == this._dropdown.dataProvider.length - 1 && param1.keyCode == Keyboard.DOWN)
                  {
                     this.selectedIndex = 0;
                     param1.stopPropagation();
                  }
                  else if(this._dropdown.selectedIndex == 0 && param1.keyCode == Keyboard.UP)
                  {
                     this.selectedIndex = this._dropdown.dataProvider.length - 1;
                     param1.stopPropagation();
                  }
                  else
                  {
                     switch(param1.keyCode)
                     {
                        case Keyboard.PAGE_UP:
                           this.selectedIndex -= 5;
                           if(this.selectedIndex < 0)
                           {
                              this.selectedIndex = 0;
                           }
                           break;
                        case Keyboard.UP:
                           --this.selectedIndex;
                           if(this.selectedIndex < 0)
                           {
                              this.selectedIndex = 0;
                           }
                           break;
                        case Keyboard.PAGE_DOWN:
                           if(this.selectedIndex < this._dropdown.dataProvider.length - 5)
                           {
                              this.selectedIndex += 5;
                           }
                           break;
                        case Keyboard.DOWN:
                           this.selectedIndex += 1;
                           if(this.selectedIndex > this._dropdown.dataProvider.length - 1)
                           {
                              this.selectedIndex = this._dropdown.dataProvider.length - 1;
                           }
                           break;
                        default:
                           this.selectedIndex = 0;
                           param1.stopPropagation();
                     }
                  }
               }
               this.bInKeyDown = false;
            }
            else
            {
               this.open();
               param1.stopPropagation();
            }
         }
      }
      
      private function dropdown_mouseDownOutsideHandler(param1:MouseEvent) : void
      {
         if(!this._showingDropdown)
         {
            return;
         }
         if(!contains(param1.target as DisplayObject) && !this.dropdown.contains(param1.target as DisplayObject))
         {
            this.close(param1,false);
         }
      }
      
      private function dropdown_scrollHandler(param1:Event) : void
      {
         var _loc2_:ScrollEvent = null;
         if(param1 is ScrollEvent)
         {
            _loc2_ = ScrollEvent(param1);
            dispatchEvent(_loc2_);
            this.applyEmphasis();
         }
      }
      
      private function dropdown_itemRollOverHandler(param1:Event) : void
      {
         dispatchEvent(param1);
      }
      
      private function dropdown_itemRollOutHandler(param1:Event) : void
      {
         dispatchEvent(param1);
      }
      
      private function dropdown_changeHandler(param1:Event) : void
      {
         var _loc2_:int = this.selectedIndex;
         if(this._dropdown)
         {
            this.selectedIndex = this._dropdown.selectedIndex;
         }
         if(!this._showingDropdown)
         {
            this.dispatchChangeEvent(param1,_loc2_,this.selectedIndex);
         }
         else if(!this.bInKeyDown)
         {
            this.close(param1,false);
         }
      }
      
      private function unloadHandler(param1:Event) : void
      {
         this.inTween = false;
         if(this._dropdown)
         {
            removeChild(this._dropdown);
         }
      }
      
      private function onTweenEnd(param1:Number) : void
      {
         if(this._dropdown)
         {
            this._dropdown.alpha = 1;
            this.inTween = false;
            this._dropdown.visible = this._showingDropdown;
         }
      }
      
      override protected function initializeAccessibility() : void
      {
         if(AutoComplete.createAccessibilityImplementation != null)
         {
            AutoComplete.createAccessibilityImplementation(this);
         }
      }
   }
}

