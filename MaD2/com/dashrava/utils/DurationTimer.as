package com.dashrava.utils
{
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class DurationTimer extends Timer
   {
      
      private var _startTime:int;
      
      private var _endTime:int;
      
      public function DurationTimer(param1:Number, param2:int = 0)
      {
         super(param1,param2);
      }
      
      public function get duration() : int
      {
         return running ? int(getTimer() - this._startTime) : int(this._endTime - this._startTime);
      }
      
      public function TimeLeft() : Number
      {
         if(!running)
         {
            return 0;
         }
         return (delay - this.duration % 60000) / 60000;
      }
      
      override public function start() : void
      {
         this._startTime = getTimer();
         super.start();
      }
      
      override public function stop() : void
      {
         this._endTime = getTimer();
         super.stop();
      }
   }
}

