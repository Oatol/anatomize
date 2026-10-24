package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class SanitizerBottle extends Trigger
   {
      
      public function SanitizerBottle()
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
         _loc3_.Multiply(param2.size);
         var _loc4_:Number = bodyAngle;
         var _loc5_:userData = Properties.objTemp("sanitizer");
         _loc5_.trigger = new Water();
         Water(_loc5_.trigger).setParticle("snow");
         _loc5_.triggered = true;
         _loc5_.projectileName = "ext";
         _loc5_.ignore = "sanitizer";
         var _loc6_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc7_:b2Body = Spawn.circle(pixelCenter.x + _loc6_.x,pixelCenter.y + _loc6_.y,2 * param2.size,_loc5_,[1,1,0]);
         var _loc8_:Number = Math.random() * 10 - 5;
         var _loc9_:int = 1;
         if(param2.flipped)
         {
            _loc9_ = -1;
         }
         _loc7_.SetLinearVelocity(new b2Vec2(param2.triggerForce * -10 * _loc9_ * param2.size * Math.cos(_loc4_) + _loc8_,param2.triggerForce * -10 * _loc9_ * param2.size * Math.sin(_loc4_) + _loc8_));
         _loc4_ += Math.PI;
      }
   }
}

