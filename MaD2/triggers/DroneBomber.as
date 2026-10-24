package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.Sprite;
   
   public class DroneBomber extends Drone
   {
      
      public function DroneBomber()
      {
         super();
      }
      
      override protected function seek() : void
      {
         var _loc11_:b2Body = null;
         var _loc12_:userData = null;
         body.WakeUp();
         var _loc1_:Number = Math.random() * seekX - seekX * 0.5;
         var _loc2_:Number = -Vars.gravity + Math.random() * seekX - seekX * 0.5;
         fly(_loc1_,_loc2_,seekSpin);
         body.SetAngularVelocity(body.GetAngularVelocity() * 0.9);
         body.ApplyTorque(-bodyAngle * 1000);
         if(Math.abs(bodyAngle) > 0.5)
         {
            return;
         }
         var _loc3_:Number = Math.cos(bodyAngle + Math.PI * 0.5);
         var _loc4_:Number = Math.sin(bodyAngle + Math.PI * 0.5);
         var _loc5_:b2Vec2 = new b2Vec2(pixelCenter.x,pixelCenter.y + 50);
         var _loc6_:b2Vec2 = new b2Vec2(pixelCenter.x,pixelCenter.y + 80);
         if(ud.triggerForce == 20)
         {
            ud.triggerForce = 500;
         }
         var _loc7_:Array = GameState.cutter.CustomRaycast(_loc5_,ud.triggerForce,_loc6_,false);
         var _loc8_:Sprite = new Sprite();
         var _loc9_:uint = 16711680;
         var _loc10_:Vector.<Array> = ud.skin;
         if((Boolean(_loc10_)) && _loc10_.length > 0)
         {
            _loc9_ = BoxUtils.getSkinColour(_loc10_,"94002d");
         }
         _loc8_.graphics.lineStyle(1,_loc9_,0.5);
         _loc8_.graphics.beginFill(_loc9_,0.5);
         _loc8_.graphics.moveTo(GraphicUtils.camX(_loc5_.x) + camPos.x,GraphicUtils.camY(_loc5_.y) + camPos.y);
         _loc8_.graphics.lineTo(GraphicUtils.camX(_loc7_[1].x * Physics.scale) + camPos.x,GraphicUtils.camY(_loc7_[1].y * Physics.scale) + camPos.y);
         _loc8_.graphics.drawCircle(GraphicUtils.camX(_loc7_[1].x * Physics.scale) + camPos.x,GraphicUtils.camY(_loc7_[1].y * Physics.scale) + camPos.y,3 * Main.instance.cam.scaleX);
         Main.instance.particlesBMD.draw(_loc8_);
         ud.triggerDuration -= TimeLord.speed;
         if(ud.triggerDuration > 0)
         {
            return;
         }
         if(_loc7_[0])
         {
            _loc11_ = _loc7_[0];
            if(!_loc11_.IsStatic() && userData(_loc11_.GetUserData()).name != "bomb")
            {
               followBody(_loc11_);
               state = "destroy";
            }
         }
      }
      
      override protected function follow() : void
      {
         super.follow();
         body.SetAngularVelocity(body.GetAngularVelocity() * 0.9);
         body.ApplyTorque(-bodyAngle * 1000);
      }
      
      override protected function destroy() : Boolean
      {
         if(!super.destroy())
         {
            return false;
         }
         GameState.objects.addbullet("airbomb",bodyCenter.x,bodyCenter.y + 4.5 * ud.size,Math.PI,1,0.4,new b2Vec2(0,10),2,body);
         sounds.play("thumper_shoot",body,pixelCenter,0.5);
         targetBody = null;
         state = "seek";
         ud.triggerDuration = ud.originalTriggerDuration;
         return true;
      }
   }
}

