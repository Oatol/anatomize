package
{
   import com.bit101.components.HUISlider;
   import com.bit101.components.RangeSlider;
   import com.bit101.components.UISlider;
   import com.hybrid.ui.ToolTip;
   import com.yahoo.astra.fl.controls.Tree;
   import com.yahoo.astra.fl.controls.treeClasses.BranchNode;
   import com.yahoo.astra.fl.controls.treeClasses.TNode;
   import com.yahoo.astra.fl.controls.treeClasses.TreeCellRenderer;
   import com.yahoo.astra.fl.controls.treeClasses.TreeDataProvider;
   import fl.controls.BaseButton;
   import fl.controls.LabelButton;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.ui.Mouse;
   import flash.utils.getQualifiedClassName;
   
   public class Window extends Sprite
   {
      
      public static const BUFFER:int = 2;
      
      public static var FONT:String = Tweak.FONT;
      
      public static const FONTSIZE:int = 14;
      
      public static const BUTTON_CLOSE:String = "close";
      
      public static const BUTTON_MINIMISE:String = "minimise";
      
      public static const BUTTON_MAXIMISE:String = "maximise";
      
      public static const BUTTON_RESIZE:String = "resize";
      
      public var FONTCOLOUR:uint = 13553358;
      
      public var BUTTONCOLOUR:uint = 13553358;
      
      public var BACKGROUNDCOLOUR:uint = 2236962;
      
      public var FIELDBACKGROUNDCOLOUR:uint = 1118481;
      
      public var BORDERCOLOUR:uint = 3355443;
      
      public var TOPBARCOLOUR:uint = 1381653;
      
      public var LINEWIDTH:int = 1;
      
      private var _titlefield:TextField;
      
      private var _enabled:Boolean;
      
      private var _addedToStage:Boolean = false;
      
      private var _minimised:Boolean = false;
      
      private var _maximised:Boolean = false;
      
      private var _locked:Boolean = false;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _alpha:Number = 1;
      
      private var _borderalpha:Number = 1;
      
      private var _fieldPosition:Number = 0;
      
      private var _sliders:Vector.<HUISlider> = new Vector.<HUISlider>();
      
      private var _textfields:Vector.<TextField> = new Vector.<TextField>();
      
      private var _trees:Vector.<Tree> = new Vector.<Tree>();
      
      private var _others:Vector.<DisplayObject> = new Vector.<DisplayObject>();
      
      private var _mousedown:Boolean = false;
      
      private var _draggable:Boolean = true;
      
      private var _dragging:Boolean = false;
      
      private var _selected:Boolean = false;
      
      private var _dragpos:Point = new Point();
      
      private var _ignoreDrag:Array = [];
      
      private var _tooltips:Array = [];
      
      private var _tooltipTexts:Array = [];
      
      public var buttonSize:Number = 18;
      
      public var minWidth:Number = 42;
      
      public var maxWidth:Number;
      
      public var maxHeight:Number;
      
      private var _maximiseHeight:Number;
      
      public var minimiseHeight:Number;
      
      public var transitionSpeed:Number = 0.6;
      
      private var _collapseInsteadOfMinimising:Boolean = false;
      
      public var ignorePosition:Boolean = false;
      
      public var undocked:Boolean = false;
      
      private var resizeBy:Number = 1;
      
      private var startResizePos:Point;
      
      private var startResizeSize:Number;
      
      private var inputChangeField:TextField;
      
      private var inputChangePos:Point;
      
      private var inputChangeValue:Number;
      
      private var dragSteppers:Array = [];
      
      private var dragSteps:Array = [];
      
      private var _dulin:Rectangle;
      
      public var allowInputDrag:Boolean = true;
      
      public function Window(param1:Number, param2:Number, param3:String, param4:Boolean = true, param5:Boolean = true, param6:Boolean = false, param7:Boolean = false)
      {
         super();
         this.name = param3;
         this.setSize(param1,param2);
         this._titlefield = new TextField();
         this._titlefield.embedFonts = true;
         this._titlefield.antiAliasType = AntiAliasType.ADVANCED;
         this._titlefield.sharpness = -100;
         this._titlefield.defaultTextFormat = new TextFormat(FONT,FONTSIZE - 2,this.FONTCOLOUR,true);
         this._titlefield.x = BUFFER * 3;
         this._titlefield.width = param1 - BUFFER * 2;
         this._titlefield.height = this.buttonSize;
         this._titlefield.y = 0;
         this._titlefield.text = param3;
         this._titlefield.name = "windowtitle";
         this._titlefield.mouseEnabled = false;
         this.addChild(this._titlefield);
         this.movePosition(this.buttonSize + BUFFER * 2);
         this.registerListeners();
         if(param4)
         {
            this.addButton(BUTTON_CLOSE);
         }
         if(param5)
         {
            this.addButton(BUTTON_MINIMISE);
         }
         if(param7)
         {
            this.addButton(BUTTON_RESIZE);
         }
         if(param6)
         {
            this.addButton("maximise");
         }
         this.drawWindow();
         this.ignoreDrag(getQualifiedClassName(new LabelButton()));
         this.ignoreDrag(getQualifiedClassName(new BaseButton()));
         GameState.menuHandler.addMenu(this);
      }
      
      public function set title(param1:String) : void
      {
         if(!param1)
         {
            param1 = "";
         }
         this._titlefield.text = param1;
         this.redraw();
      }
      
      public function get title() : String
      {
         return this._titlefield.text;
      }
      
      public function getValue(param1:String) : *
      {
         var _loc2_:DisplayObject = getChildByName(param1);
         if(!_loc2_)
         {
            return -1;
         }
         if(_loc2_ is TextField)
         {
            return TextField(_loc2_).text;
         }
         if(_loc2_ is UISlider)
         {
            return UISlider(_loc2_).value;
         }
         return -1;
      }
      
      public function setValue(param1:String, param2:*) : void
      {
         if(param2 == null)
         {
            return;
         }
         var _loc3_:DisplayObject = getChildByName(param1);
         if(!_loc3_)
         {
            return;
         }
         if(_loc3_ is TextField)
         {
            TextField(getChildByName(param1)).text = param2;
         }
         else if(_loc3_ is UISlider)
         {
            UISlider(_loc3_).value = Number(param2);
         }
      }
      
      public function getTreeValue(param1:String, param2:String, param3:String) : String
      {
         var _loc6_:Object = null;
         var _loc7_:String = null;
         var _loc9_:Array = null;
         var _loc10_:TNode = null;
         var _loc4_:Tree = Tree(getChildByName(param1));
         if(!_loc4_)
         {
            return null;
         }
         var _loc5_:* = _loc4_.length;
         var _loc8_:int = 0;
         while(_loc8_ < _loc5_)
         {
            _loc6_ = _loc4_.getItemAt(_loc8_);
            if(_loc6_ is BranchNode)
            {
               _loc9_ = BranchNode(_loc6_).children;
               for each(_loc10_ in _loc9_)
               {
                  if(_loc10_.label == param2)
                  {
                     _loc7_ = this.getNodeValue(_loc10_,param3);
                     if(_loc7_)
                     {
                        return _loc7_;
                     }
                  }
               }
            }
            if(_loc6_.label == param2)
            {
               _loc7_ = this.getNodeValue(_loc6_,param3);
               if(_loc7_)
               {
                  return _loc7_;
               }
            }
            _loc8_++;
         }
         return null;
      }
      
      private function getNodeValue(param1:Object, param2:String) : String
      {
         var _loc3_:String = null;
         for each(_loc3_ in param1)
         {
            if(Boolean(param1[param2]) && _loc3_ == param1[param2])
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         if(param1.name != "windowtitle" && param1.name != "close" && param1.name != "minimise" && param1.name != "maximise" && param1.name != "resize")
         {
            if(!this.ignorePosition && param1.y + param1.height >= this._fieldPosition)
            {
               this.movePosition(param1.height + BUFFER);
            }
            if(param1.y < this.buttonSize + BUFFER * 2)
            {
               param1.y = this.buttonSize + BUFFER * 2;
            }
            if(param1.x < BUFFER)
            {
               param1.x = BUFFER;
            }
            if(!this.ignorePosition && param1.x + param1.width >= this._width)
            {
               this._width = param1.x + param1.width;
               this.drawWindow();
            }
            if(!this.ignorePosition && param1.y + param1.height >= this._height)
            {
               this._height = param1.y + param1.height;
               this.drawWindow();
            }
            if(this.maxHeight != this._height)
            {
               this.maxHeight = this._height;
            }
         }
         param1.name = param1.name;
         var _loc2_:DisplayObject = super.addChild(param1);
         if(this.hasResizeButton())
         {
            super.addChild(this.getChildByName(BUTTON_RESIZE));
         }
         return _loc2_;
      }
      
      public function addRangeSlider(param1:String, param2:Number, param3:Number, param4:Number, param5:Number = 100, param6:Number = 16) : *
      {
         var _loc7_:RangeSlider = new RangeSlider(RangeSlider.HORIZONTAL,this,BUFFER * 3,this._fieldPosition);
         _loc7_.labelPrecision = 0;
         _loc7_.name = param1;
         _loc7_.labelPosition = RangeSlider.CENTER;
         this._fieldPosition += 20 - BUFFER * 2;
         _loc7_.y += 8;
         this.ignoreDrag("slider_minhandle");
         this.ignoreDrag("slider_maxhandle");
         this.ignoreDrag("slider_minlabel");
         this.ignoreDrag("slider_maxlabel");
         this.ignoreDrag("slider_back");
         this.addChild(_loc7_);
         if(param5 == 100)
         {
            param5 = this.actualWidth - BUFFER * 6;
         }
         _loc7_.setSize(param5,param6);
         return _loc7_;
      }
      
      public function addSlider(param1:String, param2:Number, param3:Number = 0, param4:Number = 100, param5:Number = 100, param6:Number = 16, param7:int = 5) : HUISlider
      {
         var _loc8_:HUISlider = new HUISlider(this,BUFFER * 3,this._fieldPosition,param1);
         _loc8_.tabEnabled = false;
         _loc8_.tabChildren = false;
         _loc8_.labelPrecision = 0;
         _loc8_.name = param1;
         _loc8_.setSliderParams(param3,param4,param2);
         this.ignoreDrag("slider_handle");
         this.ignoreDrag("slider_back");
         this.ignoreDrag("slider_label");
         this._fieldPosition += 20 - BUFFER * 2;
         _loc8_.y += 16;
         this.addChild(_loc8_);
         if(param5 == 100)
         {
            param5 = this.actualWidth - BUFFER * 6;
         }
         _loc8_.setSize(param5,param6);
         _loc8_.originalValueSnap = param7;
         this._sliders.push(_loc8_);
         return _loc8_;
      }
      
      public function removeGadget(param1:String) : void
      {
         var _loc2_:DisplayObject = this.getGadget(param1);
         if(_loc2_)
         {
            if(_loc2_ is HUISlider)
            {
               this._sliders.splice(this._sliders.indexOf(_loc2_),1);
            }
            this.movePosition(-_loc2_.height);
            removeChild(_loc2_);
         }
      }
      
      private function changeIntoField(param1:MouseEvent) : void
      {
         param1.currentTarget.visible = false;
      }
      
      public function addInput(param1:String, param2:*, param3:* = null, param4:* = null, param5:String = "0-9", param6:Number = 6, param7:Boolean = true) : TextField
      {
         var _loc8_:TextField = new TextField();
         var _loc9_:TextField = new TextField();
         _loc9_.border = true;
         _loc9_.borderColor = this.BORDERCOLOUR;
         if(!param3)
         {
            _loc9_.width = this._width * 0.25;
         }
         else
         {
            _loc9_.width = param3;
         }
         if(!param4)
         {
            _loc9_.height = 22;
         }
         else
         {
            _loc9_.height = param4;
         }
         if(String(param2).indexOf("-") != -1)
         {
            param6++;
         }
         _loc9_.restrict = param5;
         _loc9_.maxChars = param6;
         _loc9_.defaultTextFormat = new TextFormat(FONT,FONTSIZE,this.FONTCOLOUR,true,null,null,null,null,TextFormatAlign.CENTER);
         _loc9_.type = TextFieldType.INPUT;
         _loc9_.background = true;
         _loc9_.backgroundColor = this.FIELDBACKGROUNDCOLOUR;
         _loc9_.border = true;
         _loc9_.borderColor = this.BORDERCOLOUR;
         _loc9_.text = param2;
         _loc9_.name = param1;
         _loc8_.mouseEnabled = false;
         _loc8_.x = _loc9_.x + _loc9_.width + BUFFER * 2;
         _loc8_.y = this._fieldPosition;
         _loc8_.width = this._width - _loc8_.x - BUFFER * 2;
         _loc8_.height = 22;
         _loc8_.defaultTextFormat = new TextFormat(FONT,FONTSIZE,this.FONTCOLOUR);
         _loc8_.text = param1;
         _loc8_.name = "inputtitle";
         _loc8_.x = _loc9_.x + _loc9_.width + BUFFER * 4;
         _loc8_.y = this._fieldPosition;
         _loc9_.x = BUFFER * 3;
         _loc9_.y = this._fieldPosition;
         _loc8_.embedFonts = true;
         _loc8_.antiAliasType = AntiAliasType.ADVANCED;
         _loc8_.sharpness = -100;
         _loc9_.embedFonts = true;
         _loc9_.antiAliasType = AntiAliasType.ADVANCED;
         _loc9_.sharpness = -100;
         if(this.allowInputDrag)
         {
            _loc8_.addEventListener(MouseEvent.MOUSE_DOWN,this.focusInputField);
            _loc8_.addEventListener(MouseEvent.MOUSE_OVER,this.cursorDrag);
            _loc8_.addEventListener(MouseEvent.MOUSE_OUT,this.cursorNormal);
         }
         if(param7)
         {
            this.addChild(_loc8_);
            this._textfields.push(_loc8_);
         }
         this._textfields.push(_loc9_);
         this.addChild(_loc9_);
         return _loc9_;
      }
      
      public function setDragStep(param1:String, param2:int) : *
      {
         this.dragSteppers.push(param1);
         this.dragSteps.push(param2);
      }
      
      private function cursorDrag(param1:MouseEvent) : void
      {
         Mouse.cursor = "hand";
      }
      
      private function cursorNormal(param1:MouseEvent) : void
      {
         Mouse.cursor = "auto";
         removeEventListener(Event.ENTER_FRAME,this.dragChange);
      }
      
      private function focusInputField(param1:MouseEvent) : void
      {
         var _loc2_:TextField = TextField(this._textfields[this._textfields.indexOf(param1.target) + 1]);
         this.inputChangeField = _loc2_;
         this.inputChangePos = new Point(mouseX,mouseY);
         this.inputChangeValue = Number(_loc2_.text);
         addEventListener(Event.ENTER_FRAME,this.dragChange);
         addEventListener(MouseEvent.MOUSE_UP,this.stopDragChange);
         stage.focus = _loc2_;
      }
      
      private function stopDragChange(param1:MouseEvent) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.dragChange);
      }
      
      private function dragChange(param1:Event) : void
      {
         if(Math.abs(this.inputChangePos.y - mouseY) > 40)
         {
            removeEventListener(Event.ENTER_FRAME,this.dragChange);
            return;
         }
         var _loc2_:int = 5;
         var _loc3_:int = this.dragSteppers.indexOf(this.inputChangeField.name);
         if(_loc3_ != -1)
         {
            _loc2_ = int(this.dragSteps[_loc3_]);
         }
         var _loc4_:Number = Number(this.inputChangeField.text);
         _loc4_ = this.inputChangeValue + (mouseX - this.inputChangePos.x) * _loc2_;
         _loc4_ >> 0;
         this.inputChangeField.text = _loc4_.toString();
         this.inputChangeField.dispatchEvent(new Event(Event.CHANGE,true));
      }
      
      private function omo(param1:MouseEvent) : void
      {
         var _loc2_:int = this._tooltips.indexOf(param1.currentTarget.name);
         var _loc3_:String = this._tooltipTexts[_loc2_];
         var _loc4_:ToolTip = new ToolTip();
         _loc4_.colors = [this.BACKGROUNDCOLOUR,this.BACKGROUNDCOLOUR];
         _loc4_.bgAlpha = this._alpha;
         _loc4_.border = this.BORDERCOLOUR;
         _loc4_.cornerRadius = 8;
         _loc4_.buffer = BUFFER;
         _loc4_.followMouse = false;
         _loc4_.tipPosition = "left";
         _loc4_.hookSize = 0;
         _loc4_.tipHeight = 22;
         if(_loc3_.split("\n").length > 0)
         {
            _loc4_.tipHeight = 22 * _loc3_.split("\n").length;
         }
         _loc4_.tipWidth = this._width;
         var _loc5_:TextFormat = new TextFormat(FONT,FONTSIZE,this.FONTCOLOUR);
         _loc5_.leading = 0;
         _loc4_.contentFormat = _loc5_;
         _loc4_.delay = 200;
         _loc4_.show(this,"",_loc3_);
      }
      
      public function addField(param1:String, param2:*, param3:* = null, param4:* = null) : TextField
      {
         var _loc5_:TextField = new TextField();
         if(!param3)
         {
            _loc5_.width = this._width - BUFFER * 4;
         }
         else
         {
            _loc5_.width = param3;
         }
         if(_loc5_.width > this._width - BUFFER * 4)
         {
            _loc5_.width = this._width - BUFFER * 4;
         }
         _loc5_.wordWrap = true;
         if(!param4)
         {
            _loc5_.height = 20;
         }
         else
         {
            _loc5_.height = param4;
         }
         var _loc6_:TextFormat = new TextFormat(FONT,FONTSIZE,this.FONTCOLOUR);
         _loc6_.align = TextFormatAlign.LEFT;
         _loc6_.leftMargin = BUFFER;
         _loc6_.rightMargin = BUFFER;
         _loc5_.defaultTextFormat = _loc6_;
         _loc5_.text = param2;
         _loc5_.name = param1;
         _loc5_.wordWrap = true;
         _loc5_.border = true;
         _loc5_.borderColor = this.BORDERCOLOUR;
         _loc5_.x = BUFFER * 2;
         _loc5_.y = this._fieldPosition;
         _loc5_.embedFonts = true;
         _loc5_.antiAliasType = AntiAliasType.ADVANCED;
         _loc5_.sharpness = -100;
         this._textfields.push(_loc5_);
         this.addChild(_loc5_);
         return _loc5_;
      }
      
      public function collapse() : void
      {
         this.resizeBy = this.transitionSpeed;
         this.addEventListener(Event.ENTER_FRAME,this.resizer);
      }
      
      public function expand() : void
      {
         this.resizeBy = 1 / this.transitionSpeed;
         this.addEventListener(Event.ENTER_FRAME,this.resizer);
      }
      
      private function resizer(param1:Event) : void
      {
         this.changeWidth(this.resizeBy);
         if(this._width == this.minWidth || this._width == this.maxWidth)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.resizer);
            if(this._width == this.minWidth)
            {
               this._minimised = true;
               dispatchEvent(new WindowEvent(WindowEvent.ON_MINIMISE,this.name));
            }
            else
            {
               this._minimised = false;
            }
         }
      }
      
      public function changeWidth(param1:Number) : *
      {
         var _loc4_:Tree = null;
         var _loc5_:int = 0;
         var _loc6_:TextField = null;
         var _loc7_:int = 0;
         var _loc8_:DisplayObject = null;
         var _loc2_:Boolean = false;
         if(this.x < stage.stageWidth >> 1)
         {
            _loc2_ = false;
         }
         if(this.x > stage.stageWidth >> 1)
         {
            _loc2_ = true;
         }
         var _loc3_:Number = this._width;
         if(this._width * param1 < this.minWidth)
         {
            this._width = this.minWidth;
         }
         else if(this._width * param1 > this.maxWidth)
         {
            this._width = this.maxWidth;
         }
         else
         {
            this._width *= param1;
         }
         if(_loc2_)
         {
            this.x -= (this._width - _loc3_) * Tweak.UIScale;
         }
         for each(_loc4_ in this._trees)
         {
            _loc4_.setSize(this._width - BUFFER * 4,_loc4_.height);
         }
         _loc5_ = 0;
         if(this.hasCloseButton())
         {
            _loc5_++;
         }
         if(this.hasMinimiseButton())
         {
            _loc5_++;
         }
         if(this._width != this.minWidth)
         {
            this._titlefield.width = this._width - _loc5_ * this.buttonSize - BUFFER * 2;
         }
         else
         {
            this._titlefield.width = 0;
         }
         for each(_loc6_ in this._textfields)
         {
            if(_loc6_.type != TextFieldType.INPUT)
            {
               if(_loc6_.textWidth > this._width - BUFFER * 16)
               {
                  if(_loc6_.visible)
                  {
                     _loc6_.alpha *= 0.6;
                     if(_loc6_.alpha <= 0.1)
                     {
                        _loc6_.visible = false;
                     }
                  }
               }
               else
               {
                  if(!_loc6_.visible)
                  {
                     _loc6_.visible = true;
                     _loc6_.alpha = 0.1;
                  }
                  _loc6_.alpha *= 1 / 0.6;
                  if(_loc6_.alpha >= 0.9 || this._width > this.maxWidth * 0.5)
                  {
                     _loc6_.alpha = 1;
                  }
               }
            }
         }
         _loc7_ = 0;
         while(_loc7_ < this.numChildren)
         {
            _loc8_ = this.getChildAt(_loc7_);
            if(_loc8_.name != "windowtitle" && _loc8_.name != "close" && _loc8_.name != "minimise")
            {
               if(this._width < _loc8_.x + _loc8_.width)
               {
                  _loc8_.visible = false;
               }
               else
               {
                  _loc8_.visible = true;
               }
            }
            _loc7_++;
         }
         this.drawWindow();
         this.checkBounds();
      }
      
      public function addOther(param1:DisplayObject) : void
      {
         this._others.push(param1);
         this.addChild(param1);
      }
      
      public function addTree(param1:String, param2:XML, param3:Number = 0, param4:Number = 0, param5:Number = 32) : Tree
      {
         var _loc6_:Tree = new Tree();
         _loc6_.tabEnabled = false;
         _loc6_.name = param1;
         _loc6_.x = BUFFER * 2;
         _loc6_.y = this._fieldPosition;
         if(param3 <= 0)
         {
            _loc6_.height = param2.children().length() * param5;
         }
         else
         {
            _loc6_.height = param3;
         }
         if(param4 <= 0)
         {
            _loc6_.width = this._width - BUFFER * 4;
         }
         else
         {
            _loc6_.width = param4;
         }
         _loc6_.dataProvider = new TreeDataProvider(param2);
         _loc6_.setRendererStyle("textFormat",new TextFormat(FONT,FONTSIZE,this.FONTCOLOUR));
         _loc6_.rowHeight = param5;
         this._trees.push(_loc6_);
         this.addChild(_loc6_);
         return _loc6_;
      }
      
      public function removeAllTrees() : void
      {
         var _loc1_:Tree = null;
         for each(_loc1_ in this._trees)
         {
            removeChild(_loc1_);
         }
         this._trees = new Vector.<Tree>();
      }
      
      public function removeAllFields() : *
      {
         var _loc1_:TextField = null;
         for each(_loc1_ in this._textfields)
         {
            if(_loc1_.hasEventListener(MouseEvent.MOUSE_OVER))
            {
               this.remTooltip(_loc1_.name);
            }
            removeChild(_loc1_);
         }
         this._textfields = new Vector.<TextField>();
      }
      
      public function removeAllChildren() : *
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:HUISlider = null;
         this.removeAllTrees();
         for each(_loc1_ in this._others)
         {
            removeChild(_loc1_);
         }
         this.removeAllFields();
         for each(_loc2_ in this._sliders)
         {
            if(_loc2_.hasEventListener(MouseEvent.MOUSE_OVER))
            {
               this.remTooltip(_loc2_.name);
            }
            removeChild(_loc2_);
         }
         this._others = new Vector.<DisplayObject>();
         this._sliders = new Vector.<HUISlider>();
         this._fieldPosition = this.buttonSize + BUFFER * 2;
      }
      
      public function getTree(param1:String) : Tree
      {
         return Tree(getChildByName(param1));
      }
      
      public function getGadget(param1:String) : DisplayObject
      {
         return getChildByName(param1);
      }
      
      public function getField(param1:String) : TextField
      {
         return TextField(getChildByName(param1));
      }
      
      public function getSlider(param1:String) : HUISlider
      {
         return HUISlider(getChildByName(param1));
      }
      
      public function movePosition(param1:Number) : *
      {
         this._fieldPosition += param1;
         if(this._fieldPosition > this._height)
         {
            this._height = this._fieldPosition;
            this.drawWindow();
         }
      }
      
      public function setSize(param1:Number, param2:Number) : *
      {
         this.maxWidth = param1;
         this.maxHeight = param2;
         this.maximiseHeight = this.maxHeight;
         this.minimiseHeight = this.buttonSize;
         if(this.hasResizeButton())
         {
            this.minimiseHeight += this.buttonSize * 0.5;
         }
         this._width = param1;
         this._height = param2;
         if(this._width > this.maxWidth)
         {
            this._width = this.maxWidth;
         }
         if(this._width < this.minWidth)
         {
            this._width = this.minWidth;
         }
      }
      
      private function drawWindow() : void
      {
         var _loc3_:Boolean = false;
         this.graphics.clear();
         this._titlefield.textColor = this.FONTCOLOUR;
         if(this.locked)
         {
            this.graphics.clear();
            this.graphics.beginFill(0,0.75);
            this.graphics.drawRect(-GameState.width,-GameState.height,GameState.width * 2,GameState.height * 2);
         }
         var _loc1_:int = (this.hasCloseButton() ? 1 : 0) + (this.hasMinimiseButton() ? 1 : 0) + (this.hasMaximiseButton() ? 1 : 0);
         var _loc2_:Number = this._width - _loc1_ * this.buttonSize;
         if(this.title != "" && _loc2_ > 0)
         {
            if(this._borderalpha > 0)
            {
               this.graphics.lineStyle(this.LINEWIDTH,this.BORDERCOLOUR,this._borderalpha);
            }
            this.graphics.beginFill(this.TOPBARCOLOUR,this._alpha);
            _loc3_ = !(this.hasCloseButton() || this.hasMinimiseButton() || this.hasMaximiseButton());
            this.graphics.drawRoundRectComplex(0,0,_loc2_,this.buttonSize,4,_loc3_ ? 4 : 0,0,0);
         }
         if(this._borderalpha > 0)
         {
            this.graphics.lineStyle(this.LINEWIDTH,this.BORDERCOLOUR,this._borderalpha);
         }
         this.graphics.beginFill(this.BACKGROUNDCOLOUR,this._alpha);
         this.graphics.drawRoundRectComplex(0,this.buttonSize,this._width,this._height - this.buttonSize,this.title == "" ? 4 : 0,this.title == "" ? 4 : 0,4,4);
         if(Boolean(this.dulin) && this.height >= this.maximiseHeight - 8)
         {
            this.graphics.drawRoundRectComplex(this.dulin.left,this.dulin.top,this.dulin.width,this.dulin.height,4,4,4,4);
         }
         this.graphics.endFill();
         this.visible = false;
         this.enabled = true;
         if(this.hasCloseButton())
         {
            this.addButton(BUTTON_CLOSE);
         }
         if(this.hasMinimiseButton())
         {
            this.addButton(BUTTON_MINIMISE);
         }
         if(this.hasResizeButton())
         {
            this.addButton(BUTTON_RESIZE);
         }
         if(this.hasMaximiseButton())
         {
            this.addButton(BUTTON_MAXIMISE);
         }
      }
      
      public function hasCloseButton() : Boolean
      {
         return this.getChildByName(BUTTON_CLOSE) != null;
      }
      
      public function hasMinimiseButton() : Boolean
      {
         return this.getChildByName(BUTTON_MINIMISE) != null;
      }
      
      public function hasResizeButton() : Boolean
      {
         return this.getChildByName(BUTTON_RESIZE) != null;
      }
      
      public function hasMaximiseButton() : Boolean
      {
         return this.getChildByName(BUTTON_MAXIMISE) != null;
      }
      
      public function addButton(param1:String) : void
      {
         var _loc8_:Sprite = null;
         var _loc9_:Sprite = null;
         var _loc10_:Sprite = null;
         var _loc11_:Sprite = null;
         var _loc2_:Number = this.buttonSize;
         var _loc3_:Sprite = this.getChildByName(BUTTON_CLOSE) as Sprite;
         var _loc4_:Sprite = this.getChildByName(BUTTON_MINIMISE) as Sprite;
         var _loc5_:Sprite = this.getChildByName(BUTTON_RESIZE) as Sprite;
         var _loc6_:Sprite = this.getChildByName(BUTTON_MAXIMISE) as Sprite;
         var _loc7_:Number = 5;
         if(param1 == BUTTON_CLOSE)
         {
            if(_loc3_)
            {
               this.removeChild(_loc3_);
            }
            _loc8_ = new Sprite();
            _loc8_.name = BUTTON_CLOSE;
            if(this._borderalpha > 0)
            {
               _loc8_.graphics.lineStyle(this.LINEWIDTH,this.BORDERCOLOUR,this._borderalpha);
            }
            _loc8_.graphics.beginFill(this.TOPBARCOLOUR,this._alpha);
            _loc8_.graphics.drawRoundRectComplex(0,0,_loc2_,_loc2_,0,4,0,0);
            _loc8_.graphics.endFill();
            _loc8_.graphics.lineStyle(2,this.BUTTONCOLOUR,1);
            _loc8_.graphics.moveTo(_loc7_,_loc7_);
            _loc8_.graphics.lineTo(_loc2_ - _loc7_,_loc2_ - _loc7_);
            _loc8_.graphics.moveTo(_loc7_,_loc2_ - _loc7_);
            _loc8_.graphics.lineTo(_loc2_ - _loc7_,_loc7_);
            _loc8_.x = this._width - _loc2_;
            _loc8_.y = 0;
            if(_loc4_)
            {
               _loc4_.x = this._width - 2 * _loc2_;
            }
            this.addChild(_loc8_);
         }
         else if(param1 == BUTTON_MINIMISE)
         {
            if(_loc4_)
            {
               this.removeChild(_loc4_);
            }
            _loc9_ = new Sprite();
            _loc9_.name = BUTTON_MINIMISE;
            if(this._borderalpha > 0)
            {
               _loc9_.graphics.lineStyle(this.LINEWIDTH,this.BORDERCOLOUR,this._borderalpha);
            }
            _loc9_.graphics.beginFill(this.TOPBARCOLOUR,this._alpha);
            _loc9_.graphics.drawRoundRectComplex(0,0,_loc2_,_loc2_,0,_loc3_ ? 0 : 4,0,0);
            _loc9_.graphics.endFill();
            if(this.collapseInsteadOfMinimising && this._width != this.minWidth || !this.collapseInsteadOfMinimising && this._height > this.minimiseHeight)
            {
               _loc9_.graphics.lineStyle(2,this.BUTTONCOLOUR,1);
               if(this.collapseInsteadOfMinimising)
               {
                  if(this.x < stage.stageWidth >> 1)
                  {
                     _loc9_.graphics.moveTo(_loc2_ >> 1,_loc2_ >> 1);
                     _loc9_.graphics.lineTo(_loc2_ - _loc7_,_loc2_ - _loc7_);
                     _loc9_.graphics.moveTo(_loc2_ >> 1,_loc2_ >> 1);
                     _loc9_.graphics.lineTo(_loc2_ - _loc7_,_loc7_);
                  }
                  else
                  {
                     _loc9_.graphics.moveTo(_loc2_ >> 1,_loc2_ >> 1);
                     _loc9_.graphics.lineTo(_loc7_,_loc2_ - _loc7_);
                     _loc9_.graphics.moveTo(_loc2_ >> 1,_loc2_ >> 1);
                     _loc9_.graphics.lineTo(_loc7_,_loc7_);
                  }
               }
               else
               {
                  _loc9_.graphics.moveTo(_loc2_ >> 1,_loc2_ >> 1);
                  _loc9_.graphics.lineTo(_loc2_ - _loc7_,_loc2_ - _loc7_);
                  _loc9_.graphics.moveTo(_loc2_ >> 1,_loc2_ >> 1);
                  _loc9_.graphics.lineTo(_loc7_,_loc2_ - _loc7_);
               }
            }
            else
            {
               _loc9_.graphics.lineStyle(2,this.BUTTONCOLOUR,1);
               if(this.collapseInsteadOfMinimising)
               {
                  if(this.x > stage.stageWidth >> 1)
                  {
                     _loc9_.graphics.moveTo(_loc2_ >> 1,_loc2_ >> 1);
                     _loc9_.graphics.lineTo(_loc2_ - _loc7_,_loc2_ - _loc7_);
                     _loc9_.graphics.moveTo(_loc2_ >> 1,_loc2_ >> 1);
                     _loc9_.graphics.lineTo(_loc2_ - _loc7_,_loc7_);
                  }
                  else
                  {
                     _loc9_.graphics.moveTo(_loc2_ >> 1,_loc2_ >> 1);
                     _loc9_.graphics.lineTo(_loc7_,_loc2_ - _loc7_);
                     _loc9_.graphics.moveTo(_loc2_ >> 1,_loc2_ >> 1);
                     _loc9_.graphics.lineTo(_loc7_,_loc7_);
                  }
               }
               else
               {
                  _loc9_.graphics.moveTo(_loc2_ >> 1,_loc2_ >> 1);
                  _loc9_.graphics.lineTo(_loc2_ - _loc7_,_loc7_);
                  _loc9_.graphics.moveTo(_loc2_ >> 1,_loc2_ >> 1);
                  _loc9_.graphics.lineTo(_loc7_,_loc7_);
               }
            }
            if(_loc3_)
            {
               _loc9_.x = this._width - 2 * _loc2_;
            }
            else
            {
               _loc9_.x = this._width - _loc2_;
            }
            _loc9_.y = 0;
            this.addChild(_loc9_);
         }
         else if(param1 == BUTTON_RESIZE)
         {
            if(_loc5_)
            {
               this.removeChild(_loc5_);
            }
            _loc10_ = new Sprite();
            _loc10_.name = BUTTON_RESIZE;
            _loc10_.graphics.lineStyle(this.LINEWIDTH,this.BORDERCOLOUR);
            _loc10_.graphics.beginFill(this.TOPBARCOLOUR,0.9);
            _loc10_.graphics.drawRoundRectComplex(BUFFER * 2,0,this._width - BUFFER * 4,_loc2_ * 0.5,0,0,4,4);
            _loc10_.graphics.endFill();
            _loc10_.graphics.lineStyle();
            _loc10_.graphics.beginFill(0,0);
            _loc10_.graphics.drawRect(0,0,this._width,_loc2_);
            _loc10_.graphics.endFill();
            _loc10_.graphics.lineStyle(2,6710886,1);
            _loc10_.y = this.height;
            this.addChild(_loc10_);
         }
         else if(param1 == BUTTON_MAXIMISE)
         {
            if(_loc6_)
            {
               this.removeChild(_loc6_);
            }
            _loc11_ = new Sprite();
            _loc11_.name = BUTTON_MAXIMISE;
            if(this._borderalpha > 0)
            {
               _loc11_.graphics.lineStyle(this.LINEWIDTH,this.BORDERCOLOUR,this._borderalpha);
            }
            _loc11_.graphics.beginFill(this.TOPBARCOLOUR,this._alpha);
            _loc11_.graphics.drawRoundRectComplex(0,0,_loc2_,_loc2_,0,Boolean(_loc3_) || Boolean(_loc4_) ? 0 : 4,0,0);
            _loc11_.graphics.endFill();
            _loc11_.graphics.lineStyle(2,this.BUTTONCOLOUR,1);
            if(this._height <= this.maxHeight)
            {
               _loc11_.graphics.moveTo(_loc7_,_loc7_);
               _loc11_.graphics.lineTo(_loc7_,_loc2_ * 0.5);
               _loc11_.graphics.lineTo(_loc2_ * 0.5,_loc2_ - _loc7_);
               _loc11_.graphics.lineTo(_loc2_ - _loc7_,_loc2_ * 0.5);
               _loc11_.graphics.lineTo(_loc2_ - _loc7_,_loc7_);
               _loc11_.graphics.lineTo(_loc7_,_loc7_);
            }
            else
            {
               _loc11_.graphics.moveTo(_loc7_,_loc2_ - _loc7_);
               _loc11_.graphics.lineTo(_loc7_,_loc2_ * 0.5);
               _loc11_.graphics.lineTo(_loc2_ * 0.5,_loc7_);
               _loc11_.graphics.lineTo(_loc2_ - _loc7_,_loc2_ * 0.5);
               _loc11_.graphics.lineTo(_loc2_ - _loc7_,_loc2_ - _loc7_);
               _loc11_.graphics.lineTo(_loc7_,_loc2_ - _loc7_);
            }
            if(Boolean(_loc3_) && Boolean(_loc4_))
            {
               _loc11_.x = this._width - 3 * _loc2_;
            }
            else if(Boolean(_loc3_) || Boolean(_loc4_))
            {
               _loc11_.x = this._width - 2 * _loc2_;
            }
            else
            {
               _loc11_.x = this._width - _loc2_;
            }
            _loc11_.y = 0;
            this.addChild(_loc11_);
         }
      }
      
      private function toggleMinimise() : void
      {
         if(!this.hasEventListener(Event.ENTER_FRAME))
         {
            if(this._minimised)
            {
               this.addEventListener(Event.ENTER_FRAME,this.shower);
            }
            else
            {
               this.addEventListener(Event.ENTER_FRAME,this.hider);
            }
         }
      }
      
      private function hider(param1:Event) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:Boolean = false;
         this._height *= this.transitionSpeed;
         var _loc4_:int = 0;
         while(_loc4_ < this.numChildren)
         {
            _loc3_ = this.getChildAt(_loc4_);
            if(_loc3_.name != "windowtitle" && _loc3_.name != "close" && _loc3_.name != "minimise" && _loc3_.name != "maximise")
            {
               if(this._height < _loc3_.y + _loc3_.height)
               {
                  _loc3_.visible = false;
               }
            }
            _loc4_++;
         }
         if(this._height <= this.minimiseHeight)
         {
            this._height = this.minimiseHeight;
            _loc2_ = true;
         }
         if(_loc2_)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.hider);
            this._minimised = true;
            dispatchEvent(new WindowEvent(WindowEvent.ON_MINIMISE,this.name));
         }
         this.drawWindow();
      }
      
      private function shower(param1:Event) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:Boolean = false;
         this._height *= 1 / this.transitionSpeed;
         var _loc4_:int = 0;
         while(_loc4_ < this.numChildren)
         {
            _loc3_ = this.getChildAt(_loc4_);
            if(_loc3_.name != "windowtitle" && _loc3_.name != "close" && _loc3_.name != "minimise" && _loc3_.name != "maximise")
            {
               if(this._height > _loc3_.y + _loc3_.height)
               {
                  _loc3_.visible = true;
               }
            }
            _loc4_++;
         }
         if(this._maximised)
         {
            if(this._height >= this.maximiseHeight)
            {
               this._height = this.maximiseHeight;
               _loc2_ = true;
            }
         }
         else if(this._height >= this.maxHeight)
         {
            this._height = this.maxHeight;
            _loc2_ = true;
         }
         if(_loc2_)
         {
            _loc4_ = 0;
            while(_loc4_ < this.numChildren)
            {
               _loc3_ = this.getChildAt(_loc4_);
               if(_loc3_.name != "windowtitle" && _loc3_.name != "close" && _loc3_.name != "minimise")
               {
                  _loc3_.visible = true;
               }
               _loc4_++;
            }
            this.removeEventListener(Event.ENTER_FRAME,this.shower);
            this._minimised = false;
            dispatchEvent(new WindowEvent(WindowEvent.ON_MAXIMISE,this.name));
         }
         this.drawWindow();
      }
      
      private function maximiser(param1:Event) : Boolean
      {
         var _loc3_:DisplayObject = null;
         var _loc5_:* = undefined;
         var _loc2_:Boolean = false;
         this._height *= 1 / this.transitionSpeed;
         var _loc4_:int = 0;
         while(_loc4_ < this.numChildren)
         {
            _loc3_ = this.getChildAt(_loc4_);
            if(this._height > _loc3_.y + _loc3_.height)
            {
               _loc3_.visible = true;
            }
            if(this._height >= this.maximiseHeight)
            {
               this._height = this.maximiseHeight;
               _loc2_ = true;
            }
            if(this._trees.length == 1)
            {
               this._trees[0].height = this._height - this._trees[0].y - BUFFER * 2;
               _loc5_ = this._trees[0].y + this._trees[0].length * this._trees[0].rowHeight;
               if(_loc5_ < this._trees[0].height)
               {
                  this._height = _loc5_ + BUFFER * 2;
                  _loc2_ = true;
               }
            }
            _loc4_++;
         }
         if(_loc2_)
         {
            this.forceChildrenVisible();
            this.removeEventListener(Event.ENTER_FRAME,this.maximiser);
            dispatchEvent(new WindowEvent(WindowEvent.ON_MAXIMISE,this.name));
         }
         this.drawWindow();
         return _loc2_;
      }
      
      public function forceMaximised() : *
      {
         this.maximise();
         while(!this.maximiser(null))
         {
         }
      }
      
      public function forceChildrenVisible() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.numChildren)
         {
            _loc1_ = this.getChildAt(_loc2_);
            _loc1_.visible = true;
            _loc2_++;
         }
         this._maximised = true;
         this._minimised = false;
      }
      
      private function unmaximiser(param1:Event) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:Boolean = false;
         this._height *= this.transitionSpeed;
         var _loc4_:int = 0;
         while(_loc4_ < this.numChildren)
         {
            _loc3_ = this.getChildAt(_loc4_);
            if(this._height > _loc3_.y + _loc3_.height)
            {
               _loc3_.visible = true;
            }
            if(this._height <= this.maxHeight)
            {
               this._height = this.maxHeight;
               _loc2_ = true;
            }
            if(this._trees.length == 1)
            {
               this._trees[0].height = this._height - BUFFER * 2 - this._trees[0].y;
            }
            _loc4_++;
         }
         if(_loc2_)
         {
            _loc4_ = 0;
            while(_loc4_ < this.numChildren)
            {
               _loc3_ = this.getChildAt(_loc4_);
               _loc3_.visible = true;
               _loc4_++;
            }
            this.removeEventListener(Event.ENTER_FRAME,this.unmaximiser);
            this._maximised = false;
         }
         this.drawWindow();
      }
      
      public function set enabled(param1:Boolean) : void
      {
         this._enabled = param1;
         if(param1)
         {
            this.visible = true;
            this.moveToTop();
            this.registerListeners();
         }
         else
         {
            this.visible = false;
            this.unregisterListeners();
         }
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function get draggable() : Boolean
      {
         return this._draggable;
      }
      
      public function set draggable(param1:Boolean) : void
      {
         this._draggable = param1;
      }
      
      public function get locked() : Boolean
      {
         return this._locked;
      }
      
      public function set locked(param1:Boolean) : void
      {
         this._locked = param1;
      }
      
      public function get actualWidth() : Number
      {
         return this._width;
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      public function get dragging() : Boolean
      {
         return this._dragging;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function get isMinimised() : Boolean
      {
         return this._minimised;
      }
      
      public function get isMaximised() : Boolean
      {
         return this._maximised;
      }
      
      public function get maximiseHeight() : Number
      {
         return this._maximiseHeight;
      }
      
      public function set maximiseHeight(param1:Number) : void
      {
         this._maximiseHeight = param1;
         this._height = this._maximiseHeight;
         if(this._trees.length == 1)
         {
            this._trees[0].height = this._height - this._trees[0].y - BUFFER * 2;
         }
      }
      
      public function get dulin() : Rectangle
      {
         return this._dulin;
      }
      
      public function set dulin(param1:Rectangle) : void
      {
         this._dulin = param1;
         this.drawWindow();
      }
      
      public function get collapseInsteadOfMinimising() : Boolean
      {
         return this._collapseInsteadOfMinimising;
      }
      
      public function set collapseInsteadOfMinimising(param1:Boolean) : void
      {
         this._collapseInsteadOfMinimising = param1;
         this.redraw();
      }
      
      public function get fieldPosition() : Number
      {
         return this._fieldPosition;
      }
      
      public function set fieldPosition(param1:Number) : void
      {
         this._fieldPosition = param1;
      }
      
      public function get sliders() : Vector.<HUISlider>
      {
         return this._sliders;
      }
      
      public function moveToTop() : void
      {
         if(this._addedToStage)
         {
            this.parent.setChildIndex(this,this.parent.numChildren - 1);
         }
      }
      
      public function lock() : void
      {
         this.draggable = false;
         this.locked = true;
         this.drawWindow();
      }
      
      public function unlock() : void
      {
         this.locked = false;
         this.draggable = true;
         this.drawWindow();
      }
      
      public function center() : void
      {
         this.x = GameState.width * 0.5 - this.width * 0.5;
         this.y = GameState.height * 0.5 - this.height * 0.5 + this.buttonSize * 2;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this._addedToStage = true;
         this.registerListeners();
         this.moveToTop();
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         this.unregisterListeners();
      }
      
      private function handleMouse(param1:MouseEvent) : void
      {
         if(param1.type == MouseEvent.MOUSE_DOWN)
         {
            this._selected = true;
            this._mousedown = true;
            dispatchEvent(new WindowEvent(WindowEvent.ON_SELECT,this.name));
            if(param1.target.name == "close")
            {
               this.close();
            }
            else if(param1.target.name == "maximise")
            {
               this.toggleMaximise();
            }
            else if(param1.target.name == "minimise")
            {
               this.minimise();
            }
            else if(param1.target.name == "resize")
            {
               this.startResize();
            }
            else if(this.draggable)
            {
               if(this.checkIgnore(param1.target) && !(param1.target is TreeCellRenderer) && (!(param1.target is TextField) || !TextField(param1.target).selectable))
               {
                  this._dragging = true;
                  this._dragpos = new Point(this.mouseX,this.mouseY);
                  param1.currentTarget.parent.setChildIndex(param1.currentTarget as DisplayObject,param1.currentTarget.parent.numChildren - 1);
                  addEventListener(Event.ENTER_FRAME,this.dragger);
               }
            }
         }
         else if(param1.type == MouseEvent.MOUSE_UP)
         {
            this._mousedown = false;
            this.stopDragging();
            this.stopResize(null);
         }
      }
      
      public function stopDragging() : void
      {
         if(this._dragging)
         {
            this._dragging = false;
            removeEventListener(Event.ENTER_FRAME,this.dragger);
         }
      }
      
      private function stopResize(param1:MouseEvent) : void
      {
         if(this.startResizePos)
         {
            this.startResizePos = null;
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.dragResize);
            removeEventListener(MouseEvent.MOUSE_OUT,this.stopResize);
            this.maxHeight = this._height;
            dispatchEvent(new WindowEvent(WindowEvent.STOP_RESIZE,this.name));
         }
      }
      
      private function startResize() : void
      {
         this.startResizeSize = this._height;
         this.startResizePos = new Point(mouseX,mouseY);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.dragResize);
         dispatchEvent(new WindowEvent(WindowEvent.START_RESIZE,this.name));
      }
      
      private function dragResize(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc4_:Number = NaN;
         if(!GameState.mouseDown)
         {
            this.stopResize(param1);
            return;
         }
         this._height = this.startResizeSize - (this.startResizePos.y - mouseY);
         if(this._height < this.minimiseHeight)
         {
            this._height = this.minimiseHeight;
         }
         if(this._trees.length == 1)
         {
            _loc4_ = this._height - this._trees[0].y - BUFFER * 2;
            if(_loc4_ < 28)
            {
               this._trees[0].visible = false;
            }
            else
            {
               this._trees[0].height = _loc4_;
            }
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.numChildren)
         {
            _loc2_ = this.getChildAt(_loc3_);
            if(_loc2_.name != "windowtitle" && _loc2_.name != "close" && _loc2_.name != "minimise")
            {
               if(this._height < _loc2_.y + _loc2_.height)
               {
                  _loc2_.visible = false;
               }
               else
               {
                  _loc2_.visible = true;
               }
            }
            _loc3_++;
         }
         dispatchEvent(new WindowEvent(WindowEvent.ON_RESIZE,this.name));
         this.drawWindow();
      }
      
      private function toggleMaximise() : void
      {
         if(this._height > this.maxHeight)
         {
            this.unmaximise();
         }
         else
         {
            this.maximise();
         }
      }
      
      public function maximise() : void
      {
         if(!visible)
         {
            return;
         }
         this.addEventListener(Event.ENTER_FRAME,this.maximiser);
      }
      
      public function unmaximise() : void
      {
         this.addEventListener(Event.ENTER_FRAME,this.unmaximiser);
      }
      
      private function dragger(param1:Event) : void
      {
         if(!this._dragging)
         {
            return;
         }
         if(!this._mousedown)
         {
            this.stopDragging();
         }
         var _loc2_:Number = stage.mouseX - this._dragpos.x;
         var _loc3_:Number = stage.mouseY - this._dragpos.y;
         if(this.x != _loc2_ || this.y != _loc3_)
         {
            this.undocked = true;
         }
         this.x = _loc2_;
         this.y = _loc3_;
         this.checkBounds();
      }
      
      public function toggle() : void
      {
         if(this.visible)
         {
            this.close();
         }
         else
         {
            this.open();
         }
      }
      
      public function open() : void
      {
         this.alpha = 0.1;
         this.forceOpen();
      }
      
      public function minimise() : void
      {
         if(!this.collapseInsteadOfMinimising)
         {
            this.toggleMinimise();
         }
         else if(this._width == this.minWidth)
         {
            this.expand();
         }
         else if(this._width == this.maxWidth)
         {
            this.collapse();
         }
      }
      
      public function close() : void
      {
         this.stopResize(null);
         if(this.locked)
         {
            this.unlock();
         }
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this.forceClosed();
      }
      
      private function closer(param1:Event) : void
      {
         this.forceClosed();
      }
      
      private function opener(param1:Event) : void
      {
         this.forceOpen();
      }
      
      public function forceOpen() : void
      {
         this.visible = true;
         this.alpha = 1;
         this.mouseChildren = true;
         this.mouseEnabled = true;
         this.moveToTop();
         dispatchEvent(new WindowEvent(WindowEvent.ON_OPEN,this.name));
      }
      
      public function forceClosed() : void
      {
         this.visible = false;
         this.alpha = 0;
         this.mouseChildren = false;
         this.mouseEnabled = false;
         dispatchEvent(new WindowEvent(WindowEvent.ON_CLOSE,this.name));
      }
      
      private function checkBounds() : void
      {
         if(World.toggleEdgeStick == 0)
         {
            return;
         }
         if(this.x < 0)
         {
            this.x = 0;
         }
         else if(this.x + this._width > GameState.width)
         {
            this.x = GameState.width - this._width;
         }
         if(this.y < 0)
         {
            this.y = 0;
         }
         else if(this.y + this.buttonSize > GameState.height)
         {
            this.y = GameState.height - this.buttonSize;
         }
      }
      
      public function ignoreDrag(param1:String) : void
      {
         if(this._ignoreDrag.indexOf(param1) != -1)
         {
            return;
         }
         this._ignoreDrag.push(param1);
      }
      
      public function addTooltip(param1:String, param2:String) : void
      {
         var _loc3_:DisplayObject = this.getChildByName(param1);
         if(_loc3_)
         {
            this._tooltips.push(param1);
            this._tooltipTexts.push(param2);
            _loc3_.addEventListener(MouseEvent.MOUSE_OVER,this.omo);
         }
      }
      
      public function remTooltip(param1:String) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:int = 0;
         _loc2_ = this.getChildByName(param1);
         if(_loc2_)
         {
            _loc3_ = this._tooltips.indexOf(param1);
            if(_loc3_ != -1)
            {
               this._tooltips.splice(_loc3_,1);
               this._tooltipTexts.splice(_loc3_,1);
               _loc2_ = this.getChildByName(param1);
               if(_loc2_)
               {
                  _loc2_.removeEventListener(MouseEvent.MOUSE_OVER,this.omo);
               }
            }
         }
      }
      
      public function setStyle(param1:Object) : void
      {
         if(param1.ColourBackground)
         {
            this.setColourBackground(param1.ColourBackground);
         }
         if(param1.ColourFields)
         {
            this.setColourFields(param1.ColourFields);
         }
         if(param1.ColourTopbar)
         {
            this.setColourTopbar(param1.ColourTopbar);
         }
         if(param1.ColourBorder)
         {
            this.setColourBorder(param1.ColourBorder);
         }
         if(param1.ColourButtons)
         {
            this.setColourButtons(param1.ColourButtons);
         }
         if(param1.ColourFont)
         {
            this.setColourFont(param1.ColourFont);
         }
         if(param1.LineWidth)
         {
            this.LINEWIDTH = param1.LineWidth;
         }
         this.redraw();
      }
      
      public function setColourFields(param1:uint) : void
      {
         this.FIELDBACKGROUNDCOLOUR = param1;
      }
      
      public function setColourBackground(param1:uint) : void
      {
         this.BACKGROUNDCOLOUR = param1;
      }
      
      public function setColourTopbar(param1:uint) : void
      {
         this.TOPBARCOLOUR = param1;
      }
      
      public function setColourBorder(param1:uint) : void
      {
         this.BORDERCOLOUR = param1;
      }
      
      public function setColourFont(param1:uint) : void
      {
         this.FONTCOLOUR = param1;
      }
      
      public function setColourButtons(param1:uint) : void
      {
         this.BUTTONCOLOUR = param1;
      }
      
      public function redraw() : void
      {
         if(visible && alpha > 0)
         {
            this.drawWindow();
         }
      }
      
      public function setAlpha(param1:Number) : void
      {
         this._alpha = param1;
      }
      
      public function toggleAllSliders(param1:Boolean) : void
      {
         var _loc2_:HUISlider = null;
         for each(_loc2_ in this._sliders)
         {
            _loc2_.toggleExactInput(param1);
         }
      }
      
      private function checkIgnore(param1:*) : Boolean
      {
         if(this._ignoreDrag.indexOf(getQualifiedClassName(param1)) != -1)
         {
            return false;
         }
         if(this._ignoreDrag.indexOf(param1.name) != -1)
         {
            return false;
         }
         return true;
      }
      
      private function registerListeners() : void
      {
         if(!this.hasEventListener(Event.ADDED_TO_STAGE))
         {
            addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage,false,0,true);
         }
         if(!this.hasEventListener(Event.REMOVED_FROM_STAGE))
         {
            addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage,false,0,true);
         }
         if(!this.hasEventListener(MouseEvent.MOUSE_UP))
         {
            addEventListener(MouseEvent.MOUSE_UP,this.handleMouse,false,0,true);
         }
         if(!this.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouse,false,0,true);
         }
      }
      
      private function unregisterListeners() : void
      {
         if(this.hasEventListener(Event.ADDED_TO_STAGE))
         {
            removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         }
         if(this.hasEventListener(Event.REMOVED_FROM_STAGE))
         {
            removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         }
         if(this.hasEventListener(MouseEvent.MOUSE_UP))
         {
            removeEventListener(MouseEvent.MOUSE_UP,this.handleMouse);
         }
         if(this.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            removeEventListener(MouseEvent.MOUSE_DOWN,this.handleMouse);
         }
      }
   }
}

