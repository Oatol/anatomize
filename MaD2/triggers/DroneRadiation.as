package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class DroneRadiation extends Drone
   {
      
      internal var busy:Boolean = false;
      
      public function DroneRadiation()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
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
               if(userData(_loc1_.GetUserData()).alive)
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
      
      override protected function follow() : void
      {
         super.follow();
      }
      
      override protected function destroy() : Boolean
      {
         if(!super.destroy())
         {
            return false;
         }
         fly(0,0,(Math.random() * 500 - 250) * body.GetMass());
         Body.Radioactive(body,ud.triggerRadius);
         if(Math.random() > 0.95)
         {
            beginSeek();
         }
         return true;
      }
   }
}

