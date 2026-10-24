package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DroneScaredy extends Drone
   {
      
      public function DroneScaredy()
      {
         super();
      }
      
      override protected function seek() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:userData = null;
         super.seek();
         var _loc3_:int = 0;
         while(_loc3_ < seekbodies.length)
         {
            _loc1_ = b2Body(seekbodies[_loc3_]);
            if(userData(_loc1_.GetUserData()).saveable != false)
            {
               if(!userData(_loc1_.GetUserData()).hasBeenCut)
               {
                  if(userData(_loc1_.GetUserData()).health != 0)
                  {
                     if(Math.random() > 0.8)
                     {
                        followBody(_loc1_);
                        break;
                     }
                  }
               }
            }
            _loc3_++;
         }
      }
      
      override protected function follow() : void
      {
         super.follow();
         state = "destroy";
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
         fly(_loc3_ * -ud.triggerForce,_loc4_ * -ud.triggerForce,0);
         if(Math.random() > 0.9)
         {
            beginSeek();
         }
         return true;
      }
   }
}

