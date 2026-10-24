package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DroneHammer extends Drone
   {
      
      public function DroneHammer()
      {
         super();
      }
      
      override protected function seek() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:userData = null;
         var _loc3_:b2Body = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         super.seek();
         if(targetBody)
         {
            _loc5_ = targetBody.GetPosition();
            _loc6_ = body.GetPosition();
            _loc7_ = _loc5_.x - _loc6_.x;
            _loc8_ = _loc5_.y - _loc6_.y;
            if(_loc7_ * _loc7_ + _loc8_ * _loc8_ < 90)
            {
               fly(_loc7_ * -100,_loc8_ * -100,0);
            }
            else
            {
               targetBody = null;
            }
            return;
         }
         var _loc4_:int = 0;
         while(_loc4_ < seekbodies.length)
         {
            _loc1_ = b2Body(seekbodies[_loc4_]);
            if(Math.random() > 0.8)
            {
               followBody(_loc1_);
               break;
            }
            _loc4_++;
         }
         body.SetAngularVelocity(body.GetAngularVelocity() * 0.95);
      }
      
      override protected function follow() : void
      {
         super.follow();
         var _loc1_:Number = 600;
         if(body.GetLinearVelocity().x < 0)
         {
            _loc1_ = -600;
         }
         body.ApplyTorque(_loc1_ * body.GetMass());
         body.SetAngularVelocity(body.GetAngularVelocity() * 0.99);
      }
      
      override protected function destroy() : Boolean
      {
         if(!super.destroy())
         {
            return false;
         }
         var _loc1_:b2Vec2 = targetBody.GetPosition();
         var _loc2_:b2Vec2 = body.GetPosition();
         var _loc3_:Number = _loc1_.x - _loc2_.x;
         var _loc4_:Number = _loc1_.y - _loc2_.y;
         var _loc5_:userData = userData(targetBody.GetUserData());
         fly(_loc3_ * 200,_loc4_ * 200,10000);
         return true;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(Math.random() > 0.9)
         {
            state = "seek";
            ud.triggerDuration = ud.originalTriggerDuration;
         }
         return true;
      }
   }
}

