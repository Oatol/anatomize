package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class TimeKeeper extends Trigger
   {
      
      public function TimeKeeper()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
      }
      
      override public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
         super.OnSharp(param1);
         if(!ud.triggered)
         {
            return;
         }
         if(!userData(param1.GetUserData()).alive)
         {
            return;
         }
         if(!GameState.slomo)
         {
            TimeLord.slowTo(10);
         }
      }
   }
}

