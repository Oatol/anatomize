package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class PowerSteam extends Power
   {
      
      public function PowerSteam()
      {
         super(Tool.STEAM,"poof","steam");
         bodySound = "hiss";
         throwSound = "hiss";
      }
      
      override public function Press(param1:b2Vec2, param2:b2Vec2) : void
      {
         var _loc3_:b2Body = null;
         if(param2.Length() > 1)
         {
            return;
         }
         if(Math.random() > 0.9)
         {
            ThrowUpdate(new b2Vec2());
            _loc3_ = GameState.objects.addbullet("steam",param1.x / Physics.scale + throwPos.x,param1.y / Physics.scale + throwPos.y,Math.random() * Math.PI * 2,1,1,new b2Vec2(Math.random() * 20 - 10,Math.random() * 20 - 10),0,Physics.world.GetGroundBody());
            if(_loc3_)
            {
               _loc3_.ApplyTorque(9000);
            }
            sounds.play("tinyhiss",null,param1);
         }
      }
   }
}

