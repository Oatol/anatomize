package com.colour.controls
{
   import flash.events.Event;
   
   public class ColourPickerEvent extends Event
   {
      
      public static const COLOUR_PICKER_EVENT:String = "colourPickerEvent";
      
      public function ColourPickerEvent()
      {
         super(COLOUR_PICKER_EVENT);
      }
   }
}

