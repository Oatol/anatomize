package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class EmitProjectiles extends Trigger
   {
      
      public function EmitProjectiles()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration <= 0)
         {
            param2.triggered = false;
            param2.triggerDuration = param2.originalTriggerDuration;
         }
         if(TimeLord.speed < 1 && Math.random() * TimeLord.speed > TimeLord.speed * 0.1)
         {
            return;
         }
         _loc3_ = param2.triggerPos.Copy();
         if(param2.flipped)
         {
            _loc3_.x *= -1;
         }
         _loc3_.x += Math.random() * 10 - 5;
         _loc3_.y += Math.random() * 10 - 5;
         _loc3_.Multiply(param2.size / Physics.scale);
         _loc3_ = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc4_:Number = bodyAngle;
         var _loc5_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc6_:Number = Math.random() * 10 - 5;
         var _loc7_:b2Body = GameState.objects.addbullet(param2.triggerCustom,bodyCenter.x + _loc3_.x,bodyCenter.y + _loc3_.y,Math.random() * 360,1,Math.random() * 0.4 + 0.8,new b2Vec2(Math.random() * 10 - 5 + _loc3_.x,Math.random() * 10 - 5 + _loc3_.y),10,param1);
         if(!_loc7_)
         {
            return;
         }
         userData(_loc7_.GetUserData()).ignore = param2.name;
         var _loc8_:int = 1;
         if(param2.flipped)
         {
            _loc8_ = -1;
         }
         _loc7_.SetLinearVelocity(new b2Vec2(param2.triggerForce * _loc8_ * param2.size * Math.cos(_loc4_) + _loc6_,param2.triggerForce * _loc8_ * param2.size * Math.sin(_loc4_) + _loc6_));
         _loc4_ += Math.PI;
      }
   }
}

