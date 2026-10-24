package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   import triggers.HailBullet;
   
   public class PowerHail extends Power
   {
      
      public function PowerHail()
      {
         super(Tool.HAIL,"hail","hail");
      }
      
      override public function Press(param1:b2Vec2, param2:b2Vec2) : void
      {
         super.Press(param1,param2);
         if(Math.random() > 0.9)
         {
            sounds.random(["cryo"],null,param1,0.2 + Math.random() * 0.2);
         }
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         super.OnBodyPress(param1);
         if(bodyUD.name == "hail")
         {
            return;
         }
         if(Math.random() < 0.9)
         {
            return;
         }
         var _loc2_:b2Vec2 = bodyPos.Copy();
         _loc2_.Multiply(Physics.scale);
         var _loc3_:b2Vec2 = GeneralUtils.pointOnCircle(_loc2_.x,_loc2_.y,Tweak.toolRadius + Tweak.toolRadius * 3 * Math.random(),Math.random() * 360);
         var _loc4_:userData = Properties.objTemp("hail");
         _loc4_.trigger = new HailBullet();
         _loc4_.triggered = true;
         _loc4_.ignore = "hailstorm";
         _loc4_.projectileName = "hail";
         _loc4_.killOnContact = true;
         var _loc5_:b2Body = Spawn.circle(_loc3_.x,_loc3_.y,0.1,_loc4_,[1,1,1]);
         var _loc6_:b2Vec2 = new b2Vec2(_loc2_.x - _loc3_.x,_loc2_.y - _loc3_.y);
         _loc6_.Multiply(0.001);
         _loc5_.ApplyForce(_loc6_,_loc5_.GetWorldCenter());
         if(Math.random() > 0.8)
         {
            sounds.random(["hitfrozen","cryo","swish"],null,_loc2_,0.7);
         }
      }
   }
}

