package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import triggers.ModifyGravity;
   
   public class PowerLevity extends Power
   {
      
      public function PowerLevity()
      {
         super(Tool.LEVITY,"gravity","levity");
         noDuration = false;
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         bodyUD.trigger = new ModifyGravity(-1);
         bodyUD.triggerDuration = Tweak.toolDuration * 60;
         bodyUD.triggered = true;
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

