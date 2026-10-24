package powers
{
   import Box2D.Dynamics.b2Body;
   
   public class PowerProtect extends Power
   {
      
      public function PowerProtect()
      {
         super(Tool.PROTECT,"supershiny","protect");
         noDuration = false;
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         Body.Protect(param1,Tweak.toolDuration * 60);
      }
   }
}

