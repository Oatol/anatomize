package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class TransmuteRandom extends Trigger
   {
      
      public function TransmuteRandom()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         var _loc3_:Array = param2.triggerCustom.split(",");
         var _loc4_:String = _loc3_[int(Math.random() * _loc3_.length)];
         param2.trigger = new Transmute(_loc4_);
      }
   }
}

