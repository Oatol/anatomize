package powers
{
   import Box2D.Common.Math.b2Vec2;
   import com.anegmetex.Soundmanager.sounds;
   
   public class PowerLaser extends Power
   {
      
      public function PowerLaser()
      {
         super(Tool.LASER,"laser","las");
         throwSound = "pulse_shoot";
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
            GameState.objects.addbullet("las",param1.x / Physics.scale + throwPos.x,param1.y / Physics.scale + throwPos.y,0,1,1,throwPos,0,Physics.world.GetGroundBody());
            sounds.play("pulse_shoot",null,param1,0.5);
         }
      }
   }
}

