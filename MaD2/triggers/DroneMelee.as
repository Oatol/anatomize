package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DroneMelee extends Drone
   {
      
      public function DroneMelee()
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
         fly(_loc3_ * 250,_loc4_ * 250,1000);
         if(Math.random() > 0.9)
         {
            state = "seek";
            ud.triggerDuration = ud.originalTriggerDuration;
         }
         return true;
      }
   }
}

