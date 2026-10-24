package com.yahoo.astra.fl.events
{
   import fl.controls.listClasses.ICellRenderer;
   import flash.events.Event;
   
   public class TreeEvent extends Event
   {
      
      public static const ITEM_CLOSE:String = "itemClose";
      
      public static const ITEM_OPEN:String = "itemOpen";
      
      public var item:Object;
      
      public var itemRenderer:ICellRenderer;
      
      public var triggerEvent:Event;
      
      public function TreeEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Object = null, param5:ICellRenderer = null, param6:Event = null)
      {
         super(param1,param2,param3);
         this.item = param4;
         this.itemRenderer = param5;
         this.triggerEvent = param6;
      }
      
      override public function clone() : Event
      {
         return new TreeEvent(type,bubbles,cancelable,this.item,this.itemRenderer,this.triggerEvent);
      }
   }
}

