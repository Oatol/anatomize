package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class DroneBee extends Drone
   {
      
      public function DroneBee()
      {
         super();
      }
      
      override protected function seek() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:userData = null;
         var _loc3_:b2Body = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(Math.random() > 0.95)
         {
            seekX = Math.random() * 240 - 120;
            seekY = Math.random() * 40 - 20;
         }
         body.WakeUp();
         fly(seekX,seekY - Vars.gravity,seekSpin);
         this.rotateToVelocity();
         if(targetBody)
         {
            _loc5_ = targetBody.GetPosition();
            _loc6_ = body.GetPosition();
            _loc7_ = _loc5_.x - _loc6_.x;
            _loc8_ = _loc5_.y - _loc6_.y;
            if(_loc7_ * _loc7_ + _loc8_ * _loc8_ < 30)
            {
               fly(_loc7_ * -50,_loc8_ * -50,0);
            }
            else
            {
               targetBody = null;
            }
            return;
         }
         seekbodies = Body.GetAround(body,ud.triggerRadius * ud.size,ud.triggerRadius * ud.size,false);
         var _loc4_:int = 0;
         while(_loc4_ < seekbodies.length)
         {
            _loc1_ = b2Body(seekbodies[_loc4_]);
            if(!(!userData(_loc1_.GetUserData()).alive || allowDroneTargeting))
            {
               if(Math.random() > 0.8)
               {
                  followBody(_loc1_);
                  break;
               }
            }
            _loc4_++;
         }
      }
      
      override protected function follow() : void
      {
         super.follow();
         if(!targetBody)
         {
            return;
         }
         this.rotateToTarget();
      }
      
      private function rotateToTarget() : void
      {
         var _loc1_:b2Vec2 = targetBody.GetPosition();
         var _loc2_:b2Vec2 = body.GetPosition();
         var _loc3_:Number = _loc1_.x - _loc2_.x;
         var _loc4_:Number = _loc1_.y - _loc2_.y;
         var _loc5_:Number = Math.atan2(_loc4_,_loc3_) - Math.PI * 0.5;
         var _loc6_:Number = bodyAngle % (Math.PI * 2);
         var _loc7_:Number = _loc5_ - _loc6_;
         if(_loc7_ > 0.1)
         {
            body.ApplyTorque(100);
         }
         else if(_loc7_ < -0.1)
         {
            body.ApplyTorque(-100);
         }
      }
      
      private function rotateToVelocity() : void
      {
         var _loc1_:Number = body.GetLinearVelocity().x;
         var _loc2_:Number = body.GetLinearVelocity().y;
         var _loc3_:Number = Math.atan2(_loc2_,_loc1_) + Math.PI * 0.5;
         var _loc4_:Number = bodyAngle % (Math.PI * 2);
         var _loc5_:Number = _loc3_ - _loc4_;
         if(Math.random() > 0.95)
         {
            body.SetAngularVelocity(body.GetAngularVelocity() * 1.6);
         }
         else
         {
            body.SetAngularVelocity(body.GetAngularVelocity() * 0.8);
         }
         if(_loc5_ > 0.1)
         {
            body.ApplyTorque(50);
         }
         else if(_loc5_ < -0.1)
         {
            body.ApplyTorque(-50);
         }
      }
      
      override protected function destroy() : Boolean
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:b2Vec2 = null;
         if(!super.destroy())
         {
            return false;
         }
         var _loc1_:b2Vec2 = targetBody.GetPosition();
         var _loc2_:b2Vec2 = body.GetPosition();
         var _loc3_:Number = _loc1_.x - _loc2_.x;
         var _loc4_:Number = _loc1_.y - _loc2_.y;
         var _loc5_:userData = userData(targetBody.GetUserData());
         if(triggerState == 0)
         {
            this.rotateToTarget();
            if(Math.random() > 0.9)
            {
               ud.triggerState = 1;
            }
            else if(Math.random() > 0.9)
            {
               ud.triggerState = 3;
            }
         }
         else if(triggerState == 1)
         {
            _loc6_ = Math.atan2(_loc4_,_loc3_) - Math.PI * 0.5;
            _loc7_ = bodyAngle % (Math.PI * 2);
            _loc8_ = _loc6_ - _loc7_;
            if(_loc8_ > 0.1)
            {
               body.ApplyTorque(50);
            }
            else if(_loc8_ < -0.1)
            {
               body.ApplyTorque(-50);
            }
            if(Math.random() > 0.95)
            {
               ud.triggerState = 2;
            }
         }
         else if(triggerState == 2)
         {
            _loc9_ = BoxUtils.rotateVec(new b2Vec2(0,-20 / Physics.scale),bodyAngle);
            _loc9_.Add(bodyCenter);
            body.ApplyForce(new b2Vec2(_loc3_ * 500,_loc4_ * 500),_loc9_);
         }
         else if(triggerState == 3)
         {
            this.rotateToTarget();
            fly(-_loc3_ * 25,-_loc4_ * 25,0);
            if(Math.random() > 0.9)
            {
               ud.triggerState = 4;
            }
         }
         else if(triggerState == 4)
         {
            fly(_loc3_ * 500,_loc4_ * 500,0);
            if(Math.random() > 0.95)
            {
               ud.triggerState = 5;
            }
         }
         if(triggerState == 5)
         {
            ud.triggerState = 0;
            state = "seek";
            ud.triggerDuration = ud.originalTriggerDuration;
         }
         return true;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         state = "seek";
         ud.triggerState = 0;
         seekX = Math.random() * 240 - 120;
         seekY = Math.random() * 40 - 20;
         return true;
      }
      
      override public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
         super.OnSharp(param1);
         this.sting(param1,param1.GetPosition(),Math.random() * 5 + 1);
         if(triggerState == 2)
         {
            ud.triggerState = 5;
         }
      }
      
      public function sting(param1:b2Body, param2:b2Vec2, param3:Number = 1) : *
      {
         var _loc6_:Sprite = null;
         var _loc7_:b2Vec2 = null;
         var _loc4_:userData = userData(param1.GetUserData());
         if(!_loc4_ || !_loc4_.alive)
         {
            return;
         }
         Body.Damage(param1,Math.random() * 76 + 24,null,null,null,false);
         var _loc5_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(_loc5_)
         {
            _loc6_ = new Sprite();
            _loc6_.graphics.lineStyle(0,0,0);
            _loc7_ = param1.GetLocalPoint(param2).Copy();
            _loc7_.Multiply(Physics.scale);
            _loc7_.x -= Bitmap(_loc4_.graphic.getChildByName("effects")).x;
            _loc7_.y -= Bitmap(_loc4_.graphic.getChildByName("effects")).y;
            _loc6_.graphics.beginFill(_loc4_.bloodColour,Math.random());
            _loc6_.graphics.drawCircle(_loc7_.x + Math.random() * 20 - 10,_loc7_.y + Math.random() * 20 - 10,param3);
            _loc6_.graphics.endFill();
            _loc5_.draw(_loc6_);
         }
      }
   }
}

