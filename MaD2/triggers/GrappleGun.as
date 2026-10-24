package triggers
{
   import Box2D.Dynamics.Joints.b2DistanceJoint;
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   
   public class GrappleGun extends Gun
   {
      
      public var hook:b2Body;
      
      public var joint:b2DistanceJoint;
      
      public function GrappleGun(param1:Firearm)
      {
         super(param1);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
      }
   }
}

