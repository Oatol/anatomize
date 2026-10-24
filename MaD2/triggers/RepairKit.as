package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class RepairKit extends RegenKit
   {
      
      public function RepairKit()
      {
         super();
      }
      
      override protected function filter(param1:b2Body) : Boolean
      {
         var _loc2_:userData = userData(param1.GetUserData());
         if(param1.IsStatic())
         {
            return false;
         }
         if(_loc2_.alive)
         {
            return false;
         }
         return true;
      }
   }
}

