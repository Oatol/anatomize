package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class RawChicken extends Trigger
   {
      
      public function RawChicken()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:int = 0;
         super.trigger(param1,param2);
         if(ud.temperature > 150)
         {
            ud.trigger = new Transmute("chicken");
            _loc3_ = 0;
            while(_loc3_ < 50)
            {
               BoxUtils.randomParticlesOnBody(body,"fried",2);
               _loc3_++;
            }
         }
      }
   }
}

