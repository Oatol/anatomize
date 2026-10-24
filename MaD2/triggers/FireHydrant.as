package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class FireHydrant extends Trigger
   {
      
      public function FireHydrant()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:userData = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Body = null;
         var _loc9_:Number = NaN;
         super.trigger(param1,param2);
         if(Math.random() > 0.5)
         {
            if(TimeLord.speed < 1 && Math.random() * TimeLord.speed > TimeLord.speed * 0.1)
            {
               return;
            }
            _loc3_ = param2.triggerPos.Copy();
            _loc3_.Multiply(param2.size);
            _loc4_ = bodyAngle;
            _loc5_ = 0;
            while(_loc5_ < 2)
            {
               _loc6_ = Properties.objTemp("water");
               _loc6_.trigger = new Water();
               _loc6_.triggered = true;
               _loc6_.projectileName = "wat";
               _loc7_ = BoxUtils.rotateVec(_loc3_,bodyAngle);
               _loc8_ = Spawn.circle(pixelCenter.x + _loc7_.x,pixelCenter.y + _loc7_.y,2 * param2.size,_loc6_,[1,1,0]);
               _loc9_ = Math.random() * 10 - 5;
               _loc8_.SetLinearVelocity(new b2Vec2(param2.triggerForce * 10 * param2.size * Math.cos(_loc4_) + _loc9_,param2.triggerForce * 10 * param2.size * Math.sin(_loc4_) + _loc9_));
               _loc4_ += Math.PI;
               _loc3_.x *= -1;
               _loc5_++;
            }
         }
      }
   }
}

