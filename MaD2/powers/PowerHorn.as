package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import triggers.Bass;
   
   public class PowerHorn extends Power
   {
      
      public function PowerHorn()
      {
         super(Tool.HORN,"note","bss");
         noDuration = false;
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         if(!bodyUD.alive)
         {
            return;
         }
         if(bodyUD.trigger is Bass)
         {
            return;
         }
         bodyUD.triggerPos = new b2Vec2(4,4);
         bodyUD.trigger = new Bass();
         bodyUD.triggerDuration = Tweak.toolDuration;
         bodyUD.triggered = true;
         bodyUD.triggerLock = true;
      }
   }
}

