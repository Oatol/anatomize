package powers
{
   import Box2D.Common.Math.b2Vec2;
   
   public class PowerHole extends Power
   {
      
      public function PowerHole()
      {
         super(Tool.HOLE);
         noThrow = true;
         noEffectForce = false;
         noEffectRadius = false;
      }
      
      override public function Throw(param1:b2Vec2, param2:b2Vec2) : void
      {
         Main.instance.stopDragging();
      }
   }
}

