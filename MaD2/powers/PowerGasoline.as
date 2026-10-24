package powers
{
   import Box2D.Common.Math.b2Vec2;
   
   public class PowerGasoline extends Power
   {
      
      public function PowerGasoline()
      {
         super(Tool.GASOLINE,"gasoline","gas");
         throwSound = "drain4";
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
            GameState.objects.addbullet("gas",param1.x / Physics.scale + throwPos.x,param1.y / Physics.scale + throwPos.y,0,1,1,new b2Vec2(),0,Physics.world.GetGroundBody());
         }
      }
   }
}

