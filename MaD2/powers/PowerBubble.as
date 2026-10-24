package powers
{
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   
   public class PowerBubble extends Power
   {
      
      public function PowerBubble()
      {
         super(Tool.BUBBLE,"bubbles","bubble");
         throwSound = "bubbles";
         bodySound = "bubbles";
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         var _loc2_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(_loc2_)
         {
            _loc2_.colorTransform(_loc2_.rect,new ColorTransform(1,1,1,0.9));
         }
      }
   }
}

