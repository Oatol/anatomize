package
{
   import Box2D.Common.Math.b2Vec2;
   
   public class World
   {
      
      public static var toggleRagdollBreak:int = 1;
      
      public static var toggleSlomo:int = 0;
      
      public static var toggleJointBreak:int = 1;
      
      public static var toggleObjectBreak:int = 1;
      
      public static var toggleContact:int = 1;
      
      public static var toggleStabilise:int = 1;
      
      public static var toggleEffects:int = 1;
      
      public static var togglePreciseEffects:int = 0;
      
      public static var toggleSounds:int = 1;
      
      public static var toggleStabi:int = 1;
      
      public static var toggleGore:int = 1;
      
      public static var toggleHealthbars:int = 0;
      
      public static var toggleDollbars:int = 0;
      
      public static var toggleArmourbars:int = 0;
      
      public static var toggleDollicons:int = 0;
      
      public static var toggleJoints:int = 1;
      
      public static var toggleJointsPause:int = 1;
      
      public static var toggleBlueprint:int = 0;
      
      public static var toggleGrid:int = 1;
      
      public static var toggleTemperature:int = 1;
      
      public static var toggleFahrenheit:int = 0;
      
      public static var toggleAutorespawn:int = 0;
      
      public static var toggleSmoothBlood:int = 1;
      
      public static var togglePhysicsBlood:int = 0;
      
      public static var toggleStrongDolls:int = 1;
      
      public static var toggleBodypartGibs:int = 1;
      
      public static var toggleShadows:int = 1;
      
      public static var toggleBackground:int = 1;
      
      public static var toggleEdgePan:int = 1;
      
      public static var toggleFloorPan:int = 0;
      
      public static var toggleEdgeStick:int = 1;
      
      public static var toggleDollSleep:int = 1;
      
      public static var toggleCutFilter:int = 1;
      
      public static var toggleVelocity:int = 1;
      
      public static var toggleRadius:int = 1;
      
      public static var toggleToolbox:int = 1;
      
      public static var rightClick:int = 1;
      
      public static var doubleClickSelect:int = 1;
      
      public static var scrollWheel:int = 1;
      
      public static var toggleLoopSides:int = 1;
      
      public static var toggleExtraGore:int = 0;
      
      public static var toggleSpawnBG:int = 1;
      
      public static var firstRunGeneric:int = 1;
      
      public static var firstRunCurrent:int = 1;
      
      public static var toggleShrapnel:int = 1;
      
      public static var toggleResetConfirm:int = 0;
      
      public static var togglePauseConfirm:int = 0;
      
      public static var toggleLinkPause:int = 1;
      
      public static var toggleLinkSelected:int = 1;
      
      public static var toggleJointSelected:int = 0;
      
      public static var toggleGibsGib:int = 1;
      
      public static var toggleSelectionGlow:int = 1;
      
      public static var toggleDarkMode:int = 1;
      
      public static var toggleScaleMode:int = 1;
      
      public static var toggleFullscreen:int = 0;
      
      public static var toggleJointsAlive:int = 1;
      
      public static var toggleIntegerSnap:int = 0;
      
      public static var toggleCulling:int = 1;
      
      public static var stampQuality:int = 1;
      
      public static var detailLocked:int = 1;
      
      public function World()
      {
         super();
      }
      
      public static function explode(param1:String, param2:b2Vec2, param3:Number, param4:Number, param5:Boolean = true, param6:int = 10, param7:String = "normal", param8:Array = null) : Explosion
      {
         return new Explosion(param2,param4,param3,param5,param6,param7,param8);
      }
   }
}

