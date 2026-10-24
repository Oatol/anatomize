package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Candelabrum extends Torch
   {
      
      public function Candelabrum()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         param2.triggerPos.x += 15;
         if(param2.triggerPos.x > 15)
         {
            param2.triggerPos.x = -15;
         }
         super.trigger(param1,param2);
      }
   }
}

