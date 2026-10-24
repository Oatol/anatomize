package
{
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class BigJuicyMenuButton
   {
      
      protected var juicychild:DisplayObject;
      
      internal var scaleMulti:* = 1.1;
      
      internal var tooltipText:String;
      
      public function BigJuicyMenuButton(param1:DisplayObject, param2:Function, param3:Number = 1.1, param4:* = "")
      {
         super();
         if(!param1)
         {
            return;
         }
         this.scaleMulti = param3;
         this.tooltipText = param4;
         param1.addEventListener(MouseEvent.MOUSE_OVER,this.bigger);
         if(param1 is Sprite)
         {
            Sprite(param1).buttonMode = true;
         }
         if(param1 is MovieClip)
         {
            MovieClip(param1).buttonMode = true;
         }
         if(Boolean(param2))
         {
            param1.addEventListener(MouseEvent.CLICK,param2);
         }
         if(param1 is Sprite)
         {
            Sprite(param1).tabEnabled = false;
            Sprite(param1).tabChildren = false;
         }
         else if(param1 is MovieClip)
         {
            MovieClip(param1).tabEnabled = false;
            MovieClip(param1).tabChildren = false;
         }
         this.juicychild = param1;
      }
      
      private function bigger(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.currentTarget as DisplayObject;
         _loc2_.removeEventListener(MouseEvent.MOUSE_OVER,this.bigger);
         _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.smaller);
         _loc2_.scaleX = this.scaleMulti;
         _loc2_.scaleY = this.scaleMulti;
         sounds.play("ui_hover",null,null,0.4);
         if(this.tooltipText)
         {
            GameState.ui.showTooltip(_loc2_.parent,this.tooltipText,0,1000,_loc2_.parent.width);
         }
      }
      
      private function smaller(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.currentTarget as DisplayObject;
         _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.bigger);
         _loc2_.removeEventListener(MouseEvent.MOUSE_OUT,this.smaller);
         _loc2_.scaleX = 1;
         _loc2_.scaleY = 1;
      }
      
      public function set x(param1:Number) : void
      {
         this.juicychild.x = param1;
      }
      
      public function set y(param1:Number) : void
      {
         this.juicychild.y = param1;
      }
      
      public function get x() : Number
      {
         return this.juicychild.x;
      }
      
      public function get y() : Number
      {
         return this.juicychild.y;
      }
      
      public function get child() : DisplayObject
      {
         return this.juicychild;
      }
   }
}

