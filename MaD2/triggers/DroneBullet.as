package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.Sprite;
   
   public class DroneBullet extends Drone
   {
      
      private var burst:int = 0;
      
      public function DroneBullet()
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
         var _loc5_:Vector.<Array> = null;
         var _loc6_:uint = 0;
         var _loc7_:Sprite = null;
         super.follow();
         if(targetBody)
         {
            _loc1_ = bodyCenter;
            _loc2_ = targetBody.GetWorldCenter().Copy();
            _loc3_ = _loc1_.x - _loc2_.x;
            _loc4_ = _loc1_.y - _loc2_.y;
            if(_loc3_ * _loc3_ + _loc4_ * _loc4_ < 100 * ud.size)
            {
               fly(_loc3_ * 10,_loc4_ * 10);
            }
            else
            {
               fly(-_loc3_ * 30,-_loc4_ * 30);
            }
            _loc5_ = ud.skin;
            _loc6_ = 12921900;
            _loc7_ = new Sprite();
            _loc7_.graphics.lineStyle(2,_loc6_,Math.random());
            _loc7_.graphics.drawCircle(GraphicUtils.camX(pixelCenter.x) + camPos.x,GraphicUtils.camY(pixelCenter.y) + camPos.y,Math.random() * 10 * Main.instance.cam.scaleX);
            Main.instance.particlesBMD.draw(_loc7_);
            this.rotateToTarget();
         }
      }
      
      private function rotateToTarget() : Number
      {
         var _loc1_:b2Vec2 = targetBody.GetPosition();
         var _loc2_:b2Vec2 = body.GetPosition();
         var _loc3_:Number = _loc1_.x - _loc2_.x;
         var _loc4_:Number = _loc1_.y - _loc2_.y;
         var _loc5_:Number = Math.atan2(_loc4_,_loc3_) + Math.PI * 0.5;
         var _loc6_:Number = bodyAngle % (Math.PI * 2);
         var _loc7_:Number = _loc5_ - _loc6_;
         if(_loc7_ > 0.1)
         {
            body.ApplyTorque(200 * body.GetMass());
         }
         else if(_loc7_ < -0.1)
         {
            body.ApplyTorque(-200 * body.GetMass());
         }
         body.SetAngularVelocity(body.GetAngularVelocity() * 0.9);
         return _loc7_;
      }
      
      override protected function destroy() : Boolean
      {
         if(!super.destroy())
         {
            return false;
         }
         if(Math.abs(this.rotateToTarget()) > 0.2)
         {
            return false;
         }
         var _loc1_:b2Vec2 = targetBody.GetPosition();
         var _loc2_:Number = Math.atan2(_loc1_.y - bodyCenter.y,_loc1_.x - bodyCenter.x);
         var _loc3_:Number = 40 * ud.size;
         var _loc4_:b2Vec2 = GeneralUtils.pointOnCircle(bodyCenter.x,bodyCenter.y,_loc3_ / Physics.scale,Vars.toDegrees * _loc2_);
         GameState.objects.addbullet("pis",_loc4_.x,_loc4_.y,_loc2_,1,0.5 + 0.5 * ud.size,new b2Vec2(10 * (_loc1_.x - _loc4_.x),10 * (_loc1_.y - _loc4_.y)),10,body);
         sounds.play("assault2_shoot",body,pixelCenter,0.5);
         ++this.burst;
         if(Math.random() > 0.8)
         {
            targetBody = null;
            state = "seek";
         }
         else
         {
            state = "follow";
         }
         if(this.burst >= 6)
         {
            this.burst = 0;
            ud.triggerDuration = 60;
            targetBody = null;
            state = "seek";
         }
         else
         {
            ud.triggerDuration = 4;
         }
         return true;
      }
   }
}

