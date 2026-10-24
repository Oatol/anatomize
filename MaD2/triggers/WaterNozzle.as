package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class WaterNozzle extends Trigger
   {
      
      public function WaterNozzle()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         if(ud.triggerForce == 4)
         {
            ud.triggerForce = 40;
         }
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Vec2 = null;
         var _loc6_:userData = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Body = null;
         var _loc9_:Number = NaN;
         super.trigger(param1,param2);
         var _loc3_:Number = bodyAngle;
         var _loc4_:b2Vec2 = new b2Vec2(Math.sin(_loc3_) * triggerForce * -10,-Math.cos(_loc3_) * triggerForce * -10);
         param1.ApplyForce(_loc4_,bodyCenter);
         _loc3_ -= Vars.PI * 0.5;
         if(Math.random() > 0.5)
         {
            if(TimeLord.speed < 1 && Math.random() * TimeLord.speed > TimeLord.speed * 0.1)
            {
               return;
            }
            _loc5_ = param2.triggerPos.Copy();
            _loc5_.Multiply(param2.size);
            _loc6_ = Properties.objTemp("water");
            _loc6_.trigger = new Water();
            _loc6_.triggered = true;
            _loc6_.projectileName = "wat";
            _loc7_ = BoxUtils.rotateVec(_loc5_,bodyAngle);
            _loc8_ = Spawn.circle(pixelCenter.x + _loc7_.x,pixelCenter.y + _loc7_.y,2 * param2.size,_loc6_,[10,1,0]);
            _loc9_ = Math.random() * 10 - 5;
            _loc8_.SetLinearVelocity(new b2Vec2(param2.triggerForce * param2.size * Math.cos(_loc3_) + _loc9_,param2.triggerForce * param2.size * Math.sin(_loc3_) + _loc9_));
         }
      }
   }
}

