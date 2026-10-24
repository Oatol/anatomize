package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class ArmourTorso extends Armour
   {
      
      public function ArmourTorso(param1:b2Body, param2:Number, param3:int = 0, param4:Number = 0.1, param5:Number = 0.5, param6:Number = 100)
      {
         super(param1,param2,param4,param5,param6);
         bodypart = param3;
         attachTarget = "doll_body";
      }
      
      override protected function equip(param1:b2Body, param2:Boolean = false) : Boolean
      {
         return super.equip(param1,true);
      }
   }
}

