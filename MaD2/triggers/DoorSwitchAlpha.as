package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class DoorSwitchAlpha extends DoorSwitch
   {
      
      public function DoorSwitchAlpha()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         ud.triggerState = 1;
      }
   }
}

