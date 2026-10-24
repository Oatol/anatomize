package powers
{
   import Box2D.Common.Math.b2Vec2;
   
   public class PowerToxic extends Power
   {
      
      public function PowerToxic()
      {
         super(Tool.TOXIC,"poison","tox");
      }
      
      override public function Press(param1:b2Vec2, param2:b2Vec2) : void
      {
         var _loc3_:b2Vec2 = null;
         if(param2.Length() > 1)
         {
            return;
         }
         if(Math.random() > 0.9)
         {
            ThrowUpdate(new b2Vec2());
            _loc3_ = throwPos.Copy();
            GameState.objects.addbullet("tox",param1.x / Physics.scale + throwPos.x,param1.y / Physics.scale + throwPos.y,Math.random() * Math.PI * 2,1,1,_loc3_,0,Physics.world.GetGroundBody());
         }
      }
   }
}

