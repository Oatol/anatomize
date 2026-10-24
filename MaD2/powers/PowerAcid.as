package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import triggers.Acided;
   
   public class PowerAcid extends Power
   {
      
      public function PowerAcid()
      {
         super(Tool.ACID,"acid","aci");
         throwSound = "throw2";
         bodySound = "acidburn";
         noEffectRadius = false;
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         bodyUD.trigger = new Acided();
         bodyUD.triggerDuration = 120;
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

