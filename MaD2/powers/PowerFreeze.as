package powers
{
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class PowerFreeze extends Power
   {
      
      public function PowerFreeze()
      {
         super(Tool.FREEZE,"crystal","cry");
         throwSound = "cryo";
         bodySound = "cryo";
         throwVol = 0.3;
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         var _loc2_:BitmapData = null;
         var _loc3_:BitmapData = null;
         super.OnBodyPress(param1);
         if(bodyUD.temperature > -100)
         {
            bodyUD.temperature -= 10;
         }
         if(bodyUD.temperature < 0)
         {
            if(Math.random() > 0.9)
            {
               _loc2_ = BoxUtils.getEffectBMD(param1);
               if(_loc2_)
               {
                  _loc3_ = _loc2_.clone();
                  _loc2_.copyPixels(_loc3_,_loc2_.rect,new Point(),null,null,true);
                  _loc2_.copyPixels(R.getSprite("p_crystal"),new Rectangle(0,0,8,8),new Point(Math.random() * bodyUD.width,Math.random() * bodyUD.height),null,null,true);
               }
            }
            if(bodyUD.temperature > -90)
            {
               Body.Freeze(param1,-100);
            }
         }
      }
   }
}

