package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class ArmourBoot extends Armour
   {
      
      public function ArmourBoot(param1:b2Body, param2:Number, param3:Number = 0.1, param4:Number = 0.5, param5:Number = 1)
      {
         super(param1,param2,param3,param4,param5);
         attachTarget = "doll_foot";
         ud = userData(param1.GetUserData());
      }
      
      override protected function Attach(param1:b2Body) : Boolean
      {
         return super.Attach(param1);
      }
      
      override public function OnJoint(param1:b2Body, param2:String) : Boolean
      {
         if(param2 == "weldjoint")
         {
            ud.ignore = "!projectiles";
         }
         return super.OnJoint(param1,param2);
      }
   }
}

