package powers
{
   import Box2D.Dynamics.b2Body;
   
   public class PowerGhost extends Power
   {
      
      public function PowerGhost()
      {
         super(Tool.GHOST,"ghost","ghost");
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         Body.Ghost(param1);
      }
   }
}

