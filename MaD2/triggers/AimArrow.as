package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class AimArrow extends Drone
   {
      
      public function AimArrow()
      {
         super();
         seekSpin = 500;
         followSpin = 500;
         velCapX = 100;
         velCapY = 100;
      }
      
      public function SetVelCap(param1:Number, param2:Number) : *
      {
         velCapX = param1;
         velCapY = param2;
      }
      
      override protected function seek() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:userData = null;
         super.seek();
         var _loc3_:int = 0;
         while(_loc3_ < seekbodies.length)
         {
            _loc1_ = b2Body(seekbodies[_loc3_]);
            if(userData(_loc1_.GetUserData()).name != "theripper")
            {
               if(userData(_loc1_.GetUserData()).name != "guidance")
               {
                  if(userData(_loc1_.GetUserData()).name != "aimarrow")
                  {
                     if(Math.random() > 0.98)
                     {
                        followBody(_loc1_);
                        if(targetBody)
                        {
                           body.SetLinearVelocity(new b2Vec2());
                        }
                        break;
                     }
                  }
               }
            }
            _loc3_++;
         }
      }
      
      override protected function follow() : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:b2Vec2 = null;
         if(!targetBody || userData(targetBody.GetUserData()).dead || ud.triggerDuration > 180)
         {
            beginSeek();
            return;
         }
         var _loc1_:b2Vec2 = targetBody.GetPosition();
         var _loc2_:b2Vec2 = body.GetPosition();
         _loc3_ = (_loc1_.x - _loc2_.x) * 100;
         _loc4_ = (_loc1_.y - _loc2_.y) * 100;
         _loc5_ = bodyCenter;
         var _loc6_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(ud.flipped ? -1 : 1,0),bodyAngle);
         _loc5_.x += _loc6_.x;
         _loc5_.y += _loc6_.y;
         body.ApplyForce(new b2Vec2(_loc3_ * body.GetMass(),_loc4_ * body.GetMass()),_loc5_);
         ud.triggerDuration += TimeLord.speed;
      }
      
      override protected function destroy() : Boolean
      {
         if(!super.destroy())
         {
            return false;
         }
         beginSeek();
         return true;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(Boolean(_loc7_.trigger) && _loc7_.trigger is AimArrow)
         {
            return false;
         }
         ud.trigger = new TempProjectile(20);
         ud.triggered = true;
         return true;
      }
   }
}

