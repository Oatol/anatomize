package powers
{
   import Box2D.Common.Math.b2Vec2;
   
   public class PowerBlunt extends Power
   {
      
      public function PowerBlunt()
      {
         super(Tool.BLUNT);
         noPressRadius = true;
         noThrow = true;
      }
      
      override public function Throw(param1:b2Vec2, param2:b2Vec2) : void
      {
         Main.instance.stopDragging();
      }
   }
}

