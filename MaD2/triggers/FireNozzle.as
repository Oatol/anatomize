package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class FireNozzle extends Trigger
   {
      
      public function FireNozzle()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Vec2 = null;
         var _loc6_:userData = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:Number = NaN;
         var _loc9_:b2Vec2 = null;
         var _loc10_:b2Body = null;
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
            _loc5_.Multiply(param2.size / Physics.scale);
            _loc6_ = Properties.objTemp("water");
            _loc6_.trigger = new Water();
            _loc6_.triggered = true;
            _loc6_.projectileName = "wat";
            _loc7_ = BoxUtils.rotateVec(_loc5_,bodyAngle);
            _loc8_ = Math.random() * 10 - 5;
            _loc9_ = new b2Vec2(param2.triggerForce * param2.size * Math.cos(_loc3_) + _loc8_,param2.triggerForce * param2.size * Math.sin(_loc3_) + _loc8_);
            _loc10_ = GameState.objects.addbullet("fla",bodyCenter.x + _loc7_.x,bodyCenter.y + _loc7_.y,_loc3_,1,1,_loc9_,1,param1);
         }
      }
   }
}

