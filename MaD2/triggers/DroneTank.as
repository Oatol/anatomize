package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.Sprite;
   
   public class DroneTank extends Drone
   {
      
      internal var offset:Sprite;
      
      internal var hammer:Sprite;
      
      internal var busy:Boolean = false;
      
      public function DroneTank()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         this.offset = new Sprite();
         this.hammer = O.getItem("tankcannon").updateGraphic();
         this.offset.addChild(this.hammer);
         this.hammer.y = -50 * param2.size;
         this.hammer.x = 0;
         this.hammer.scaleX = this.hammer.scaleY = param2.size;
         ud.graphic.addChildAt(this.offset,0);
         flyChance = 0.95;
         seekX = 50;
         seekY = 0;
         seekSpin = 0;
         followX = 0.1;
         followY = 0;
         followSpin = 0;
         velCapY = 1000;
         zerogravity = false;
         forceOffset = new b2Vec2(0,50 / Physics.scale);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         body.ApplyTorque(-bodyAngle * body.GetMass() * 100);
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
            if(userData(_loc1_.GetUserData()).saveable != false)
            {
               if(_loc1_.GetMass() >= 0.1)
               {
                  if(Math.random() > 0.8)
                  {
                     followBody(_loc1_);
                     break;
                  }
               }
            }
            _loc3_++;
         }
         if(!targetBody)
         {
            this.animate();
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
            if(_loc3_ * _loc3_ + _loc4_ * _loc4_ < 80 * ud.size)
            {
               fly(_loc3_ * 5,0);
            }
         }
         this.animate();
      }
      
      override protected function destroy() : Boolean
      {
         if(!super.destroy())
         {
            return false;
         }
         var _loc1_:b2Vec2 = targetBody.GetPosition();
         var _loc2_:Number = this.offset.rotation - 90 + ud.graphic.rotation;
         var _loc3_:Number = 75 * ud.size;
         var _loc4_:b2Vec2 = GeneralUtils.pointOnCircle(bodyCenter.x,bodyCenter.y,_loc3_ / Physics.scale,_loc2_);
         GameState.objects.addbullet("muzzleflash",_loc4_.x,_loc4_.y,_loc2_ * Vars.toRadians,1,ud.size,new b2Vec2(100 * (-bodyCenter.x + _loc4_.x),100 * (-bodyCenter.y + _loc4_.y)),0,body);
         sounds.play("cannon2",body,pixelCenter,0.5);
         beginSeek();
         return true;
      }
      
      internal function animate() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc1_:Number = this.offset.rotation;
         ud.triggerDuration -= TimeLord.speed;
         if(ud.triggerDuration <= 0)
         {
            beginSeek();
         }
         if(targetBody)
         {
            _loc2_ = Math.atan2(bodyCenter.y - targetBody.GetPosition().y,bodyCenter.x - targetBody.GetPosition().x) * Vars.toDegrees + 180;
            _loc3_ = _loc2_;
            _loc3_ -= ud.graphic.rotation;
            if(_loc3_ < 90)
            {
               _loc3_ = 359;
            }
            if(_loc3_ > 90 && _loc3_ < 180)
            {
               _loc3_ = 180;
            }
            _loc3_ -= 270;
            _loc2_ -= 270;
            _loc1_ += (-_loc1_ + _loc3_) * (Math.random() * Math.random() * 0.25 + 0.05);
            if(Math.abs(_loc1_ - _loc2_) < 5 || Math.abs(_loc1_ - _loc2_) > 355)
            {
               if(triggerForce > 50)
               {
                  triggerForce = 50;
               }
               if(triggerForce >= 100 || Math.random() > (100 - triggerForce) * 0.01)
               {
                  this.destroy();
               }
            }
         }
         else
         {
            _loc1_ -= ud.graphic.rotation * 0.2;
         }
         this.busy = true;
         if(_loc1_ > -180 && _loc1_ < -90)
         {
            _loc1_ = -90;
         }
         if(_loc1_ >= 90)
         {
            _loc1_ = 90;
         }
         if(_loc1_ > -270 && _loc1_ < -180)
         {
            _loc1_ = 90;
         }
         this.offset.rotation = _loc1_;
      }
   }
}

