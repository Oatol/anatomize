package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PowerDisc extends Power
   {
      
      public function PowerDisc()
      {
         super(Tool.DISC,"laser","spi");
         noPressRadius = true;
         throwSound = "disc_shoot";
         throwVol = 0.4;
         noEffectRadius = false;
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
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

