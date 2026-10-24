package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class SantaBall extends SnowBall
   {
      
      public function SantaBall()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:b2Body = null;
         super.trigger(param1,param2);
         ud.triggerDuration -= TimeLord.speed;
         if(ud.triggerDuration <= 0)
         {
            ud.triggerDuration = ud.originalTriggerDuration;
            _loc3_ = Vars.objSize;
            Vars.objSize = 0.5 * ud.size;
            _loc4_ = GameState.objects.spawnObject("present",pixelCenter.x,pixelCenter.y,0,false,true);
            _loc4_.SetLinearVelocity(body.GetLinearVelocity());
            _loc4_.ApplyImpulse(new b2Vec2(Math.random() * 30 - 15,Math.random() * 30 - 15),_loc4_.GetPosition());
            Vars.objSize = _loc3_;
         }
      }
   }
}

