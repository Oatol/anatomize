package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Arrow extends Trigger
   {
      
      public function Arrow()
      {
         super();
      }
      
      override public function OnStick(param1:b2Body) : void
      {
         super.OnStick(param1);
         ud.ignore = "arrowproj";
      }
   }
}

