package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import triggers.Napalmed;
   
   public class PowerHandshake extends Power
   {
      
      public function PowerHandshake()
      {
         super(Tool.HANDSHAKE,"reds","shakePower");
         noEffectRadius = false;
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         if(bodyUD.resistFlame)
         {
            return;
         }
         if(bodyUD.temperature < 90)
         {
            bodyUD.temperature = 100;
         }
         bodyUD.conductivity = 0.1;
         bodyUD.ignition = 100;
         bodyUD.trigger = new Napalmed();
         bodyUD.triggerDuration = 520;
         bodyUD.triggered = true;
      }
      
      override protected function OnProjectileThrow(param1:b2Vec2, param2:b2Vec2) : void
      {
         super.OnProjectileThrow(param1,param2);
         if(!throwBody)
         {
            return;
         }
         userData(throwBody.GetUserData()).triggerRadius = Tweak.toolEffectRadius;
      }
   }
}

