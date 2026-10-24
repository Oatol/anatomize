package powers
{
   import Box2D.Common.Math.b2Vec2;
   import com.anegmetex.Soundmanager.sounds;
   
   public class PowerArc extends Power
   {
      
      public function PowerArc()
      {
         super(Tool.ARC,"trailblazer","car");
         throwSound = "arcgrenade";
         pressSound = "carbine_shoot";
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
            _loc3_.Multiply(Tweak.toolSpeed);
            GameState.objects.addbullet("car",param1.x / Physics.scale + throwPos.x,param1.y / Physics.scale + throwPos.y,0,1,1,_loc3_,0,Physics.world.GetGroundBody());
            sounds.play(pressSound,null,param1,Math.random() * 0.5);
         }
      }
   }
}

