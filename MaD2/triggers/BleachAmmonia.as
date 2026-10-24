package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class BleachAmmonia extends Trigger
   {
      
      public function BleachAmmonia()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:b2Vec2 = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:String = null;
         var _loc10_:userData = null;
         var _loc11_:b2Body = null;
         super.trigger(param1,param2);
         if(Math.random() > 0.9)
         {
            _loc3_ = bodyAngle * Vars.toDegrees;
            if(_loc3_ % 360 > 60 && _loc3_ % 360 < 300 || _loc3_ % 360 > -300 && _loc3_ % 360 < -60)
            {
               _loc4_ = BoxUtils.rotateVec(new b2Vec2(param2.size * param2.triggerPos.x,param2.size * param2.triggerPos.y),bodyAngle);
               _loc5_ = BoxUtils.rotateVec(new b2Vec2(param2.size * -param2.triggerPos.x,param2.size * param2.triggerPos.y),bodyAngle);
               _loc6_ = (_loc5_.y - _loc4_.y) / (_loc5_.x - _loc4_.x);
               _loc7_ = _loc4_.x + Math.random() * (_loc5_.x - _loc4_.x);
               _loc8_ = _loc4_.y + _loc6_ * (_loc7_ - _loc4_.x);
               _loc9_ = "bleach";
               if(param2.triggerState == 1)
               {
                  _loc9_ = "ammonia";
               }
               _loc10_ = Properties.objectProperties(_loc9_ + "Bullet");
               _loc10_.trigger = new BleachAmmoniaBullet();
               _loc10_.triggered = true;
               _loc10_.triggerLock = true;
               _loc10_.triggerState = param2.triggerState;
               _loc10_.projectile = true;
               _loc10_.projectileName = _loc9_ + "Bullet";
               _loc11_ = Spawn.circle(pixelCenter.x + _loc7_,pixelCenter.y + _loc8_,4,_loc10_,[1,1,1]);
               _loc11_.SetLinearVelocity(bodyVel);
            }
         }
      }
   }
}

