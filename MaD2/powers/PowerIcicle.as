package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import triggers.Disintegrate;
   
   public class PowerIcicle extends Power
   {
      
      public function PowerIcicle()
      {
         super(Tool.ICICLE,"snow","icicle2");
      }
      
      override protected function OnBodyPress(param1:b2Body) : void
      {
         var _loc2_:b2Vec2 = null;
         var _loc3_:b2Vec2 = null;
         super.OnBodyPress(param1);
         if(bodyUD.name == "icicle")
         {
            return;
         }
         if(Math.random() < 0.99)
         {
            return;
         }
         _loc2_ = param1.GetPosition().Copy();
         _loc2_.Multiply(Physics.scale);
         _loc3_ = new b2Vec2(_loc2_.x,_loc2_.y);
         _loc3_.x += Math.random() * 200 - 100;
         _loc3_.y -= Math.random() * 400 + 1000;
         var _loc4_:b2Body = GameState.objects.spawnObject("icicle",_loc3_.x,_loc3_.y,180,false,true);
         userData(_loc4_.GetUserData()).ignore = "wall";
         userData(_loc4_.GetUserData()).sharp = true;
         userData(_loc4_.GetUserData()).projectile = true;
         userData(_loc4_.GetUserData()).saveable = false;
         userData(_loc4_.GetUserData()).trigger = new Disintegrate("crystal",10,5);
         userData(_loc4_.GetUserData()).triggerOnContact = true;
         var _loc5_:b2Vec2 = new b2Vec2(0,_loc2_.y - _loc3_.y);
         _loc5_.Multiply(10);
         _loc4_.ApplyForce(_loc5_,_loc4_.GetWorldCenter());
      }
   }
}

