package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Mover extends Trigger
   {
      
      protected var xvel:Number = 0;
      
      protected var yvel:Number = 0;
      
      public function Mover()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Body = null;
         super.trigger(param1,param2);
         for each(_loc3_ in param2.connected)
         {
            _loc3_.WakeUp();
            _loc3_.ApplyForce(new b2Vec2(this.xvel * triggerForce,this.yvel * triggerForce),_loc3_.GetWorldCenter());
            _loc3_.WakeUp();
         }
      }
   }
}

