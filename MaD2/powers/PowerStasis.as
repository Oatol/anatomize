package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PowerStasis extends Power
   {
      
      public function PowerStasis()
      {
         super(Tool.STASIS,"forcefield","stasis");
         throwSound = "tesla_shoot";
         noDuration = false;
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         Body.Stasis(param1,Tweak.toolDuration * 60);
      }
      
      override protected function OnProjectileThrow(param1:b2Vec2, param2:b2Vec2) : void
      {
         super.OnProjectileThrow(param1,param2);
         if(!throwBody)
         {
            return;
         }
         userData(throwBody.GetUserData()).triggerDuration = Tweak.toolDuration * 60;
      }
   }
}

