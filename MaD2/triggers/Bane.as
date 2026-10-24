package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Bane extends Trigger
   {
      
      public function Bane()
      {
         super();
      }
      
      override public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
         if(!ud || !ud.triggered)
         {
            return;
         }
         var _loc3_:userData = userData(param1.GetUserData());
         if(!_loc3_.alive)
         {
            return;
         }
         if(_loc3_.resistBlighting)
         {
            return;
         }
         Body.Blight(param1,Math.random() * 240 + 60);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
      }
   }
}

