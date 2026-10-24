package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class RocketBall extends Firework
   {
      
      public function RocketBall()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Body = null;
         super.trigger(param1,param2);
         if(param2.dead)
         {
            param2.ghost = true;
            _loc3_ = GameState.objects.spawnObject("snowball",pixelCenter.x,pixelCenter.y,0,false,true);
            _loc3_.SetLinearVelocity(param1.GetLinearVelocity());
         }
      }
   }
}

