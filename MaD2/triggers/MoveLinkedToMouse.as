package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class MoveLinkedToMouse extends Trigger
   {
      
      public function MoveLinkedToMouse()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc7_:b2Body = null;
         var _loc8_:b2Vec2 = null;
         super.trigger(param1,param2);
         var _loc5_:Number = Main.instance.mouseXWorld;
         var _loc6_:Number = Main.instance.mouseYWorld;
         for each(_loc7_ in param2.connected)
         {
            _loc8_ = _loc7_.GetWorldCenter();
            _loc3_ = _loc5_ - _loc8_.x;
            _loc4_ = _loc6_ - _loc8_.y;
            _loc7_.ApplyForce(new b2Vec2(_loc3_ * triggerForce,_loc4_ * triggerForce),_loc8_);
            _loc7_.GetLinearVelocity().Multiply(Number(param2.triggerCustom));
            _loc7_.WakeUp();
         }
      }
   }
}

