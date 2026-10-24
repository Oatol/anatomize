package powers
{
   import Box2D.Common.Math.b2Vec2;
   import com.anegmetex.Soundmanager.sounds;
   
   public class PowerBullet extends Power
   {
      
      public function PowerBullet()
      {
         super(Tool.BULLET,"poof","pis");
         pressSound = "magnum_shoot";
         throwSound = "magnum_shoot";
         noEffectForce = false;
      }
      
      override public function Press(param1:b2Vec2, param2:b2Vec2) : void
      {
         var _loc3_:b2Vec2 = null;
         if(param2.Length() > 1)
         {
            return;
         }
         if(Math.random() > 0.95)
         {
            ThrowUpdate(new b2Vec2());
            _loc3_ = throwPos.Copy();
            _loc3_.Multiply(Tweak.toolEffectForce);
            GameState.objects.addbullet("pis",param1.x / Physics.scale + throwPos.x,param1.y / Physics.scale + throwPos.y,Math.atan2(_loc3_.y,_loc3_.x),1,1,_loc3_,0,Physics.world.GetGroundBody());
            sounds.play(pressSound,null,param1,0.1 + Math.random() * 0.2);
         }
      }
   }
}

