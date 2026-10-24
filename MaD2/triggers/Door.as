package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Door extends Trigger
   {
      
      public function Door()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(param2.group < 999)
         {
            param2.group += 1000;
            _loc3_ = param1.GetPosition().Copy();
            param1.SetXForm(new b2Vec2(-10,-10),0);
            param1.SetXForm(_loc3_,bodyAngle);
            if(param2.graphic.alpha == 1)
            {
               param2.graphic.alpha = 0.2;
            }
         }
         else
         {
            param2.group -= 1000;
            if(param2.graphic.alpha != 0)
            {
               param2.graphic.alpha = 1;
            }
         }
         param2.triggered = false;
      }
   }
}

