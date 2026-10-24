package
{
   import fl.motion.Color;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class TimeLord
   {
      
      private static var _slomotimer:Timer;
      
      private static var c:Color;
      
      private static var glow:GlowFilter;
      
      private static var _speed:Number = 1;
      
      private static var _tempSpeed:Number = 1;
      
      private static var _timerSpeed:Number = 1;
      
      private static var _slowdownfor:Number = 0;
      
      private static var _icon:BitmapData = new BitmapData(32,32,true,0);
      
      public static var pauseGrid:Grid = new Grid();
      
      private static var blueprint:uint = 328848;
      
      private static var wasFiller:Boolean = false;
      
      public function TimeLord()
      {
         super();
      }
      
      public static function pause() : void
      {
         if(!glow)
         {
            glow = new GlowFilter(16777215,1,2,2,10,1);
         }
         if(!c)
         {
            c = new Color();
            c.setTint(blueprint,1);
            c.alphaMultiplier = 0.25;
         }
         if(GameState.slomo)
         {
            if(_slomotimer)
            {
               _slomotimer.reset();
               _slomotimer.stop();
            }
         }
         _tempSpeed = _speed;
         _speed = 0;
         GameState.paused = true;
         _icon.fillRect(_icon.rect,0);
         _icon.copyPixels(R.getSprite("mode_edit"),_icon.rect,new Point());
         if(GameState.screenshotMode)
         {
            return;
         }
         pauseGrid.Redraw();
         Main.instance.particlesBMD.fillRect(Main.instance.particlesBMD.rect,0);
         EnableBlueprint();
      }
      
      public static function UpdateBlueprint() : void
      {
         if(World.toggleBlueprint == 1)
         {
            EnableBlueprint();
         }
         else
         {
            DisableBlueprint();
         }
      }
      
      public static function SetBlueprint() : void
      {
         if(GameState.paused)
         {
            EnableBlueprint();
         }
         else
         {
            DisableBlueprint();
         }
      }
      
      public static function EnableBlueprint() : void
      {
         if(World.toggleBlueprint == 0)
         {
            return;
         }
         Sprite(Main.instance.m_sprite.getChildByName("itemholder")).getChildByName("items").transform.colorTransform = c;
         Sprite(Main.instance.m_sprite.getChildByName("itemholder")).getChildByName("itemsFG").transform.colorTransform = c;
         Sprite(Main.instance.m_sprite.getChildByName("itemholder")).getChildByName("itemsBG").transform.colorTransform = c;
         Main.instance.m_sprite.getChildByName("itemholder").filters = [glow];
         Main.instance.bgBM.visible = false;
         Main.instance.stage.color = blueprint;
      }
      
      public static function DisableBlueprint() : void
      {
         Sprite(Main.instance.m_sprite.getChildByName("itemholder")).getChildByName("items").transform.colorTransform = new ColorTransform();
         Sprite(Main.instance.m_sprite.getChildByName("itemholder")).getChildByName("itemsFG").transform.colorTransform = new ColorTransform();
         Sprite(Main.instance.m_sprite.getChildByName("itemholder")).getChildByName("itemsBG").transform.colorTransform = new ColorTransform();
         Main.instance.m_sprite.getChildByName("itemholder").filters = [];
         Main.instance.stage.color = GameState.environment.backgroundColour;
         Main.instance.bgBM.visible = true;
      }
      
      public static function unpause() : void
      {
         Main.instance.pauseMoving = false;
         Main.instance.pauseMovingBodies = [];
         if(GameState.ui.menuTools.title == "Pause Settings")
         {
            GameState.ui.menuTools.close();
         }
         Main.instance.backgroundSprite.visible = true;
         Main.instance.itemSprite.visible = true;
         Main.instance.foregroundSprite.visible = true;
         if(GameState.slomo)
         {
            if(_slomotimer)
            {
               _slomotimer.start();
            }
         }
         _speed = _tempSpeed;
         if(_speed == 0)
         {
            _speed = Vars.speed;
         }
         _icon.fillRect(_icon.rect,0);
         _icon.copyPixels(R.getSprite("mode_play"),_icon.rect,new Point());
         GameState.paused = false;
         DisableBlueprint();
         pauseGrid.visible = false;
         Main.instance.CameraCull();
      }
      
      public static function slowTo(param1:Number) : *
      {
         if(GameState.previewing)
         {
            return;
         }
         if(GameState.paused)
         {
            return;
         }
         _slomotimer = new Timer(50 / _timerSpeed,param1);
         _slomotimer.addEventListener(TimerEvent.TIMER_COMPLETE,BackToTheNormal);
         _slomotimer.start();
         GameState.slomo = true;
         TimeLord.speed = 0.1;
      }
      
      public static function speedUp() : void
      {
         BackToTheNormal(null);
      }
      
      public static function toggle() : void
      {
         if(speed == 0)
         {
            unpause();
            pause();
         }
         else
         {
            pause();
            unpause();
         }
      }
      
      private static function BackToTheNormal(param1:TimerEvent) : void
      {
         GameState.slomo = false;
         TimeLord.speed = 1;
         if(_slomotimer)
         {
            _slomotimer.stop();
         }
      }
      
      public static function get speed() : Number
      {
         return _speed;
      }
      
      public static function set speed(param1:Number) : void
      {
         _speed = param1;
         _timerSpeed = _speed <= 0 ? 0.001 : _speed;
      }
      
      public static function get timerSpeed() : Number
      {
         return _timerSpeed;
      }
      
      public static function get pauseIcon() : BitmapData
      {
         return _icon;
      }
   }
}

