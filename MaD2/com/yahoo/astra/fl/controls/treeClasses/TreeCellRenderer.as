package com.yahoo.astra.fl.controls.treeClasses
{
   import com.anegmetex.Soundmanager.sounds;
   import com.hybrid.ui.ToolTip;
   import com.yahoo.astra.fl.controls.Tree;
   import fl.controls.LabelButton;
   import fl.controls.listClasses.ICellRenderer;
   import fl.controls.listClasses.ListData;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.AntiAliasType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class TreeCellRenderer extends LabelButton implements ICellRenderer
   {
      
      private static var defaultStyles:Object = {
         "upSkin":"TreeCellRenderer_upSkin",
         "upSkinDark":"TreeCellRenderer_upSkinDark",
         "downSkin":"TreeCellRenderer_downSkin",
         "overSkin":"TreeCellRenderer_overSkin",
         "disabledSkin":"TreeCellRenderer_disabledSkin",
         "selectedDisabledSkin":"TreeCellRenderer_selectedDisabledSkin",
         "selectedUpSkin":"TreeCellRenderer_selectedUpSkin",
         "selectedDownSkin":"TreeCellRenderer_selectedDownSkin",
         "selectedOverSkin":"TreeCellRenderer_selectedOverSkin",
         "closedBranchIcon":"TreeCellRenderer_closedBranchIcon",
         "openBranchIcon":"TreeCellRenderer_openBranchIcon",
         "leafIcon":"TreeCellRenderer_leafIcon",
         "ToggleOn":"TreeCellRenderer_toggleOn",
         "ToggleOff":"TreeCellRenderer_toggleOff",
         "textFormat":null,
         "disabledTextFormat":null,
         "embedFonts":true,
         "textPadding":4,
         "nodeIndent":4,
         "margin":2
      };
      
      protected var _listData:ListData;
      
      protected var _data:Object;
      
      public function TreeCellRenderer()
      {
         super();
         toggle = true;
         focusEnabled = false;
         textField.antiAliasType = AntiAliasType.ADVANCED;
         textField.sharpness = -100;
         this.addEventListener(MouseEvent.CLICK,this.handleClickEvent,false,0,true);
      }
      
      public static function getStyleDefinition() : Object
      {
         return mergeStyles(defaultStyles,LabelButton.getStyleDefinition());
      }
      
      private function handleClickEvent(param1:MouseEvent) : void
      {
         var _loc2_:TNode = this.data as TNode;
         if(this.icon != null && _loc2_ is BranchNode && this.icon.x <= this.mouseX && this.mouseX <= this.icon.x + this.icon.width && this.icon.y <= this.mouseY && this.mouseY <= this.icon.y + this.icon.height)
         {
            param1.stopImmediatePropagation();
            if(_loc2_.isOpen())
            {
               _loc2_.closeNode();
            }
            else
            {
               _loc2_.openNode();
            }
         }
      }
      
      override public function setSize(param1:Number, param2:Number) : void
      {
         super.setSize(param1,param2);
      }
      
      public function get listData() : ListData
      {
         return this._listData;
      }
      
      public function set listData(param1:ListData) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Sprite = null;
         var _loc6_:Sprite = null;
         this._listData = param1;
         label = this._listData.label;
         var _loc2_:Tree = this._listData.owner as Tree;
         if(this.data.nodeType == TreeDataProvider.BRANCH_NODE)
         {
            if(this.data.nodeState == TreeDataProvider.OPEN_NODE)
            {
               if(this.data.ico)
               {
                  setStyle("icon",new Bitmap(R.getSprite(this.data.ico)));
               }
               else if(_loc2_.iconFunction != null)
               {
                  setStyle("icon",_loc2_.iconFunction(this.data));
               }
               else if(_loc2_.openBranchIconField != null && this.data[_loc2_.openBranchIconField] != null)
               {
                  setStyle("icon",this.data[_loc2_.openBranchIconField]);
               }
               else
               {
                  setStyle("icon",getStyleValue("openBranchIcon"));
               }
            }
            else if(this.data.nodeState == TreeDataProvider.CLOSED_NODE)
            {
               if(this.data.ico)
               {
                  setStyle("icon",new Bitmap(R.getSprite(this.data.ico)));
               }
               else if(_loc2_.iconFunction != null)
               {
                  setStyle("icon",_loc2_.iconFunction(this.data));
               }
               else if(_loc2_.closedBranchIconField != null && this.data[_loc2_.closedBranchIconField] != null)
               {
                  setStyle("icon",this.data[_loc2_.closedBranchIconField]);
               }
               else
               {
                  setStyle("icon",getStyleValue("closedBranchIcon"));
               }
            }
         }
         else if(_loc2_.iconFunction != null)
         {
            setStyle("icon",_loc2_.iconFunction(this.data));
         }
         else if(_loc2_.openBranchIconField != null && this.data[_loc2_.leafIconField] != null)
         {
            setStyle("icon",this.data[_loc2_.leafIconField]);
         }
         else if(this.data.func == "spacer")
         {
            setStyle("overSkin",defaultStyles["downSkin"]);
            setStyle("upSkin",defaultStyles["downSkin"]);
            setStyle("upSkinDark",defaultStyles["downSkin"]);
            setStyle("icon","");
         }
         else if(this.data.toggleValue)
         {
            if(this.data.toggleValue == "0")
            {
               setStyle("icon",getStyleValue("ToggleOff"));
            }
            else if(this.data.toggleValue == "1")
            {
               setStyle("icon",getStyleValue("ToggleOn"));
            }
         }
         else if(this.data.ico)
         {
            setStyle("icon",new Bitmap(R.getSprite(this.data.ico)));
         }
         else if(this.data.lab)
         {
            setStyle("icon",new Bitmap(R.getSprite("iconmadlabsmall")));
         }
         else
         {
            setStyle("icon","");
         }
         if(Boolean(this._data.background) && this._data.background.substr(0,1) == "#")
         {
            _loc3_ = uint("0x" + String(this._data.background).substr(1,6));
            _loc4_ = GraphicUtils.scalehex(_loc3_,1.2);
            _loc5_ = new Sprite();
            _loc5_.graphics.beginFill(_loc4_);
            _loc5_.graphics.drawRect(0,0,10,10);
            _loc5_.graphics.endFill();
            _loc6_ = new Sprite();
            _loc6_.graphics.beginFill(_loc3_);
            _loc6_.graphics.drawRect(0,0,10,10);
            _loc6_.graphics.endFill();
            setStyle("overSkin",_loc5_);
            setStyle("selectedOverSkin",_loc5_);
            setStyle("selectedUpSkin",_loc6_);
            setStyle("selectedDownSkin",_loc6_);
         }
         else
         {
            setStyle("overSkin",defaultStyles.overSkin);
            setStyle("selectedOverSkin",defaultStyles.selectedOverSkin);
            setStyle("selectedUpSkin",defaultStyles.selectedUpSkin);
            setStyle("selectedDownSkin",defaultStyles.selectedDownSkin);
         }
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
      }
      
      override public function get selected() : Boolean
      {
         return super.selected;
      }
      
      override public function set selected(param1:Boolean) : void
      {
         super.selected = param1;
      }
      
      override protected function toggleSelected(param1:MouseEvent) : void
      {
      }
      
      override protected function drawLayout() : void
      {
         var _loc5_:uint = 0;
         var _loc7_:* = undefined;
         var _loc8_:Number = NaN;
         var _loc1_:Number = Number(getStyleValue("textPadding"));
         var _loc2_:Number = Number(getStyleValue("nodeIndent"));
         var _loc3_:Number = Number(getStyleValue("margin"));
         var _loc4_:TextFormat = textField.getTextFormat();
         if(this.data is BranchNode)
         {
            _loc4_.bold = true;
         }
         if(this.data.center)
         {
            _loc4_.align = TextFormatAlign.CENTER;
         }
         if(Boolean(this._data.label) && this._data.label.substr(0,1) == "#")
         {
            _loc5_ = uint("0x" + String(this._data.label).substr(1,6));
         }
         else if(Boolean(this._data.background) && this._data.background.substr(0,1) == "#")
         {
            _loc5_ = uint("0x" + String(this._data.background).substr(1,6));
         }
         if(_loc5_)
         {
            _loc7_ = GraphicUtils.hexBrightness(_loc5_);
            if(_loc7_ < 14000)
            {
               _loc4_.color = 14540253;
            }
            else
            {
               _loc4_.color = 1118481;
            }
         }
         textField.setTextFormat(_loc4_);
         var _loc6_:Tree = this._listData.owner as Tree;
         if(icon != null)
         {
            if(this.data.lab)
            {
               icon.x = -2 + width - icon.width - _loc3_ - (_loc6_.verticalScrollBar.visible ? 4 : 0);
            }
            else if(icon.width < 32)
            {
               icon.x = _loc3_ - 1 + this.data.nodeLevel * _loc2_ + (16 - icon.width * 0.5);
            }
            else
            {
               icon.x = _loc3_ - 1 + this.data.nodeLevel * _loc2_;
            }
            icon.y = Math.round(height - icon.height >> 1);
         }
         if(label.length > 0)
         {
            textField.visible = true;
            if(icon)
            {
               textField.width = width - icon.width - _loc1_ - 8;
            }
            else
            {
               textField.width = width;
               -_loc1_ - 8;
            }
            textField.height = height;
            if(this.data.lab)
            {
               textField.x = _loc1_ + _loc3_ + this.data.nodeLevel * _loc2_;
            }
            else if(this.data.center)
            {
               if(icon)
               {
                  textField.x = icon.width;
               }
               else
               {
                  textField.x = 0;
               }
            }
            else if(icon)
            {
               textField.x = _loc1_ + icon.x + icon.width + _loc3_;
            }
            else
            {
               textField.x = _loc1_ + _loc3_ + this.data.nodeLevel * _loc2_;
            }
            textField.y = -3 + (textField.height - textField.textHeight) >> 1;
         }
         else
         {
            textField.visible = false;
         }
         if(background)
         {
            _loc8_ = this.data.nodeLevel * _loc2_;
            if(this.data.center)
            {
               background.width = width - _loc8_ * 2 - (_loc6_.verticalScrollBar.visible ? 4 : 0);
               background.x = _loc8_;
            }
            else
            {
               background.width = width - _loc8_ - (_loc6_.verticalScrollBar.visible ? 4 : 0);
               background.x = _loc8_;
            }
            background.height = height;
         }
      }
      
      override protected function drawBackground() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Sprite = null;
         if(this._data.func != "spacer")
         {
            if(Boolean(this._data.label) && this._data.label.substr(0,1) == "#")
            {
               _loc1_ = uint("0x" + String(this._data.label).substr(1,6));
            }
            else if(Boolean(this._data.background) && this._data.background.substr(0,1) == "#")
            {
               _loc1_ = uint("0x" + String(this._data.background).substr(1,6));
            }
            if(_loc1_)
            {
               _loc2_ = new Sprite();
               _loc2_.graphics.beginFill(_loc1_);
               _loc2_.graphics.drawRect(0,0,10,10);
               _loc2_.graphics.endFill();
               setStyle("upSkin",_loc2_);
            }
            else if(this._listData.index % 2 == 0 || Boolean(this._data.noReadabilityTint))
            {
               setStyle("upSkin",defaultStyles.upSkinDark);
            }
            else
            {
               setStyle("upSkin",defaultStyles.upSkin);
            }
            super.drawBackground();
         }
      }
      
      override protected function mouseEventHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:ToolTip = null;
         var _loc4_:TextFormat = null;
         super.mouseEventHandler(param1);
         if(param1.type == MouseEvent.ROLL_OVER)
         {
            sounds.play("ui_hover",null,null,0.5);
            if(this.data.tooltip)
            {
               _loc2_ = this.data.tooltip;
               _loc3_ = new ToolTip();
               _loc3_.colors = [GameState.ui.menuMain.BACKGROUNDCOLOUR,GameState.ui.menuMain.BACKGROUNDCOLOUR];
               _loc3_.border = GameState.ui.menuMain.BORDERCOLOUR;
               _loc3_.cornerRadius = 8;
               _loc3_.buffer = Window.BUFFER;
               _loc3_.followMouse = false;
               _loc3_.tipPosition = "left";
               _loc3_.hookSize = 0;
               _loc3_.tipHeight = 24;
               if(_loc2_.split("\n").length > 0)
               {
                  _loc3_.tipHeight = 24 * (_loc2_.split("\n").length + 1);
               }
               _loc3_.tipWidth = 200;
               _loc4_ = new TextFormat(Window.FONT,Window.FONTSIZE,GameState.ui.menuMain.FONTCOLOUR);
               _loc4_.leading = 0;
               _loc3_.contentFormat = _loc4_;
               _loc3_.delay = 200;
               _loc3_.show(DisplayObject(param1.currentTarget),"",_loc2_);
            }
         }
      }
   }
}

