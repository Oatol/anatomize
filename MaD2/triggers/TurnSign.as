package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class TurnSign extends Trigger
   {
      
      public function TurnSign()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Body = null;
         var _loc4_:b2Vec2 = null;
         super.trigger(param1,param2);
         for each(_loc3_ in param2.connected)
         {
            _loc4_ = _loc3_.GetLinearVelocity().Copy();
            if(param2.flipped)
            {
               _loc4_ = BoxUtils.rotateVec(_loc4_,Vars.toRadians * 90);
            }
            else
            {
               _loc4_ = BoxUtils.rotateVec(_loc4_,Vars.toRadians * -90);
            }
            _loc3_.SetLinearVelocity(_loc4_);
         }
         param2.triggered = false;
      }
   }
}

