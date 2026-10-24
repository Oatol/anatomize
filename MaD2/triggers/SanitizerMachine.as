package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class SanitizerMachine extends Trigger
   {
      
      public function SanitizerMachine()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:userData = null;
         var _loc4_:b2Vec2 = null;
         var _loc5_:Number = NaN;
         var _loc6_:b2Vec2 = null;
         var _loc7_:Number = NaN;
         var _loc8_:b2Body = null;
         super.trigger(param1,param2);
         if(Math.random() > 0.7)
         {
            _loc3_ = Properties.objTemp("sanitizer");
            _loc3_.triggered = true;
            _loc3_.trigger = new MistBullet();
            _loc3_.triggerRadius = 50;
            _loc3_.projectileName = "ext";
            _loc4_ = param2.triggerPos.Copy();
            _loc4_.Multiply(param2.size);
            _loc5_ = -1;
            if(param2.flipped)
            {
               _loc4_.x *= -1;
               _loc5_ = 1;
            }
            param2.ignore = "sanitizer";
            _loc6_ = BoxUtils.rotateVec(_loc4_,bodyAngle);
            _loc7_ = bodyAngle;
            _loc8_ = Spawn.circle(pixelCenter.x + _loc6_.x,pixelCenter.y + _loc6_.y,2 * param2.size,_loc3_,[1,1,0]);
            _loc8_.SetLinearVelocity(new b2Vec2(_loc5_ * param2.triggerForce * param2.size * Math.cos(_loc7_) + Math.random() * 4 - 2,_loc5_ * param2.triggerForce * param2.size * Math.sin(_loc7_) + Math.random() * 4 - 2));
         }
      }
   }
}

