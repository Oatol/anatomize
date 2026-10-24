package
{
   public class Tweak
   {
      
      public static var jointColour:uint;
      
      public static var download:Boolean = true;
      
      public static var m_iterations:int = 6;
      
      public static var m_timeStep:Number = 1 / 50;
      
      public static var RotateStep:Number = 5;
      
      public static var ScaleStep:Number = 0.05;
      
      public static var ZoomStep:Number = 0.02;
      
      public static var GridSize:Number = 50;
      
      public static var MaxStickyJoints:Number = 4;
      
      public static var MaxUserJoints:Number = 10;
      
      public static var PortalSpeedCap:Number = 50;
      
      public static var bloodColour:uint = 10027008;
      
      public static var bloodSmoothing:Number = 0.4;
      
      public static var smoothBloodSize:int = 12;
      
      public static var FillAlpha:Number = 1;
      
      public static var LineWidth:Number = 1;
      
      public static var LineAlpha:Number = 1;
      
      public static var ScaleMin:Number = 0.01;
      
      public static var ScaleMax:Number = 10;
      
      public static var BackgroundScroll:Number = 0.2;
      
      public static var AntiFreezeFPS:Number = 0;
      
      public static var UIScale:Number = 1;
      
      public static var MinShrapnelSize:Number = 0.1;
      
      public static var toolDeadzone:Number = 24;
      
      public static var toolScaleModifier:Number = 0.01;
      
      public static var toolRadius:Number = 50;
      
      public static var toolThrowRadius:Number = 50;
      
      public static var toolSpeed:Number = 4;
      
      public static var toolSpread:Number = 10;
      
      public static var toolProjectiles:Number = 4;
      
      public static var toolDuration:Number = 3;
      
      public static var toolEffectRadius:Number = 50;
      
      public static var toolEffectForce:Number = 100;
      
      public static var jointForce:Number = 40000;
      
      public static var jointCollide:Boolean = true;
      
      public static var jointMotor:Boolean = false;
      
      public static var jointMotorSpeed:Number = 0;
      
      public static var jointMotorForce:Number = 0;
      
      public static var jointFrequency:Number = 2;
      
      public static var jointDamping:Number = 0.01;
      
      public static var jointVisible:Boolean = true;
      
      public static var jointCenter:Boolean = false;
      
      public static var jointWidth:int = 2;
      
      public static var jointLimited:Boolean = false;
      
      public static var jointLimitedLower:Boolean = true;
      
      public static var jointLimitedUpper:Boolean = true;
      
      public static var jointUpper:Number = 0;
      
      public static var jointLower:Number = 0;
      
      public static const FONT:String = new yanone().fontName;
      
      public static var maxSelectedBodies:int = 5000;
      
      public static var standForce:Number = -36;
      
      public function Tweak()
      {
         super();
      }
   }
}

