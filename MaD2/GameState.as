package
{
   import Box2D.Dynamics.b2Body;
   import environment.Environment;
   import flash.system.Capabilities;
   
   public class GameState
   {
      
      public static var width:Number;
      
      public static var height:Number;
      
      public static var environment:Environment;
      
      public static var followBody:b2Body;
      
      public static var keymap:Keymap;
      
      public static var cutter:Cutter;
      
      public static var tutorial:Tutorial;
      
      public static var menuHandler:MenuHandler;
      
      public static var dragging:b2Body;
      
      public static var hullHandler:ConvexHull;
      
      public static var particles:PS;
      
      public static var objects:Obj;
      
      public static var ui:UI;
      
      public static var tool:String;
      
      public static var steamworks:*;
      
      public static var version:int = 20236;
      
      public static var spawning:Boolean = false;
      
      public static var spawningCustom:Boolean = false;
      
      public static var cloning:Boolean = false;
      
      public static var spawningEnvironment:Boolean = false;
      
      public static var cutting:Boolean = false;
      
      public static var resizing:Boolean = false;
      
      public static var flipping:Boolean = false;
      
      public static var mapping:Boolean = false;
      
      public static var slomo:Boolean = false;
      
      public static var roleplaying:Boolean = false;
      
      public static var paused:Boolean = false;
      
      public static var contact:Boolean = true;
      
      public static var environmenting:Boolean = false;
      
      public static var previewing:Boolean = false;
      
      public static var quickspawning:Boolean = false;
      
      public static var focused:Boolean = false;
      
      public static var skinning:Boolean = false;
      
      public static var stamping:Boolean = false;
      
      public static var fooling:Boolean = false;
      
      public static var mouseDown:Boolean = false;
      
      public static var rightDown:Boolean = false;
      
      public static var mappingItem:int = 0;
      
      public static var canJump:Boolean = false;
      
      public static var customgfx:Boolean = true;
      
      public static var screenshotMode:Boolean = false;
      
      public static var madeby:String = "none";
      
      public static var tutorialActive:Boolean = false;
      
      public static var loading:Boolean = false;
      
      public static var playerVersion:Number = Number(Capabilities.version.split(" ")[1].replace(",",".").split(",")[0]);
      
      public static var ContentSort:String = "Newest";
      
      public static var ContentFilter:String = "by_newest";
      
      public static var AutoSave:String = "Never";
      
      public static var CustomSort:String = "Newest";
      
      public static var ImpactQuality:* = 2;
      
      public static var prioritizeSelection:Boolean = true;
      
      public static var simpleIgnores:Boolean = false;
      
      public function GameState()
      {
         super();
      }
      
      public static function get isRightClickCapable() : Boolean
      {
         return true;
      }
      
      public static function get isCapable() : Boolean
      {
         return true;
      }
   }
}

