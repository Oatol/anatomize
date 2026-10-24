package powers
{
   import Box2D.Common.Math.b2Vec2;
   
   public class PowerSharp extends Power
   {
      
      public function PowerSharp()
      {
         super(Tool.SHARP);
         noThrow = true;
         noPressRadius = true;
      }
      
      override public function Throw(param1:b2Vec2, param2:b2Vec2) : void
      {
         Main.instance.stopDragging();
      }
   }
}

