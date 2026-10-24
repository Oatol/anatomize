package
{
   import flash.events.Event;
   
   public class LabEvent extends Event
   {
      
      public static const ON_LOAD_COMPLETE:String = "onLoadComplete";
      
      public var customMessage:Object = {};
      
      public function LabEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

