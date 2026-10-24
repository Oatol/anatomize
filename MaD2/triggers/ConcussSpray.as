package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class ConcussSpray extends Paint
   {
      
      public function ConcussSpray()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
      }
   }
}

