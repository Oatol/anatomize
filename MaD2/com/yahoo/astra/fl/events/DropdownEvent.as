package com.yahoo.astra.fl.events
{
   import flash.events.Event;
   
   public class DropdownEvent extends Event
   {
      
      public static const CLOSE:String = "close";
      
      public static const OPEN:String = "open";
      
      public var triggerEvent:Event;
      
      public function DropdownEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Event = null)
      {
         super(param1,param2,param3);
         this.triggerEvent = param4;
      }
      
      override public function clone() : Event
      {
         return new DropdownEvent(type,bubbles,cancelable,this.triggerEvent);
      }
   }
}

