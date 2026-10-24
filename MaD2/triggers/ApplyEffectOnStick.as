package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class ApplyEffectOnStick extends Trigger
   {
      
      internal var bod:b2Body;
      
      public function ApplyEffectOnStick()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         super.trigger(param1,param2);
         if(this.bod)
         {
            _loc3_ = param2.triggerCustom.split(",");
            for each(_loc4_ in _loc3_)
            {
               Body.ApplyEffect(this.bod,_loc4_,pixelCenter,param1);
            }
            this.bod = null;
            param2.triggered = false;
         }
      }
      
      override public function OnStick(param1:b2Body) : void
      {
         super.OnStick(param1);
         this.bod = param1;
         ud.triggered = true;
      }
   }
}

