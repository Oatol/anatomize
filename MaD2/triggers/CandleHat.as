package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class CandleHat extends ArmourHelmet
   {
      
      internal var done:Boolean = false;
      
      public function CandleHat(param1:b2Body, param2:Number, param3:Number = 0.1, param4:Number = 0.5, param5:Number = 100)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         ud.triggerLock = false;
         ud.triggered = true;
      }
      
      override public function OnJoint(param1:b2Body, param2:String) : Boolean
      {
         ud.triggerLock = false;
         ud.triggered = true;
         ud.triggerLock = true;
         return super.OnJoint(param1,param2);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         ud.triggered = true;
         if(attachedBody)
         {
            ud.trigger = new Candlestick(new b2Vec2(0,-24),new b2Vec2(0,-28));
         }
      }
   }
}

