package triggers
{
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   
   public class PortalGun extends Gun
   {
      
      public var firstPortal:b2Body;
      
      public var secondPortal:b2Body;
      
      public var which:int = 1;
      
      public function PortalGun(param1:Firearm)
      {
         super(param1);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
      }
   }
}

