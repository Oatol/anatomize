package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Decoy extends Balloon
   {
      
      public function Decoy()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(param2.bleeding.length > 0)
         {
            param2.bleeding = [];
         }
      }
      
      override public function OnCut() : Boolean
      {
         ud.health -= 200;
         if(ud.health <= 10)
         {
            ud.trigger = new Disintegrate("air",100,5);
            ud.triggered = true;
            ud.alive = false;
            return true;
         }
         return false;
      }
   }
}

