package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class IdentityDisc extends Trigger
   {
      
      internal var hits:int = 0;
      
      public function IdentityDisc()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:b2Vec2 = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:b2Vec2 = null;
         super.trigger(param1,param2);
         ++param2.triggerDuration;
         if(triggerDuration > 20 && Boolean(triggerPos))
         {
            _loc3_ = triggerPos;
            _loc4_ = param1.GetPosition();
            _loc5_ = _loc3_.x - _loc4_.x;
            _loc6_ = _loc3_.y - _loc4_.y;
            if(_loc5_ * _loc5_ + _loc6_ * _loc6_ < 5)
            {
               this.hits = 0;
               param2.triggerDuration = 0;
               param2.triggerLock = false;
               param2.triggered = false;
               param2.triggerLock = true;
               param2.body.m_linearDamping = 10;
            }
            else
            {
               _loc7_ = param1.GetLinearVelocity();
               param1.ApplyForce(new b2Vec2(_loc5_ * 50,_loc6_ * 50),param1.GetWorldCenter());
            }
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(this.hits > 1)
         {
            if(ud.body.m_linearDamping < 3)
            {
               ++ud.body.m_linearDamping;
            }
         }
         ++this.hits;
         return true;
      }
   }
}

