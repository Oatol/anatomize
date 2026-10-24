package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class MagnetWhenSwung extends Magnet
   {
      
      public function MagnetWhenSwung()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         param2.triggerState = 3;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         if(param1.GetLinearVelocity().Length() > 50 || param1.GetAngularVelocity() > 50)
         {
            super.trigger(param1,param2);
         }
      }
   }
}

