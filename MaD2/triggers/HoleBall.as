package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class HoleBall extends SnowBall
   {
      
      public function HoleBall()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Body = null;
         super.trigger(param1,param2);
         ud.triggerDuration -= TimeLord.speed;
         if(ud.triggerDuration <= 0)
         {
            ud.triggerDuration = 12 + Math.random() * ud.originalTriggerDuration;
            _loc3_ = GameState.objects.spawnObject("snowball",pixelCenter.x,pixelCenter.y,0,false,true);
            _loc3_.SetLinearVelocity(body.GetLinearVelocity());
            _loc3_.ApplyImpulse(new b2Vec2(Math.random() * 30 - 15,Math.random() * 30 - 15),_loc3_.GetPosition());
         }
      }
   }
}

