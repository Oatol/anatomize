package powers
{
   import Box2D.Common.Math.b2Vec2;
   
   public class PowerRicochet extends Power
   {
      
      public function PowerRicochet()
      {
         super(Tool.RICOCHET);
         noThrow = true;
         noPressRadius = true;
      }
      
      override public function Throw(param1:b2Vec2, param2:b2Vec2) : void
      {
         Main.instance.stopDragging();
      }
   }
}

