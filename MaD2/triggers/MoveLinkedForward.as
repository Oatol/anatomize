package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class MoveLinkedForward extends Mover
   {
      
      public function MoveLinkedForward()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         xvel = Math.cos(param1.GetAngle());
         yvel = Math.sin(param1.GetAngle());
         super.trigger(param1,param2);
      }
   }
}

