package com.colour.controls
{
   import flash.events.Event;
   
   public class SliderEvent extends Event
   {
      
      public static const SLIDER_EVENT:String = "sliderEvent";
      
      public function SliderEvent()
      {
         super(SLIDER_EVENT);
      }
   }
}

