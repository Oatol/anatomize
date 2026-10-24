package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ShootingTarget extends Trigger
   {
      
      internal var col:uint;
      
      public function ShootingTarget()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(ud.triggerDuration > 0)
         {
            ud.triggerDuration -= TimeLord.speed;
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc8_:b2Body = null;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(ud.triggerDuration > 0)
         {
            return false;
         }
         if(param3.name == "ededed")
         {
            ParticleSystem(GameState.particles.systems[156]).graphic = R.getSprite("p_haha");
            GameState.particles.addParticles(param5.x * Physics.scale,param5.y * Physics.scale,1,"score",0,0,5,5);
            return false;
         }
         var _loc7_:String = "100";
         if(param3.name == "84e00d")
         {
            _loc7_ = "100";
            for each(_loc8_ in ud.connected)
            {
               userData(_loc8_.GetUserData()).triggered = true;
            }
         }
         else if(param3.name == "cfb613")
         {
            _loc7_ = "50";
         }
         else if(param3.name == "bf2f2f")
         {
            _loc7_ = "25";
         }
         ParticleSystem(GameState.particles.systems[156]).graphic = R.getSprite("p_" + _loc7_);
         GameState.particles.addParticles(param5.x * Physics.scale,param5.y * Physics.scale,1,"score",0,0,5,5);
         ud.triggerDuration = Math.max(ud.originalTriggerDuration,2);
         return true;
      }
   }
}

