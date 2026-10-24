package powers
{
   import Box2D.Common.Math.b2Vec2;
   
   public class PowerShockwave extends Power
   {
      
      public function PowerShockwave()
      {
         super(Tool.SHOCKWAVE,"shock","ele");
         noThrow = true;
         throwSound = "shock";
      }
      
      override public function Press(param1:b2Vec2, param2:b2Vec2) : void
      {
         if(param2.Length() > 1)
         {
            return;
         }
         if(Math.random() > 0.9)
         {
            this.ThrowUpdate(new b2Vec2());
            GameState.objects.addbullet("tinyele",param1.x / Physics.scale + throwPos.x,param1.y / Physics.scale + throwPos.y,Math.random() * Math.PI * 2,1,1,new b2Vec2(),0,Physics.world.GetGroundBody());
         }
      }
      
      override protected function ThrowUpdate(param1:b2Vec2) : void
      {
         super.ThrowUpdate(param1);
         throwProjectiles = 1;
      }
   }
}

