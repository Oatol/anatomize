package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ScareDrone extends Trigger
   {
      
      public function ScareDrone()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:userData = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(body,triggerRadius,triggerRadius);
         for each(_loc7_ in _loc3_)
         {
            _loc4_ = userData(_loc7_.GetUserData());
            if(_loc4_.trigger is Drone)
            {
               _loc5_ = _loc7_.GetWorldCenter();
               _loc6_ = bodyCenter.Copy();
               _loc6_.Subtract(_loc5_);
               _loc6_.Multiply(triggerForce * _loc7_.GetMass() * -0.1);
               _loc7_.ApplyForce(_loc6_,_loc5_);
            }
         }
      }
   }
}

