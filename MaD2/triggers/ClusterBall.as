package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ClusterBall extends Trigger
   {
      
      public function ClusterBall()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         super.trigger(param1,param2);
         param2.ghost = true;
         var _loc3_:int = 0;
         while(_loc3_ < 3)
         {
            _loc4_ = GameState.objects.spawnObject("snowball",pixelCenter.x + Math.random() * 100 - 50,pixelCenter.y + Math.random() * 100 - 50,Math.random() * 360,false,true);
            _loc4_.SetLinearVelocity(param1.GetLinearVelocity());
            _loc4_.ApplyImpulse(new b2Vec2(Math.random() * 30 - 15,Math.random() * 30 - 15),_loc4_.GetPosition());
            userData(param1.GetUserData()).ignore = "snowball";
            _loc3_++;
         }
         param2.dead = true;
      }
   }
}

