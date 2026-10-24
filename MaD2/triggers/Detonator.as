package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Detonator extends Trigger
   {
      
      public function Detonator()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:userData = null;
         super.trigger(param1,param2);
         var _loc4_:b2Body = Physics.world.GetBodyList();
         while(_loc4_)
         {
            _loc3_ = userData(_loc4_.GetUserData());
            if(Boolean(_loc3_) && Boolean(_loc3_.trigger))
            {
               _loc3_.triggered = !_loc3_.triggered;
            }
            _loc4_ = _loc4_.GetNext();
         }
         param2.triggered = false;
      }
   }
}

