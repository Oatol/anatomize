package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class GravityGrenade extends Trigger
   {
      
      public function GravityGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Body = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(triggerDuration < 0)
         {
            param2.triggered = false;
            return;
         }
         param2.triggerDuration -= TimeLord.speed;
         if(triggerDuration <= 0)
         {
            param2.dead = true;
            Body.Disintegrate(param1,"gravity",100,2,2);
            return;
         }
         var _loc3_:Number = param2.triggerRadius * param2.size;
         if((triggerDuration >> 0) % 3 == 0)
         {
            _loc6_ = 0;
            while(_loc6_ < 36)
            {
               _loc7_ = "gravity";
               if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
               {
                  _loc7_ = param2.pfx.getParticle();
               }
               _loc8_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,_loc3_ - Math.random() * Math.random() * Math.random() * _loc3_,_loc6_ * 10);
               GameState.particles.addParticles(_loc8_.x,_loc8_.y,1,_loc7_,0,0,2,2);
               _loc6_++;
            }
         }
         var _loc4_:Array = Body.GetAround(param1,_loc3_,_loc3_,false);
         _loc4_.push(param1);
         for each(_loc5_ in _loc4_)
         {
            _loc5_.WakeUp();
            _loc5_.ApplyForce(new b2Vec2(-Vars.wind * _loc5_.GetMass() * -triggerForce * param2.size,-Vars.gravity * _loc5_.GetMass() * -triggerForce * param2.size),_loc5_.GetWorldCenter());
         }
      }
   }
}

