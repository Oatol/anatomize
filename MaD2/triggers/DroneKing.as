package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class DroneKing extends Drone
   {
      
      public function DroneKing()
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
         super.seek();
         if(targetBody)
         {
            _loc5_ = targetBody.GetPosition();
            _loc6_ = body.GetPosition();
            _loc7_ = _loc5_.x - _loc6_.x;
            _loc8_ = _loc5_.y - _loc6_.y;
            if(_loc7_ * _loc7_ + _loc8_ * _loc8_ < 60)
            {
               fly(_loc7_ * -50,_loc8_ * -50,100);
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
            if(!userData(_loc1_.GetUserData()).hasBeenCut)
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
      
      override protected function destroy() : Boolean
      {
         if(!super.destroy())
         {
            return false;
         }
         var _loc1_:b2Vec2 = targetBody.GetPosition();
         var _loc2_:b2Vec2 = body.GetPosition();
         var _loc3_:Number = _loc1_.x - _loc2_.x;
         var _loc4_:Number = _loc1_.y - _loc2_.y;
         var _loc5_:userData = userData(targetBody.GetUserData());
         var _loc6_:Array = [DroneClean,DroneExplosive,DroneLaser,DroneHammer,DroneRocket,DroneToxic,DronePin,DronePaint,DroneFlame,DroneMelee,DronePotato,DroneShock,DroneSpeaker,DroneTracker,DroneBomber,DroneMother];
         var _loc7_:Class = getDefinitionByName(getQualifiedClassName(_loc6_[_loc6_.length * Math.random() >> 0])) as Class;
         _loc5_.trigger = new _loc7_();
         _loc5_.triggered = true;
         _loc5_.triggerRadius = 100;
         _loc5_.triggerDuration = 50;
         fly(_loc3_ * 50,_loc4_ * 50,500);
         state = "seek";
         ud.triggerDuration = ud.originalTriggerDuration;
         return true;
      }
   }
}

