package com.hybrid.ui
{
   import fl.transitions.Tween;
   import fl.transitions.TweenEvent;
   import fl.transitions.easing.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.Timer;
   
   public class ToolTip extends Sprite
   {
      
      private var _stage:Stage;
      
      private var _parentObject:DisplayObject;
      
      private var _tf:TextField;
      
      private var _cf:TextField;
      
      private var _contentContainer:Sprite = new Sprite();
      
      private var _tween:Tween;
      
      private var _titleFormat:TextFormat;
      
      private var _contentFormat:TextFormat;
      
      private var _titleEmbed:Boolean = true;
      
      private var _contentEmbed:Boolean = true;
      
      private var _defaultWidth:Number = 200;
      
      private var _defaultHeight:Number;
      
      private var _buffer:Number = 10;
      
      private var _followMouse:Boolean = true;
      
      private var _align:String = "left";
      
      private var _tipPosition:String = "top";
      
      private var _cornerRadius:Number = 12;
      
      private var _bgColors:Array = [16777215,10263708];
      
      private var _autoSize:Boolean = false;
      
      private var _autoCleanUp:Boolean = true;
      
      private var _hookEnabled:Boolean = false;
      
      private var _hookPosition:String = "bottom";
      
      private var _showDelay:Number = 0;
      
      private var _hideDelay:Number = 0;
      
      private var _hookSize:Number = 10;
      
      private var _border:uint;
      
      private var _borderSize:Number = 1;
      
      private var _hideOnMouseOut:Boolean = true;
      
      private var _hideOnMouseDown:Boolean = true;
      
      private var _bgAlpha:Number = 1;
      
      private var _hookOffSet:Number = 0;
      
      private var _tipOffSet:Number = 0;
      
      private var _timer:Timer;
      
      private var _myHeight:Number;
      
      private var _myWidth:Number;
      
      public function ToolTip()
      {
         super();
         this.mouseEnabled = false;
         this.buttonMode = false;
         this.mouseChildren = false;
         this._timer = new Timer(this._showDelay,1);
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.timerShow);
         this.initTitleFormat();
         this.initContentFormat();
      }
      
      public function get running() : Boolean
      {
         return this._timer.running;
      }
      
      public function reset() : *
      {
         this.alpha = 0;
         if(this._timer.running)
         {
            this._timer.stop();
         }
         this._timer.reset();
         this._timer.delay = this._showDelay;
         this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.timerShow);
      }
      
      public function setContent(param1:String, param2:String = null) : void
      {
         this.graphics.clear();
         this.addCopy(param1,param2);
         this.setOffset();
         this.drawBG();
      }
      
      public function show(param1:DisplayObject, param2:String, param3:String = null) : void
      {
         var _loc5_:Point = null;
         this._stage = param1.stage;
         this._parentObject = param1;
         var _loc4_:Boolean = this.addedToStage(this._contentContainer);
         if(!_loc4_)
         {
            this.addChild(this._contentContainer);
         }
         this.addCopy(param2,param3);
         this.setOffset();
         this.drawBG();
         this.alpha = 0;
         this._stage.addChild(this);
         if(this._hideOnMouseOut)
         {
            this._parentObject.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         }
         if(this._hideOnMouseDown)
         {
            this._parentObject.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         }
         if(this._followMouse)
         {
            this.follow(true);
         }
         else
         {
            this.alignTip(this._parentObject,this._tipPosition,param1.localToGlobal(new Point()));
         }
         this._timer.start();
      }
      
      private function positionTip(param1:DisplayObject, param2:String = "top", param3:Point = null, param4:Number = 1) : *
      {
         var _loc5_:Point = param3;
         if(!param3)
         {
            _loc5_ = new Point(param1.x,param1.y);
         }
         var _loc6_:Number = 0;
         if(!this._followMouse)
         {
            _loc6_ = this._buffer * 2;
         }
         this._myHeight = this.height;
         this._myWidth = this.width;
         this._tipPosition = param2;
         if(param2 == "right")
         {
            this._hookPosition = "left";
            this.setOffset();
            this._myWidth += this._hookSize;
            this.x = _loc5_.x + this._hookSize + param1.width;
            this.y = _loc5_.y - this._tipOffSet;
         }
         else if(param2 == "left")
         {
            this._hookPosition = "right";
            this.setOffset();
            this._myWidth += this._hookSize;
            this.x = _loc5_.x - this._myWidth;
            this.y = _loc5_.y - this._tipOffSet;
         }
         else if(param2 == "bottom")
         {
            this._hookPosition = "top";
            this.setOffset();
            this._myHeight += this._hookSize;
            this.x = _loc5_.x - this._tipOffSet;
            this.y = _loc5_.y + param1.height + this.buffer * 2;
         }
         else if(param2 == "bottom_right")
         {
            this._hookPosition = "top_left";
            this.setOffset();
            this._myHeight += this._hookSize;
            this._myWidth += this._hookSize;
            this.x = _loc5_.x + this._hookSize;
            this.y = _loc5_.y + this._hookSize;
         }
         else if(param2 == "bottom_left")
         {
            this._hookPosition = "top_right";
            this.setOffset();
            this._myHeight += this._hookSize;
            this._myWidth += this._hookSize;
            this.x = _loc5_.x - this._myWidth;
            this.y = _loc5_.y + this._hookSize;
         }
         else if(param2 == "top_right")
         {
            this._hookPosition = "bottom_left";
            this.setOffset();
            this._myHeight += this._hookSize;
            this._myWidth += this._hookSize;
            this.x = _loc5_.x + this._hookSize;
            this.y = _loc5_.y - this._myHeight;
         }
         else if(param2 == "top_left")
         {
            this._hookPosition = "bottom_right";
            this.setOffset();
            this._myHeight += this._hookSize;
            this._myWidth += this._hookSize;
            this.x = _loc5_.x - this._myWidth;
            this.y = _loc5_.y - this._myHeight;
         }
         else
         {
            this._hookPosition = "bottom";
            this.setOffset();
            this._myHeight += this._hookSize;
            this.x = _loc5_.x - this._tipOffSet;
            this.y = _loc5_.y - this._myHeight;
         }
      }
      
      private function alignTip(param1:DisplayObject, param2:String = "top", param3:Point = null, param4:Number = 1, param5:Number = 0) : *
      {
         if(param5 >= 4)
         {
            return;
         }
         param5++;
         if(!param3)
         {
            param3 = new Point(param1.x,param1.y);
         }
         this.positionTip(param1,param2,param3,param4);
         if(this._stage.stageWidth < this._myWidth + this.x)
         {
            if(this._stage.stageHeight < this._myHeight + this.y)
            {
               this.alignTip(param1,"top_left",param3,param4,param5);
            }
            else if(this.y < 0)
            {
               this.alignTip(param1,"bottom_left",param3,param4,param5);
            }
            else if(this._tipPosition == "top" || this._tipPosition == "top_right")
            {
               this.alignTip(param1,"top_left",param3,param4,param5);
            }
            else if(this._tipPosition == "bottom" || this._tipPosition == "bottom_right")
            {
               this.alignTip(param1,"bottom_left",param3,param4,param5);
            }
            else
            {
               this.alignTip(param1,"left",param3,param4,param5);
            }
         }
         else if(this.x < 0)
         {
            if(this._stage.stageHeight < this._myHeight + this.y)
            {
               this.alignTip(param1,"top_right",param3,param4,param5);
            }
            else if(this.y < 0)
            {
               this.alignTip(param1,"bottom_right",param3,param4,param5);
            }
            else if(this._tipPosition == "top" || this._tipPosition == "top_left")
            {
               this.alignTip(param1,"top_right",param3,param4,param5);
            }
            else if(this._tipPosition == "bottom" || this._tipPosition == "bottom_left")
            {
               this.alignTip(param1,"bottom_right",param3,param4,param5);
            }
            else
            {
               this.alignTip(param1,"right",param3,param4,param5);
            }
         }
         else if(this._stage.stageHeight < this._myHeight + this.y)
         {
            if(this._tipPosition == "right" || this._tipPosition == "bottom_right")
            {
               this.alignTip(param1,"top_right",param3,param4,param5);
            }
            else if(this._tipPosition == "left" || this._tipPosition == "bottom_left")
            {
               this.alignTip(param1,"top_left",param3,param4,param5);
            }
            else
            {
               this.alignTip(param1,"top",param3,param4,param5);
            }
         }
         else if(this.y < 0)
         {
            if(this._tipPosition == "right" || this._tipPosition == "top_right")
            {
               this.alignTip(param1,"bottom_right",param3,param4,param5);
            }
            else if(this._tipPosition == "left" || this._tipPosition == "top_left")
            {
               this.alignTip(param1,"bottom_left",param3,param4,param5);
            }
            else
            {
               this.alignTip(param1,"bottom",param3,param4,param5);
            }
         }
      }
      
      public function hide() : void
      {
         this.animate(false);
      }
      
      private function timerShow(param1:TimerEvent) : void
      {
         this.animate(true);
      }
      
      private function timerHide(param1:TimerEvent) : void
      {
         this.animate(false);
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         this.hide();
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         this.hide();
      }
      
      private function follow(param1:Boolean) : void
      {
         if(param1)
         {
            addEventListener(Event.ENTER_FRAME,this.update);
         }
         else
         {
            removeEventListener(Event.ENTER_FRAME,this.update);
         }
      }
      
      private function update(param1:Event) : void
      {
         this.position();
      }
      
      private function position() : void
      {
         var _loc1_:Number = 3;
         var _loc2_:Point = new Point(this._parentObject.mouseX,this._parentObject.mouseY);
         var _loc3_:Point = this._parentObject.localToGlobal(_loc2_);
         this.alignTip(this._parentObject,this._tipPosition,_loc3_,_loc1_);
      }
      
      private function addCopy(param1:String, param2:String = null) : void
      {
         var _loc3_:Rectangle = null;
         var _loc4_:Number = NaN;
         if(!this._tf)
         {
            this._tf = this.createField(this._titleEmbed);
         }
         this._tf.htmlText = param1;
         this._tf.setTextFormat(this._titleFormat);
         this._tf.defaultTextFormat = this._titleFormat;
         if(this._autoSize)
         {
            this._defaultWidth = this._tf.textWidth + 4 + this._buffer * 2;
         }
         else
         {
            this._tf.width = this._defaultWidth - this._buffer * 2;
         }
         this._tf.x = this._tf.y = this._buffer;
         this._contentContainer.addChild(this._tf);
         if(param2 != null)
         {
            if(this._cf == null)
            {
               this._cf = this.createField(this._contentEmbed);
            }
            this._cf.htmlText = param2;
            this._cf.setTextFormat(this._contentFormat);
            this._cf.defaultTextFormat = this._contentFormat;
            _loc3_ = this.getBounds(this);
            this._cf.x = this._buffer;
            this._cf.y = this._tf.y + this._tf.textHeight;
            if(this._autoSize)
            {
               _loc4_ = this._cf.textWidth + 4 + this._buffer * 2;
               this._defaultWidth = _loc4_ > this._defaultWidth ? _loc4_ : this._defaultWidth;
            }
            else
            {
               this._cf.width = this._defaultWidth - this._buffer * 2;
            }
            this._contentContainer.addChild(this._cf);
         }
      }
      
      private function createField(param1:Boolean) : TextField
      {
         var _loc2_:TextField = new TextField();
         _loc2_.embedFonts = param1;
         _loc2_.antiAliasType = AntiAliasType.ADVANCED;
         _loc2_.sharpness = -100;
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         _loc2_.selectable = false;
         if(!this._autoSize)
         {
            _loc2_.multiline = true;
            _loc2_.wordWrap = true;
         }
         return _loc2_;
      }
      
      private function drawBG() : void
      {
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         this.graphics.clear();
         var _loc1_:Rectangle = this.getBounds(this);
         var _loc2_:Number = isNaN(this._defaultHeight) ? _loc1_.height + this._buffer * 2 : this._defaultHeight;
         var _loc3_:String = GradientType.LINEAR;
         var _loc4_:Array = [this._bgAlpha,this._bgAlpha];
         var _loc5_:Array = [0,255];
         var _loc6_:Matrix = new Matrix();
         var _loc7_:Number = 90 * Math.PI / 180;
         _loc6_.createGradientBox(this._defaultWidth,_loc2_,_loc7_,0,0);
         var _loc8_:String = SpreadMethod.PAD;
         if(!isNaN(this._border))
         {
            this.graphics.lineStyle(this._borderSize,this._border,1);
         }
         this.graphics.beginGradientFill(_loc3_,this._bgColors,_loc4_,_loc5_,_loc6_,_loc8_);
         if(this._hookEnabled)
         {
            _loc9_ = 0;
            _loc10_ = 0;
            _loc11_ = this._defaultWidth;
            if(this._hookPosition == "left")
            {
               this.graphics.moveTo(_loc9_ + this._cornerRadius,_loc10_);
               this.graphics.lineTo(_loc9_ + _loc11_ - this._cornerRadius,_loc10_);
               this.graphics.curveTo(_loc9_ + _loc11_,_loc10_,_loc9_ + _loc11_,_loc10_ + this._cornerRadius);
               this.graphics.lineTo(_loc9_ + _loc11_,_loc10_ + _loc2_ - this._cornerRadius);
               this.graphics.curveTo(_loc9_ + _loc11_,_loc10_ + _loc2_,_loc9_ + _loc11_ - this._cornerRadius,_loc10_ + _loc2_);
               this.graphics.lineTo(_loc9_ + this._cornerRadius,_loc10_ + _loc2_);
               this.graphics.curveTo(_loc9_,_loc10_ + _loc2_,_loc9_,_loc10_ + _loc2_ - this._cornerRadius);
               this.graphics.lineTo(_loc9_,_loc10_ + this._hookOffSet + this._hookSize);
               this.graphics.lineTo(_loc9_ - this._hookSize,_loc10_ + this._hookOffSet);
               this.graphics.lineTo(_loc9_,_loc10_ + this._hookOffSet - this._hookSize);
               this.graphics.lineTo(_loc9_,_loc10_ + this._cornerRadius);
               this.graphics.curveTo(_loc9_,_loc10_,_loc9_ + this._cornerRadius,_loc10_);
               this.graphics.endFill();
            }
            else if(this._hookPosition == "right")
            {
               this.graphics.moveTo(_loc9_ + this._cornerRadius,_loc10_);
               this.graphics.lineTo(_loc9_ + _loc11_ - this._cornerRadius,_loc10_);
               this.graphics.curveTo(_loc9_ + _loc11_,_loc10_,_loc9_ + _loc11_,_loc10_ + this._cornerRadius);
               this.graphics.lineTo(_loc9_ + _loc11_,_loc10_ + this._hookOffSet - this._hookSize);
               this.graphics.lineTo(_loc9_ + _loc11_ + this._hookSize,_loc10_ + this._hookOffSet);
               this.graphics.lineTo(_loc9_ + _loc11_,_loc10_ + this._hookOffSet + this._hookSize);
               this.graphics.lineTo(_loc9_ + _loc11_,_loc10_ + _loc2_ - this._cornerRadius);
               this.graphics.curveTo(_loc9_ + _loc11_,_loc10_ + _loc2_,_loc9_ + _loc11_ - this._cornerRadius,_loc10_ + _loc2_);
               this.graphics.lineTo(_loc9_ + this._cornerRadius,_loc10_ + _loc2_);
               this.graphics.curveTo(_loc9_,_loc10_ + _loc2_,_loc9_,_loc10_ + _loc2_ - this._cornerRadius);
               this.graphics.lineTo(_loc9_,_loc10_ + this._cornerRadius);
               this.graphics.curveTo(_loc9_,_loc10_,_loc9_ + this._cornerRadius,_loc10_);
               this.graphics.endFill();
            }
            else if(this._hookPosition == "top")
            {
               this.graphics.moveTo(_loc9_ + this._cornerRadius,_loc10_);
               this.graphics.lineTo(_loc9_ + this._hookOffSet - this._hookSize,_loc10_);
               this.graphics.lineTo(_loc9_ + this._hookOffSet,_loc10_ - this._hookSize);
               this.graphics.lineTo(_loc9_ + this._hookOffSet + this._hookSize,_loc10_);
               this.graphics.lineTo(_loc9_ + _loc11_ - this._cornerRadius,_loc10_);
               this.graphics.curveTo(_loc9_ + _loc11_,_loc10_,_loc9_ + _loc11_,_loc10_ + this._cornerRadius);
               this.graphics.lineTo(_loc9_ + _loc11_,_loc10_ + _loc2_ - this._cornerRadius);
               this.graphics.curveTo(_loc9_ + _loc11_,_loc10_ + _loc2_,_loc9_ + _loc11_ - this._cornerRadius,_loc10_ + _loc2_);
               this.graphics.lineTo(_loc9_ + this._cornerRadius,_loc10_ + _loc2_);
               this.graphics.curveTo(_loc9_,_loc10_ + _loc2_,_loc9_,_loc10_ + _loc2_ - this._cornerRadius);
               this.graphics.lineTo(_loc9_,_loc10_ + this._cornerRadius);
               this.graphics.curveTo(_loc9_,_loc10_,_loc9_ + this._cornerRadius,_loc10_);
               this.graphics.endFill();
            }
            else if(this._hookPosition == "top_left")
            {
               this.graphics.moveTo(_loc9_ + this._cornerRadius,_loc10_);
               this.graphics.lineTo(_loc9_ + _loc11_ - this._cornerRadius,_loc10_);
               this.graphics.curveTo(_loc9_ + _loc11_,_loc10_,_loc9_ + _loc11_,_loc10_ + this._cornerRadius);
               this.graphics.lineTo(_loc9_ + _loc11_,_loc10_ + _loc2_ - this._cornerRadius);
               this.graphics.curveTo(_loc9_ + _loc11_,_loc10_ + _loc2_,_loc9_ + _loc11_ - this._cornerRadius,_loc10_ + _loc2_);
               this.graphics.lineTo(_loc9_ + this._cornerRadius,_loc10_ + _loc2_);
               this.graphics.curveTo(_loc9_,_loc10_ + _loc2_,_loc9_,_loc10_ + _loc2_ - this._cornerRadius);
               this.graphics.lineTo(_loc9_,_loc10_ + this._cornerRadius);
               this.graphics.curveTo(_loc9_,_loc10_,_loc9_ - this._hookSize,_loc10_ - this._hookSize);
               this.graphics.curveTo(_loc9_,_loc10_,_loc9_ + this._cornerRadius,_loc10_);
               this.graphics.endFill();
            }
            else if(this._hookPosition == "top_right")
            {
               this.graphics.moveTo(_loc9_ + this._cornerRadius,_loc10_);
               this.graphics.lineTo(_loc9_ + _loc11_ - this._cornerRadius,_loc10_);
               this.graphics.curveTo(_loc9_ + _loc11_,_loc10_,_loc9_ + _loc11_ + this._hookSize,_loc10_ - this._hookSize);
               this.graphics.curveTo(_loc9_ + _loc11_,_loc10_,_loc9_ + _loc11_,_loc10_ + this._cornerRadius);
               this.graphics.lineTo(_loc9_ + _loc11_,_loc10_ + _loc2_ - this._cornerRadius);
               this.graphics.curveTo(_loc9_ + _loc11_,_loc10_ + _loc2_,_loc9_ + _loc11_ - this._cornerRadius,_loc10_ + _loc2_);
               this.graphics.lineTo(_loc9_ + this._cornerRadius,_loc10_ + _loc2_);
               this.graphics.curveTo(_loc9_,_loc10_ + _loc2_,_loc9_,_loc10_ + _loc2_ - this._cornerRadius);
               this.graphics.lineTo(_loc9_,_loc10_ + this._cornerRadius);
               this.graphics.curveTo(_loc9_,_loc10_,_loc9_ + this._cornerRadius,_loc10_);
               this.graphics.endFill();
            }
            else if(this._hookPosition == "bottom_right")
            {
               this.graphics.moveTo(_loc9_ + this._cornerRadius,_loc10_);
               this.graphics.lineTo(_loc9_ + _loc11_ - this._cornerRadius,_loc10_);
               this.graphics.curveTo(_loc9_ + _loc11_,_loc10_,_loc9_ + _loc11_,_loc10_ + this._cornerRadius);
               this.graphics.lineTo(_loc9_ + _loc11_,_loc10_ + _loc2_ - this._cornerRadius);
               this.graphics.curveTo(_loc9_ + _loc11_,_loc10_ + _loc2_,_loc9_ + _loc11_ + this._hookSize,_loc10_ + _loc2_ + this._hookSize);
               this.graphics.curveTo(_loc9_ + _loc11_,_loc10_ + _loc2_,_loc9_ + _loc11_ - this._cornerRadius,_loc10_ + _loc2_);
               this.graphics.lineTo(_loc9_ + this._cornerRadius,_loc10_ + _loc2_);
               this.graphics.curveTo(_loc9_,_loc10_ + _loc2_,_loc9_,_loc10_ + _loc2_ - this._cornerRadius);
               this.graphics.lineTo(_loc9_,_loc10_ + this._cornerRadius);
               this.graphics.curveTo(_loc9_,_loc10_,_loc9_ + this._cornerRadius,_loc10_);
               this.graphics.endFill();
            }
            else if(this._hookPosition == "bottom_left")
            {
               this.graphics.moveTo(_loc9_ + this._cornerRadius,_loc10_);
               this.graphics.lineTo(_loc9_ + _loc11_ - this._cornerRadius,_loc10_);
               this.graphics.curveTo(_loc9_ + _loc11_,_loc10_,_loc9_ + _loc11_,_loc10_ + this._cornerRadius);
               this.graphics.lineTo(_loc9_ + _loc11_,_loc10_ + _loc2_ - this._cornerRadius);
               this.graphics.curveTo(_loc9_ + _loc11_,_loc10_ + _loc2_,_loc9_ + _loc11_ - this._cornerRadius,_loc10_ + _loc2_);
               this.graphics.lineTo(_loc9_ + this._cornerRadius,_loc10_ + _loc2_);
               this.graphics.curveTo(_loc9_,_loc10_ + _loc2_,_loc9_ - this._hookSize,_loc10_ + _loc2_ + this._hookSize);
               this.graphics.curveTo(_loc9_,_loc10_ + _loc2_,_loc9_,_loc10_ + _loc2_ - this._cornerRadius);
               this.graphics.lineTo(_loc9_,_loc10_ + this._cornerRadius);
               this.graphics.curveTo(_loc9_,_loc10_,_loc9_ + this._cornerRadius,_loc10_);
               this.graphics.endFill();
            }
            else
            {
               this.graphics.moveTo(_loc9_ + this._cornerRadius,_loc10_);
               this.graphics.lineTo(_loc9_ + _loc11_ - this._cornerRadius,_loc10_);
               this.graphics.curveTo(_loc9_ + _loc11_,_loc10_,_loc9_ + _loc11_,_loc10_ + this._cornerRadius);
               this.graphics.lineTo(_loc9_ + _loc11_,_loc10_ + _loc2_ - this._cornerRadius);
               this.graphics.curveTo(_loc9_ + _loc11_,_loc10_ + _loc2_,_loc9_ + _loc11_ - this._cornerRadius,_loc10_ + _loc2_);
               this.graphics.lineTo(_loc9_ + this._hookOffSet + this._hookSize,_loc10_ + _loc2_);
               this.graphics.lineTo(_loc9_ + this._hookOffSet,_loc10_ + _loc2_ + this._hookSize);
               this.graphics.lineTo(_loc9_ + this._hookOffSet - this._hookSize,_loc10_ + _loc2_);
               this.graphics.lineTo(_loc9_ + this._cornerRadius,_loc10_ + _loc2_);
               this.graphics.curveTo(_loc9_,_loc10_ + _loc2_,_loc9_,_loc10_ + _loc2_ - this._cornerRadius);
               this.graphics.lineTo(_loc9_,_loc10_ + this._cornerRadius);
               this.graphics.curveTo(_loc9_,_loc10_,_loc9_ + this._cornerRadius,_loc10_);
               this.graphics.endFill();
            }
         }
         else
         {
            this.graphics.drawRoundRect(0,0,this._defaultWidth,_loc2_,this._cornerRadius);
         }
      }
      
      private function animate(param1:Boolean) : void
      {
         var _loc2_:int = param1 == true ? 1 : 0;
         if(Boolean(this._tween) && this._tween.isPlaying)
         {
            this._tween.stop();
         }
         this._tween = new Tween(this,"alpha",Strong.easeOut,this.alpha,_loc2_,0.5,true);
         if(param1 && this._hideDelay > 0)
         {
            if(this._timer.hasEventListener(TimerEvent.TIMER_COMPLETE))
            {
               this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.timerShow);
            }
            this._timer.reset();
            this._timer.delay = this._hideDelay;
            this._timer.start();
            this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.timerHide);
         }
         if(!param1)
         {
            this._tween.addEventListener(TweenEvent.MOTION_FINISH,this.onComplete);
            this._timer.reset();
         }
      }
      
      private function onComplete(param1:TweenEvent) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         if(this.autoCleanUp)
         {
            this.cleanUp();
         }
      }
      
      public function set followMouse(param1:Boolean) : void
      {
         this._followMouse = param1;
      }
      
      public function get followMouse() : Boolean
      {
         return this._followMouse;
      }
      
      public function set buffer(param1:Number) : void
      {
         this._buffer = param1;
      }
      
      public function get buffer() : Number
      {
         return this._buffer;
      }
      
      public function set bgAlpha(param1:Number) : void
      {
         this._bgAlpha = param1;
      }
      
      public function get bgAlpha() : Number
      {
         return this._bgAlpha;
      }
      
      public function set tipPosition(param1:String) : void
      {
         this._tipPosition = param1;
      }
      
      public function get tipPosition() : String
      {
         return this._tipPosition;
      }
      
      public function set tipWidth(param1:Number) : void
      {
         this._defaultWidth = param1;
         if(this._tf)
         {
            this._tf.width = param1;
         }
      }
      
      public function set align(param1:String) : void
      {
         var _loc2_:String = param1.toLowerCase();
         var _loc3_:String = "right left center";
         if(_loc3_.indexOf(param1) == -1)
         {
            throw new Error(this + " : Invalid Align Property, options are: \'right\', \'left\' & \'center\'");
         }
         this._align = _loc2_;
      }
      
      public function set delay(param1:Number) : void
      {
         this._showDelay = param1;
         this._timer.delay = param1;
      }
      
      public function set hook(param1:Boolean) : void
      {
         this._hookEnabled = param1;
      }
      
      public function get hookPosition() : String
      {
         return this._hookPosition;
      }
      
      public function set hookPosition(param1:String) : void
      {
         this._hookPosition = param1;
      }
      
      public function set hookSize(param1:Number) : void
      {
         this._hookSize = param1;
      }
      
      public function set cornerRadius(param1:Number) : void
      {
         this._cornerRadius = param1;
      }
      
      public function set colors(param1:Array) : void
      {
         this._bgColors = param1;
      }
      
      public function set autoSize(param1:Boolean) : void
      {
         this._autoSize = param1;
      }
      
      public function set hideOnMouseOut(param1:Boolean) : void
      {
         this._hideOnMouseOut = param1;
      }
      
      public function set hideOnMouseDown(param1:Boolean) : void
      {
         this._hideOnMouseDown = param1;
      }
      
      public function set border(param1:uint) : void
      {
         this._border = param1;
      }
      
      public function set borderSize(param1:Number) : void
      {
         this._borderSize = param1;
      }
      
      public function set tipHeight(param1:Number) : void
      {
         this._defaultHeight = param1;
      }
      
      public function set titleEmbed(param1:Boolean) : void
      {
         this._titleEmbed = param1;
      }
      
      public function set contentEmbed(param1:Boolean) : void
      {
         this._contentEmbed = param1;
      }
      
      public function get contentFormat() : TextFormat
      {
         return this._contentFormat;
      }
      
      public function set contentFormat(param1:TextFormat) : void
      {
         this._contentFormat = param1;
      }
      
      public function get titleFormat() : TextFormat
      {
         return this._titleFormat;
      }
      
      public function set titleFormat(param1:TextFormat) : void
      {
         this._titleFormat = param1;
      }
      
      public function get hideDelay() : Number
      {
         return this._hideDelay;
      }
      
      public function set hideDelay(param1:Number) : void
      {
         this._hideDelay = param1;
      }
      
      public function get autoCleanUp() : Boolean
      {
         return this._autoCleanUp;
      }
      
      public function set autoCleanUp(param1:Boolean) : void
      {
         this._autoCleanUp = param1;
      }
      
      private function initTitleFormat() : void
      {
         this._titleFormat = new TextFormat();
         this._titleFormat.font = "_sans";
         this._titleFormat.bold = true;
         this._titleFormat.size = 20;
         this._titleFormat.color = 3355443;
      }
      
      private function initContentFormat() : void
      {
         this._contentFormat = new TextFormat();
         this._contentFormat.font = "_sans";
         this._contentFormat.bold = false;
         this._contentFormat.size = 14;
         this._contentFormat.color = 3355443;
      }
      
      private function addedToStage(param1:DisplayObject) : Boolean
      {
         var _loc2_:Stage = param1.stage;
         return _loc2_ == null ? false : true;
      }
      
      private function setOffset() : void
      {
         switch(this._align)
         {
            case "left":
               this._hookOffSet = this.width - this._buffer * 3 - this._hookSize;
               if(this._hookPosition == "left" || this._hookPosition == "right")
               {
                  this._hookOffSet = this.height - this._buffer * 3 - this._hookSize;
               }
               break;
            case "right":
               this._hookOffSet = this._buffer * 3 + this._hookSize;
               break;
            case "center":
               this._hookOffSet = this.width / 2;
               if(this.tipPosition == "left" || this.tipPosition == "right")
               {
                  this._tipOffSet = this.height / 2;
               }
               else
               {
                  this._tipOffSet = this.width / 2;
               }
               if(this._hookPosition == "left" || this._hookPosition == "right")
               {
                  this._hookOffSet = this.height / 2;
               }
               break;
            default:
               this._hookOffSet = this.width / 2;
               if(this._hookPosition == "left" || this._hookPosition == "right")
               {
                  this._hookOffSet = this.height / 2;
               }
         }
      }
      
      private function cleanUp() : void
      {
         this._parentObject.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         this._parentObject.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this.follow(false);
         this._contentContainer.removeChild(this._tf);
         this._tf = null;
         if(this._cf != null)
         {
            this._contentContainer.removeChild(this._cf);
         }
         this.graphics.clear();
         removeChild(this._contentContainer);
         parent.removeChild(this);
      }
   }
}

