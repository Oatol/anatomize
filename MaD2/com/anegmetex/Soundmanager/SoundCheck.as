package com.anegmetex.Soundmanager
{
   import flash.media.SoundChannel;
   
   public class SoundCheck
   {
      
      private var _channel:SoundChannel;
      
      private var _name:String;
      
      public function SoundCheck(param1:String, param2:SoundChannel)
      {
         super();
         this._name = param1;
         this._channel = param2;
      }
      
      public function get channel() : SoundChannel
      {
         return this._channel;
      }
      
      public function get name() : String
      {
         return this._name;
      }
   }
}

