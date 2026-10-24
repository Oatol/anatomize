package triggers
{
   public class Tombstone extends Trigger
   {
      
      public function Tombstone()
      {
         super();
      }
      
      override public function OnDelete() : void
      {
         super.OnDelete();
         Main.instance.comboRequisite = false;
      }
   }
}

