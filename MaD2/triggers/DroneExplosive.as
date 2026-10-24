package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DroneExplosive extends Drone
   {
      
      public function DroneExplosive()
      {
         super();
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
            if(_loc1_ != body)
            {
               if(Math.random() > 0.8)
               {
                  followBody(_loc1_);
                  ud.triggerDuration = ud.originalTriggerDuration;
                  break;
               }
            }
            _loc3_++;
         }
      }
      
      override protected function follow() : void
      {
         var _loc10_:MyLittleParticle = null;
         if(!targetBody || !targetBody.GetUserData())
         {
            beginSeek();
            return;
         }
         if(userData(targetBody.GetUserData()).dead)
         {
            beginSeek();
            return;
         }
         var _loc1_:b2Vec2 = pixelCenter;
         var _loc2_:b2Vec2 = targetBody.GetWorldCenter().Copy();
         _loc2_.Multiply(Physics.scale);
         var _loc3_:Vector.<Array> = ud.skin;
         var _loc4_:uint = 4285797139;
         if(Boolean(_loc3_) && _loc3_.length > 0)
         {
            _loc4_ = 4278190080 + BoxUtils.getSkinColour(_loc3_,"741313");
         }
         var _loc5_:Number = _loc1_.x;
         var _loc6_:Number = _loc1_.y;
         var _loc7_:Number = _loc2_.x;
         var _loc8_:Number = _loc2_.y;
         var _loc9_:Vector.<MyLittleParticle> = BoxUtils.randomSlopeParticles("laser",_loc2_,_loc1_,2 / (ud.triggerDuration / ud.originalTriggerDuration));
         for each(_loc10_ in _loc9_)
         {
            _loc10_.health = 1;
         }
         if(ud.triggerDuration > 0)
         {
            ud.triggerDuration -= TimeLord.speed;
         }
         fly(0,-Vars.gravity,40);
         if(ud.triggerDuration > 0)
         {
            return;
         }
         var _loc11_:b2Vec2 = targetBody.GetPosition();
         var _loc12_:b2Vec2 = body.GetPosition();
         var _loc13_:Number = _loc11_.x - _loc12_.x;
         var _loc14_:Number = _loc11_.y - _loc12_.y;
         var _loc15_:userData = userData(targetBody.GetUserData());
         fly(_loc13_ * 250,_loc14_ * 250,1000);
         if(_loc13_ * _loc13_ + _loc14_ * _loc14_ < 20)
         {
            state = "destroy";
         }
      }
      
      override protected function destroy() : Boolean
      {
         if(!super.destroy())
         {
            return false;
         }
         ud.trigger = new Bomb();
         ud.triggerDuration = 1;
         ud.triggerRadius = 240;
         ud.triggerForce = 3000;
         ud.triggered = true;
         return true;
      }
   }
}

