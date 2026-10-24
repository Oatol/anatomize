package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2JointEdge;
   import Box2D.Dynamics.b2Body;
   
   public class DroneParasite extends Drone
   {
      
      public function DroneParasite()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         velCapX = 50;
         velCapY = 50;
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
         super.seek();
         if(targetBody)
         {
            _loc5_ = targetBody.GetPosition();
            _loc6_ = body.GetPosition();
            _loc7_ = _loc5_.x - _loc6_.x;
            _loc8_ = _loc5_.y - _loc6_.y;
            if(_loc7_ * _loc7_ + _loc8_ * _loc8_ < 60)
            {
               fly(_loc7_ * -50,_loc8_ * -50,0);
            }
            else
            {
               targetBody = null;
            }
            return;
         }
         var _loc4_:int = 0;
         while(_loc4_ < seekbodies.length)
         {
            _loc1_ = b2Body(seekbodies[_loc4_]);
            if(userData(_loc1_.GetUserData()).alive)
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
         var _loc5_:Number = Math.atan2(_loc4_,_loc3_);
         var _loc6_:Number = bodyAngle % (Math.PI * 2);
         var _loc7_:Number = _loc5_ - _loc6_;
         if(_loc7_ > 0.1)
         {
            body.ApplyTorque(9000);
         }
         else if(_loc7_ < -0.1)
         {
            body.ApplyTorque(-9000);
         }
      }
      
      override protected function destroy() : Boolean
      {
         var _loc6_:int = 0;
         var _loc7_:b2JointEdge = null;
         var _loc8_:b2Body = null;
         if(!super.destroy())
         {
            return false;
         }
         if(ud.triggerState == 1)
         {
            if(Math.random() > 0.9)
            {
               _loc6_ = 0;
               _loc7_ = body.GetJointList();
               while(_loc7_)
               {
                  if(jointUserData(_loc7_.joint.GetUserData()).name == "equip")
                  {
                     _loc6_++;
                     _loc8_ = _loc7_.joint.GetBody1();
                     if(_loc8_ == body)
                     {
                        _loc8_ = _loc7_.joint.GetBody2();
                     }
                     Body.Damage(_loc8_,Math.random() * Math.random() * 300,_loc7_.joint.GetAnchor1(),new b2Vec2(),new b2Vec2(2,2));
                     if(!_loc8_ || !userData(_loc8_.GetUserData()) || userData(_loc8_.GetUserData()).health <= 10 || userData(_loc8_.GetUserData()).dead)
                     {
                        if(_loc8_)
                        {
                           Body.Disintegrate(_loc8_,"blood");
                        }
                        ud.triggerState = 0;
                        state = "seek";
                        ud.triggerDuration = ud.originalTriggerDuration;
                        Body.Scale(body,1.05,true);
                     }
                  }
                  _loc7_ = _loc7_.next;
               }
               if(_loc6_ == 0)
               {
                  ud.triggerState = 0;
                  state = "seek";
                  ud.triggerDuration = ud.originalTriggerDuration;
               }
            }
            return false;
         }
         var _loc1_:b2Vec2 = targetBody.GetPosition();
         var _loc2_:b2Vec2 = body.GetPosition();
         var _loc3_:Number = _loc1_.x - _loc2_.x;
         var _loc4_:Number = _loc1_.y - _loc2_.y;
         var _loc5_:userData = userData(targetBody.GetUserData());
         this.rotateToTarget();
         fly(_loc3_ * 100,_loc4_ * 100,0);
         return true;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(ud.connected.indexOf(param1) != -1)
         {
            return true;
         }
         if(param3.sharp && userData(param1.GetUserData()).alive)
         {
            if(Joints.Weld("equip",body,param1,param5,0))
            {
               ud.triggerState = 1;
            }
         }
         return true;
      }
   }
}

