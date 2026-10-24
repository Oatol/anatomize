package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Fountain extends Trigger
   {
      
      public function Fountain()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:Number = NaN;
         var _loc5_:userData = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Body = null;
         var _loc8_:Number = NaN;
         super.trigger(param1,param2);
         if(Math.random() > 0.5)
         {
            if(TimeLord.speed < 1 && Math.random() * TimeLord.speed > TimeLord.speed * 0.1)
            {
               return;
            }
            _loc3_ = param2.triggerPos.Copy();
            _loc3_.Multiply(param2.size);
            _loc4_ = bodyAngle + Math.PI * 0.25;
            _loc4_ = bodyAngle + Math.random() * Math.PI - Math.PI;
            _loc5_ = Properties.objTemp("water");
            _loc5_.trigger = new Water();
            _loc5_.triggered = true;
            _loc5_.projectileName = "wat";
            _loc6_ = BoxUtils.rotateVec(_loc3_,bodyAngle);
            _loc7_ = Spawn.circle(pixelCenter.x + _loc6_.x,pixelCenter.y + _loc6_.y,2 * param2.size,_loc5_,[1,1,0]);
            _loc8_ = Math.random() * 4 - 2;
            _loc7_.SetLinearVelocity(new b2Vec2(Math.random() * param2.triggerForce * param2.size * Math.cos(_loc4_) + _loc8_,Math.random() * param2.triggerForce * param2.size * Math.sin(_loc4_) + _loc8_));
         }
      }
   }
}

