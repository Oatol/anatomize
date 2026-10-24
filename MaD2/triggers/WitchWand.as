package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class WitchWand extends Cauldron
   {
      
      internal var dur:Number = 10;
      
      public function WitchWand()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         whenToBoilOver = 100;
         maxProjectiles = 1;
         ud.triggerState = 0;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         --this.dur;
         if(this.dur <= 0)
         {
            updateTriggerHelpers();
            _loc3_ = 1 + Math.random() * Math.random() * Math.random() * 10;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               boil();
               _loc4_++;
            }
            this.dur = 10;
            param2.triggered = false;
         }
      }
   }
}

