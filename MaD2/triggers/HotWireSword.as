package triggers
{
   public class HotWireSword extends triggers.HotPlate
   {
      
      public function HotWireSword()
      {
         super();
      }
      
      public function HotPlate() : *
      {
         particles = ["smoke","fire2","fire3","fire3"];
         burnColour = 3351074;
      }
   }
}

