package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class PowerFlame extends Power
   {
      
      public function PowerFlame()
      {
         super(Tool.FLAME,"fire2","flm");
         throwSound = "flamer_shoot";
         throwVol = 0.4;
      }
      
      override public function Press(param1:b2Vec2, param2:b2Vec2) : void
      {
         super.Press(param1,param2);
         sounds.play("burn",null,param1,1,false);
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         if(!bodyUD.burning)
         {
            bodyUD.temperature += 10;
         }
      }
   }
}

