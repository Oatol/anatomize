package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class HotDogCart extends Trigger
   {
      
      public function HotDogCart()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Item = null;
         var _loc4_:Array = null;
         var _loc6_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(param2.triggerDuration > 0)
         {
            param2.triggerDuration -= TimeLord.speed;
            return;
         }
         if(param2.originalTriggerDuration < 10)
         {
            param2.originalTriggerDuration = 10;
         }
         param2.triggerDuration = param2.originalTriggerDuration;
         _loc3_ = O.getItem("sausagewithbuns");
         _loc4_ = _loc3_.colours;
         var _loc5_:b2Vec2 = param2.triggerPos.Copy();
         if(param2.flipped)
         {
            _loc5_.x *= -1;
         }
         _loc6_ = BoxUtils.rotateVec(_loc5_,bodyAngle);
         _loc6_.y += Math.random() * 50 - 25;
         _loc6_.x += Math.random() * 50 - 25;
         var _loc7_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc6_.x,pixelCenter.y + _loc6_.y);
         var _loc8_:b2Body = GameState.objects.spawnItem(_loc3_.vertices,[0.1],_loc3_.scale * param2.size,"sausagewithbuns",_loc7_.x,_loc7_.y,bodyAngle,_loc4_);
         userData(_loc8_.GetUserData()).trigger = new TempProjectile(Math.random() * 20 + 20,10,"fried");
         userData(_loc8_.GetUserData()).triggerOnContact = true;
         var _loc9_:b2Vec2 = new b2Vec2(_loc7_.x - pixelCenter.x,_loc7_.y - pixelCenter.y);
         _loc9_.Multiply(param2.triggerForce);
         _loc8_.ApplyForce(_loc9_,_loc8_.GetWorldCenter());
         _loc8_.ApplyTorque(Math.random() * 20 - 10);
      }
   }
}

