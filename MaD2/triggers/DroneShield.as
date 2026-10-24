package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DroneShield extends Drone
   {
      
      public function DroneShield()
      {
         super();
         ignoreTinyStuff = false;
      }
      
      override protected function seek() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:userData = null;
         var _loc3_:b2Body = null;
         super.seek();
         var _loc4_:int = 0;
         while(_loc4_ < seekbodies.length)
         {
            _loc1_ = b2Body(seekbodies[_loc4_]);
            if(!userData(_loc1_.GetUserData()).saveable && !userData(_loc1_.GetUserData()).hasBeenCut && !(userData(_loc1_.GetUserData()).trigger is TempProjectile))
            {
               followBody(_loc1_);
               break;
            }
            _loc4_++;
         }
      }
      
      override protected function follow() : void
      {
         var _loc1_:b2Vec2 = null;
         var _loc2_:b2Vec2 = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         super.follow();
         if(targetBody)
         {
            _loc1_ = targetBody.GetPosition();
            _loc2_ = body.GetPosition();
            _loc3_ = (_loc1_.x - _loc2_.x) * 2 + targetBody.GetLinearVelocity().x * 0.1;
            _loc4_ = (_loc1_.y - _loc2_.y) * 2 + targetBody.GetLinearVelocity().y * 0.1;
            fly(_loc3_ * 120,_loc4_ * 120);
         }
      }
      
      override protected function destroy() : Boolean
      {
         var _loc5_:userData = null;
         if(!super.destroy())
         {
            return false;
         }
         var _loc1_:b2Vec2 = targetBody.GetPosition();
         var _loc2_:b2Vec2 = body.GetPosition();
         var _loc3_:Number = _loc1_.x - _loc2_.x;
         var _loc4_:Number = _loc1_.y - _loc2_.y;
         _loc5_ = userData(targetBody.GetUserData());
         targetBody.GetLinearVelocity().Multiply(0.1);
         targetBody.SetAngularVelocity(0);
         state = "seek";
         ud.triggerDuration = ud.originalTriggerDuration;
         _loc5_.trigger = new TempProjectile(1,1);
         _loc5_.triggerLock = false;
         _loc5_.triggered = true;
         var _loc6_:String = "forcefield";
         if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
         {
            _loc6_ = ud.pfx.getParticle();
         }
         var _loc7_:int = 0;
         while(_loc7_ < 10)
         {
            GameState.particles.addParticles(targetBody.GetPosition().x * Physics.scale,targetBody.GetPosition().y * Physics.scale,1,_loc6_,bodyVel.x * 0.1,bodyVel.y * 0.1 + 1,2,2);
            _loc7_++;
         }
         return true;
      }
   }
}

