package
{
   public class Vars
   {
      
      public static var physScale:Number = 15;
      
      public static var speed:Number = 1;
      
      public static var slowspeed:Number = 0.1;
      
      public static var barscale:Number = 0.5;
      
      public static var dragEditor:Number = 1;
      
      public static var wheelSpeed:Number = 1;
      
      public static var dragDoll:Number = 1;
      
      public static var cameraAcceleration:Number = 0.5;
      
      public static var particles:Number = 1;
      
      public static var particlesMax:Number = 1000;
      
      public static var collisionsMax:Number = 20;
      
      public static var seed:Number = 42;
      
      public static var cutlimit:int = 10;
      
      public static var edgePanDelay:Number = 10;
      
      public static var loadSpeed:int = 1;
      
      private static var _gravity:Number = 0;
      
      private static var _wind:Number = 0;
      
      private static var _temp:Number = 0;
      
      public static var objSize:Number = 1;
      
      public static var objAngle:Number = 0;
      
      public static var objDensity:Number = 1;
      
      public static var objFriction:Number = 0.5;
      
      public static var objRestitution:Number = 0.2;
      
      public static var objDampLinear:Number = 0;
      
      public static var objDampAngular:Number = 0;
      
      public static var objHealth:Number = 100;
      
      public static var objMaxHealth:Number = 100;
      
      public static var toDegrees:Number = 57.29577951308232;
      
      public static var toRadians:Number = 0.017453292519943295;
      
      public static var PI:Number = 3.141592653589793;
      
      public static var stabSettings:Object = {};
      
      public static var gunSettings:Object = {};
      
      public function Vars()
      {
         super();
      }
      
      public static function set gravity(param1:Number) : void
      {
         _gravity = param1;
      }
      
      public static function get gravity() : Number
      {
         return _gravity;
      }
      
      public static function get wind() : Number
      {
         return _wind;
      }
      
      public static function set wind(param1:Number) : void
      {
         _wind = param1;
      }
      
      public static function get temperature() : Number
      {
         return _temp;
      }
      
      public static function set temperature(param1:Number) : void
      {
         _temp = param1;
      }
   }
}

