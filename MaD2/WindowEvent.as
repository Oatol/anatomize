package
{
   import flash.events.Event;
   
   public class WindowEvent extends Event
   {
      
      public static const ON_OPEN:String = "onOpen";
      
      public static const ON_CLOSE:String = "onClose";
      
      public static const ON_MINIMISE:String = "onMinimise";
      
      public static const ON_MAXIMISE:String = "onMaximise";
      
      public static const ON_SELECT:String = "onSelect";
      
      public static const ON_RESIZE:String = "onResize";
      
      public static const START_RESIZE:String = "onStartResize";
      
      public static const STOP_RESIZE:String = "onStopResize";
      
      public var name:String;
      
      public function WindowEvent(param1:String, param2:String)
      {
         this.name = param2;
         super(param1);
      }
   }
}

