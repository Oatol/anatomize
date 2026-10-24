package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class CameraFollowLinked extends Trigger
   {
      
      public function CameraFollowLinked()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(!param2.connected || param2.connected.length == 0 || Boolean(param2.connected[0].GetUserData().dead))
         {
            param2.triggered = false;
            return;
         }
         if(triggerState == 0)
         {
            GameState.followBody = param2.connected[0];
            param2.triggerState = 1;
         }
         else if(triggerState == 1)
         {
            if(GameState.followBody == param2.connected[0])
            {
               GameState.followBody = null;
               param2._triggered = false;
            }
         }
      }
      
      override public function onUntrigger() : void
      {
         super.onUntrigger();
         ud.triggerState = 0;
         if(ud.connected.length == 0)
         {
            return;
         }
         if(GameState.followBody == ud.connected[0])
         {
            GameState.followBody = null;
         }
      }
   }
}

