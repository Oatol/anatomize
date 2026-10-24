package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class CloneEffect extends Trigger
   {
      
      public function CloneEffect()
      {
         super();
      }
      
      override public function onTrigger() : void
      {
         var _loc1_:b2Body = null;
         super.onTrigger();
         for each(_loc1_ in ud.connected)
         {
            Body.CopyParticleEffect(body,_loc1_);
         }
      }
      
      override public function onUntrigger() : void
      {
         var _loc1_:b2Body = null;
         super.onUntrigger();
         for each(_loc1_ in ud.connected)
         {
            Body.CopyParticleEffect(null,_loc1_);
         }
      }
   }
}

