package powers
{
   import Box2D.Common.Math.b2Vec2;
   import com.anegmetex.Soundmanager.sounds;
   
   public class PowerBee extends Power
   {
      
      public function PowerBee()
      {
         super(Tool.BEE,"bees","bee");
         pressSound = "hivecannon_shoot";
         bodySound = "stab1";
         throwSound = "hivecannon_shoot";
         throwVol = 1;
      }
      
      override public function Press(param1:b2Vec2, param2:b2Vec2) : void
      {
         if(param2.Length() > 1)
         {
            return;
         }
         ThrowUpdate(new b2Vec2());
         GameState.objects.addbullet("bee",param1.x / Physics.scale + throwPos.x,param1.y / Physics.scale + throwPos.y,0,1,1,throwPos,0,Physics.world.GetGroundBody());
         sounds.play(pressSound,null,param1,Math.random() * 0.5);
      }
   }
}

