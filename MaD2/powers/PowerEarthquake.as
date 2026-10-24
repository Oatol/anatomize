package powers
{
   import Box2D.Common.Math.b2Vec2;
   import com.anegmetex.Soundmanager.sounds;
   
   public class PowerEarthquake extends Power
   {
      
      public function PowerEarthquake()
      {
         super(Tool.EARTHQUAKE,"boulder","quake");
         throwSound = "crash";
         throwVol = 0.8;
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
            GameState.objects.addbullet("quake",param1.x / Physics.scale + throwPos.x,param1.y / Physics.scale + throwPos.y,Math.random() * Math.PI * 2,1,1,new b2Vec2(Math.random() * 2 - 1,Math.random() * 2 - 1),0,Physics.world.GetGroundBody());
            sounds.play("crash",null,param1,0.15 + Math.random() * 0.05);
         }
      }
   }
}

