package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class DroneGrapple extends Drone
   {
      
      private var burst:int = 0;
      
      internal var grapple:b2Body;
      
      internal var dir:b2Vec2 = new b2Vec2();
      
      public function DroneGrapple()
      {
         super();
      }
      
      override protected function seek() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:userData = null;
         var _loc4_:userData = null;
         super.seek();
         if(this.grapple)
         {
            _loc4_ = userData(this.grapple.GetUserData());
            if(!_loc4_ || _loc4_.dead || !this.grapple)
            {
               this.grapple = null;
               return;
            }
            if(Grapple(_loc4_.trigger).grapplered)
            {
               followBody(this.grapple);
            }
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < seekbodies.length)
         {
            _loc1_ = b2Body(seekbodies[_loc3_]);
            if(Math.random() > 0.8)
            {
               followBody(_loc1_);
               break;
            }
            _loc3_++;
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
            _loc1_ = bodyCenter;
            _loc2_ = targetBody.GetWorldCenter().Copy();
            _loc3_ = _loc1_.x - _loc2_.x;
            _loc4_ = _loc1_.y - _loc2_.y;
            if(Math.random() > 0.9)
            {
               this.dir.x = Math.random() - 0.5;
               this.dir.y = Math.random() - 0.5;
            }
            if(this.grapple)
            {
               fly(_loc3_ + this.dir.x * 100 * ud.triggerForce,_loc4_ + this.dir.y * 100 * ud.triggerForce);
               return;
            }
            if(_loc3_ * _loc3_ + _loc4_ * _loc4_ < 100 * ud.size)
            {
               fly(_loc3_ * 10,_loc4_ * 10);
            }
            else
            {
               fly(-_loc3_ * 30,-_loc4_ * 30);
            }
         }
      }
      
      override protected function destroy() : Boolean
      {
         if(!super.destroy())
         {
            return false;
         }
         if(this.grapple)
         {
            state = "seek";
            ud.triggerDuration = ud.originalTriggerDuration;
            return true;
         }
         var _loc1_:b2Vec2 = targetBody.GetPosition();
         var _loc2_:Number = Math.atan2(_loc1_.y - bodyCenter.y,_loc1_.x - bodyCenter.x);
         var _loc3_:Number = 40 * ud.size;
         var _loc4_:b2Vec2 = GeneralUtils.pointOnCircle(bodyCenter.x,bodyCenter.y,_loc3_ / Physics.scale,Vars.toDegrees * _loc2_);
         if(ud.flipped)
         {
            _loc2_ += Math.PI;
         }
         this.grapple = GameState.objects.addbullet("grapple",_loc4_.x,_loc4_.y,_loc2_,1,0.5 + 0.5 * ud.size,new b2Vec2(10 * (_loc1_.x - _loc4_.x),10 * (_loc1_.y - _loc4_.y)),10,body);
         sounds.play("whump",body,pixelCenter,0.5);
         state = "seek";
         ud.triggerDuration = ud.originalTriggerDuration;
         return true;
      }
   }
}

