package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DroneJanitor extends Drone
   {
      
      public function DroneJanitor()
      {
         super();
         ignoreTinyStuff = false;
      }
      
      override protected function seek() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:userData = null;
         var _loc3_:b2Body = null;
         super.seek();
         body.ApplyTorque(-bodyAngle * 1000);
         var _loc4_:int = 0;
         while(_loc4_ < seekbodies.length)
         {
            _loc1_ = b2Body(seekbodies[_loc4_]);
            if(!userData(_loc1_.GetUserData()).saveable && userData(_loc1_.GetUserData()).hasBeenCut && !(userData(_loc1_.GetUserData()).trigger is TempProjectile))
            {
               followBody(_loc1_);
               break;
            }
            _loc4_++;
         }
      }
      
      override protected function follow() : void
      {
         var _loc1_:b2Vec2 = null;
         var _loc2_:b2Vec2 = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         super.follow();
         if(targetBody)
         {
            _loc1_ = targetBody.GetPosition();
            _loc2_ = body.GetPosition();
            _loc3_ = (_loc1_.x - _loc2_.x) * 2 + targetBody.GetLinearVelocity().x * 0.1;
            _loc4_ = (_loc1_.y - _loc2_.y) * 2 + targetBody.GetLinearVelocity().y * 0.1;
            if(_loc3_ * _loc3_ + _loc4_ * _loc4_ > 100)
            {
               fly(_loc3_ * 20,_loc4_ * 20,0);
            }
            else
            {
               fly(-_loc3_ * 4,-_loc4_ * 4);
            }
            body.ApplyTorque(-bodyAngle * 1000);
         }
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
         body.ApplyTorque(-bodyAngle * 1000 + (Math.random() > 0.5 ? -1000 : 1000));
         fly(_loc3_ * 4,_loc4_ * 4);
         return true;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc7_:userData = null;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(userData(param1.GetUserData()).saveable || !userData(param1.GetUserData()).hasBeenCut || userData(param1.GetUserData()).trigger is TempProjectile)
         {
            return false;
         }
         _loc7_ = userData(param1.GetUserData());
         param1.GetLinearVelocity().Multiply(0.1);
         param1.SetAngularVelocity(0);
         state = "seek";
         ud.triggerDuration = ud.originalTriggerDuration;
         _loc7_.trigger = new DisintegratePowder(100,2,true);
         _loc7_.triggerLock = false;
         _loc7_.triggered = true;
         return true;
      }
   }
}

