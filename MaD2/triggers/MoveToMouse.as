package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class MoveToMouse extends Trigger
   {
      
      public function MoveToMouse()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         var _loc3_:Number = Main.instance.mouseXWorld - bodyCenter.x;
         var _loc4_:Number = Main.instance.mouseYWorld - bodyCenter.y;
         param1.ApplyForce(new b2Vec2(_loc3_ * triggerForce,_loc4_ * triggerForce),bodyCenter);
         param1.GetLinearVelocity().Multiply(Number(param2.triggerCustom));
         param1.WakeUp();
      }
   }
}

