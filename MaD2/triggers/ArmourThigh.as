package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class ArmourThigh extends Armour
   {
      
      public function ArmourThigh(param1:b2Body, param2:Number, param3:Number = 0.1, param4:Number = 0.5, param5:Number = 100)
      {
         super(param1,param2,param3,param4,param5);
         attachTarget = "doll_leg";
      }
   }
}

