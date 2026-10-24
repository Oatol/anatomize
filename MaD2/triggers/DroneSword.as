package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DroneSword extends Drone
   {
      
      public function DroneSword()
      {
         super();
         allowDroneTargeting = true;
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
            if(_loc7_ * _loc7_ + _loc8_ * _loc8_ < 60)
            {
               fly(_loc7_ * -50,_loc8_ * -50,0);
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
      }
      
      override protected function follow() : void
      {
         super.follow();
         if(!targetBody)
         {
            return;
         }
         this.rotateToTarget();
      }
      
      private function rotateToTarget() : void
      {
         var _loc1_:b2Vec2 = targetBody.GetPosition();
         var _loc2_:b2Vec2 = body.GetPosition();
         var _loc3_:Number = _loc1_.x - _loc2_.x;
         var _loc4_:Number = _loc1_.y - _loc2_.y;
         var _loc5_:Number = Math.atan2(_loc4_,_loc3_) + Math.PI * 0.5;
         var _loc6_:Number = bodyAngle % (Math.PI * 2);
         var _loc7_:Number = _loc5_ - _loc6_;
         if(_loc7_ > 0.1)
         {
            body.ApplyTorque(1000);
         }
         else if(_loc7_ < -0.1)
         {
            body.ApplyTorque(-1000);
         }
      }
      
      override protected function destroy() : Boolean
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:b2Vec2 = null;
         if(!super.destroy())
         {
            return false;
         }
         var _loc1_:b2Vec2 = targetBody.GetPosition();
         var _loc2_:b2Vec2 = body.GetPosition();
         var _loc3_:Number = _loc1_.x - _loc2_.x;
         var _loc4_:Number = _loc1_.y - _loc2_.y;
         var _loc5_:userData = userData(targetBody.GetUserData());
         if(triggerState == 0)
         {
            this.rotateToTarget();
            if(Math.random() > 0.9)
            {
               ud.triggerState = 1;
            }
            else if(Math.random() > 0.9)
            {
               ud.triggerState = 3;
            }
         }
         else if(triggerState == 1)
         {
            _loc6_ = Math.atan2(_loc4_,_loc3_) - Math.PI * 0.5;
            _loc7_ = bodyAngle % (Math.PI * 2);
            _loc8_ = _loc6_ - _loc7_;
            if(_loc8_ > 0.1)
            {
               body.ApplyTorque(2000);
            }
            else if(_loc8_ < -0.1)
            {
               body.ApplyTorque(-2000);
            }
            if(Math.random() > 0.9)
            {
               ud.triggerState = 2;
            }
         }
         else if(triggerState == 2)
         {
            _loc9_ = BoxUtils.rotateVec(new b2Vec2(0,-60 / Physics.scale),bodyAngle);
            _loc9_.Add(bodyCenter);
            body.ApplyForce(new b2Vec2(_loc3_ * 1000,_loc4_ * 1000),_loc9_);
         }
         else if(triggerState == 3)
         {
            this.rotateToTarget();
            fly(-_loc3_ * 25,-_loc4_ * 25,0);
            if(Math.random() > 0.9)
            {
               ud.triggerState = 4;
            }
         }
         else if(triggerState == 4)
         {
            fly(_loc3_ * 250,_loc4_ * 250,0);
            if(Math.random() > 0.9)
            {
               ud.triggerState = 5;
            }
         }
         if(triggerState == 5)
         {
            ud.triggerState = 0;
            state = "seek";
            ud.triggerDuration = ud.originalTriggerDuration;
         }
         return true;
      }
      
      override public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
         super.OnSharp(param1);
         if(triggerState == 2)
         {
            ud.triggerState = 5;
         }
      }
   }
}

