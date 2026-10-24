package com.colour.controls
{
   import flash.display.CapsStyle;
   import flash.display.GraphicsPath;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   
   public class Handle extends Sprite
   {
      
      protected var path:GraphicsPath;
      
      public var lineThickness:Number;
      
      public var lineColour:uint;
      
      public var handleWidth:Number;
      
      public var handleHeight:Number;
      
      public var handleBorder:Number;
      
      public function Handle(param1:uint = 0, param2:Number = 10, param3:Number = 10, param4:Number = 2, param5:Number = NaN, param6:uint = 0)
      {
         super();
         this.lineThickness = param5;
         this.lineColour = param6;
         this.handleWidth = param2;
         this.handleHeight = param3;
         this.handleBorder = param4;
         this.draw(param1);
      }
      
      public function draw(param1:uint) : void
      {
         graphics.clear();
         graphics.lineStyle(this.lineThickness,this.lineColour,1,true,LineScaleMode.NONE,CapsStyle.ROUND,JointStyle.MITER);
         graphics.beginFill(param1);
         graphics.drawRect(0,0,this.handleWidth,this.handleHeight);
         graphics.drawRect(this.handleBorder,this.handleBorder,this.handleWidth - this.handleBorder * 2,this.handleHeight - this.handleBorder * 2);
         graphics.endFill();
         graphics.beginFill(0,0);
         graphics.drawRect(this.handleBorder,this.handleBorder,this.handleWidth - this.handleBorder * 2,this.handleHeight - this.handleBorder * 2);
         graphics.endFill();
      }
   }
}

