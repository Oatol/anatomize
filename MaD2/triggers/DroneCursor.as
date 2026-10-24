package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DroneCursor extends Drone
   {
      
      public function DroneCursor()
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
               if(userData(_loc1_.GetUserData()).health != 0)
               {
                  if(_loc1_.GetMass() >= 0.1)
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
      
      override protected function destroy() : Boolean
      {
         if(!super.destroy())
         {
            return false;
         }
         var _loc1_:b2Vec2 = targetBody.GetPosition();
         var _loc2_:Number = Math.atan2(_loc1_.y - bodyCenter.y,_loc1_.x - bodyCenter.x);
         var _loc3_:b2Vec2 = GeneralUtils.pointOnCircle(bodyCenter.x,bodyCenter.y,30 / Physics.scale,Vars.toDegrees * _loc2_);
         GameState.objects.addbullet("cursor",_loc3_.x,_loc3_.y,_loc2_,1,1,new b2Vec2(4 * (_loc1_.x - _loc3_.x),4 * (_loc1_.y - _loc3_.y)),30,body);
         beginSeek();
         return true;
      }
   }
}

