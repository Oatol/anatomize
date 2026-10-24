package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class CloudHat extends ArmourHelmet
   {
      
      public function CloudHat(param1:b2Body, param2:Number, param3:Number = 0.1, param4:Number = 0.5, param5:Number = 100)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:b2Vec2 = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         super.trigger(param1,param2);
         ud.triggered = true;
         if(Math.random() > 0.95)
         {
            updateTriggerHelpers();
            _loc3_ = bodyAngle * Vars.toDegrees;
            _loc4_ = BoxUtils.rotateVec(new b2Vec2(ud.size * 16 / Physics.scale,ud.size * 16 / Physics.scale),bodyAngle);
            _loc5_ = BoxUtils.rotateVec(new b2Vec2(ud.size * -16 / Physics.scale,ud.size * 16 / Physics.scale),bodyAngle);
            _loc6_ = (_loc5_.y - _loc4_.y) / (_loc5_.x - _loc4_.x);
            _loc7_ = _loc4_.x + Math.random() * (_loc5_.x - _loc4_.x);
            _loc8_ = _loc4_.y + _loc6_ * (_loc7_ - _loc4_.x);
            GameState.objects.addbullet("wat",bodyCenter.x + _loc7_,bodyCenter.y + _loc8_,0,1,0.1,bodyVel.Copy(),0,body);
         }
      }
   }
}

