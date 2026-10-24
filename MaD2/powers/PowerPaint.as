package powers
{
   import Box2D.Common.Math.b2Vec2;
   
   public class PowerPaint extends Power
   {
      
      public function PowerPaint()
      {
         super(Tool.PAINT,"simple","pnt");
         throwSound = "drain2";
      }
      
      override public function Press(param1:b2Vec2, param2:b2Vec2) : void
      {
         if(param2.Length() > 1)
         {
            return;
         }
         if(Math.random() > 0.9)
         {
            ThrowUpdate(new b2Vec2());
            GameState.objects.addbullet("pnt",param1.x / Physics.scale + throwPos.x,param1.y / Physics.scale + throwPos.y,0,1,1,throwPos,0,Physics.world.GetGroundBody());
         }
      }
      
      override protected function AddParticles(param1:b2Vec2, param2:b2Vec2) : void
      {
         var _loc3_:int = 50 + Math.random() * 200 >> 0;
         var _loc4_:int = 50 + Math.random() * 200 >> 0;
         var _loc5_:int = 50 + Math.random() * 200 >> 0;
         var _loc6_:* = _loc3_.toString(16) + _loc4_.toString(16) + _loc5_.toString(16);
         var _loc7_:uint = uint("0x" + _loc6_);
         var _loc8_:b2Vec2 = GeneralUtils.pointOnCircle(param1.x,param1.y,particleRadius,particleAngle);
         GameState.particles.addSimpleParticles(_loc8_.x,_loc8_.y,1,uint("0xFF" + _loc7_),param2.x * 0.1,param2.y * 0.1);
      }
   }
}

