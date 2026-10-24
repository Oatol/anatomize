package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Deathbringer extends Boomerang
   {
      
      public function Deathbringer()
      {
         super();
      }
      
      override public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
         super.OnSharp(param1);
         if(!param1)
         {
            return;
         }
         var _loc3_:userData = userData(param1.GetUserData());
         if(!_loc3_)
         {
            return;
         }
         if(!_loc3_.alive)
         {
            return;
         }
         _loc3_.health = 0;
      }
   }
}

