package powers
{
   import Box2D.Common.Math.b2Vec2;
   
   public class PowerTidal extends Power
   {
      
      public function PowerTidal()
      {
         super(Tool.TIDAL,"water","tidal");
         throwSound = "splash";
         throwVol = 1;
         noEffectForce = false;
      }
      
      override public function Press(param1:b2Vec2, param2:b2Vec2) : void
      {
         if(param2.Length() > 1)
         {
            return;
         }
         ThrowUpdate(new b2Vec2());
         var _loc3_:b2Vec2 = throwPos.Copy();
         _loc3_.Multiply(2 * Tweak.toolEffectForce);
         GameState.objects.addbullet("tidal",param1.x / Physics.scale + throwPos.x,param1.y / Physics.scale + throwPos.y,Math.random() * Math.PI * 2,1,1,_loc3_,0,Physics.world.GetGroundBody());
      }
   }
}

