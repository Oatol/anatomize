package powers
{
   import Box2D.Common.Math.b2Vec2;
   
   public class PowerPierce extends Power
   {
      
      public function PowerPierce()
      {
         super(Tool.PIERCE,"poof","com");
         noThrowSpeed = true;
         noThrowSpread = true;
         throwSound = "rifle_shoot";
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
            GameState.objects.addbullet("com",param1.x / Physics.scale + throwPos.x,param1.y / Physics.scale + throwPos.y,Math.random() * Math.PI * 2,1,1,new b2Vec2(Math.random() * 200 - 100,Math.random() * 200 - 100),0,Physics.world.GetGroundBody());
         }
      }
   }
}

