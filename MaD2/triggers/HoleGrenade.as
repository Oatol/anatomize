package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class HoleGrenade extends Trigger
   {
      
      public function HoleGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc7_:userData = null;
         var _loc8_:b2Body = null;
         var _loc9_:ParticleSystem = null;
         var _loc10_:b2Vec2 = null;
         super.trigger(param1,param2);
         param2.triggerLock = true;
         if(!param2.triggerRadius)
         {
            param2.triggerRadius = 5;
            param1.m_linearDamping = 9000;
            param2.ghost = true;
            param2.triggerLock = false;
            param2.triggered = true;
            param2.saveable = false;
            param2.triggerLock = true;
         }
         var _loc3_:String = "darkness";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc3_ = param2.pfx.getParticle();
         }
         var _loc4_:int = param2.triggerRadius;
         if(_loc4_ > 20)
         {
            _loc4_ = 20;
         }
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc10_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,param2.triggerRadius + 12,Math.random() * 360);
            GameState.particles.addParticles(_loc10_.x,_loc10_.y,1,_loc3_,0,0,0,0);
            _loc5_++;
         }
         var _loc6_:* = Body.GetAround(param1,param2.triggerRadius,param2.triggerRadius);
         for each(_loc8_ in _loc6_)
         {
            _loc7_ = userData(_loc8_.GetUserData());
            _loc7_.dead = true;
         }
         if(param2.triggerState == -1)
         {
            param2.triggerRadius *= 0.9;
            --param2.triggerRadius;
         }
         else
         {
            param2.triggerRadius *= 1.01;
         }
         if(param2.triggerRadius > 1000)
         {
            param2.triggerState = -1;
         }
         else if(param2.triggerRadius <= 1)
         {
            param2.dead = true;
         }
         param2.graphic.graphics.clear();
         param2.graphic.graphics.beginFill(0);
         param2.graphic.graphics.drawCircle(0,0,param2.triggerRadius + 10);
         for each(_loc9_ in GameState.environment.public::particleSystems)
         {
            _loc9_.clear();
         }
         GameState.particles.systems[0].clear();
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param1.IsStatic())
         {
            return false;
         }
         if(ud.triggered)
         {
            return false;
         }
         body.m_linearDamping = 9000;
         ud.ghost = true;
         ud.triggerLock = false;
         ud.triggered = true;
         ud.saveable = false;
         ud.triggerLock = true;
         ud.triggerRadius = 5;
         return true;
      }
      
      override public function OnDelete() : void
      {
         super.OnDelete();
      }
   }
}

