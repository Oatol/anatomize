package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.Sprite;
   
   public class DroneShock extends Drone
   {
      
      internal var cloudPos:b2Vec2;
      
      public function DroneShock()
      {
         super();
      }
      
      override protected function seek() : void
      {
         var _loc11_:b2Body = null;
         var _loc12_:userData = null;
         var _loc13_:int = 0;
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
         var _loc5_:b2Vec2 = new b2Vec2(pixelCenter.x,pixelCenter.y + 20);
         var _loc6_:b2Vec2 = new b2Vec2(pixelCenter.x,pixelCenter.y + 30);
         var _loc7_:Array = GameState.cutter.CustomRaycast(_loc5_,ud.triggerForce,_loc6_,false);
         var _loc8_:Sprite = new Sprite();
         var _loc9_:uint = 15794022;
         var _loc10_:Vector.<Array> = ud.skin;
         if((Boolean(_loc10_)) && _loc10_.length > 0)
         {
            _loc9_ = BoxUtils.getSkinColour(_loc10_,"f0ff66");
         }
         _loc8_.graphics.lineStyle(1,_loc9_,0.2);
         _loc8_.graphics.beginFill(_loc9_,0.5);
         _loc8_.graphics.moveTo(GraphicUtils.camX(_loc5_.x) + camPos.x,GraphicUtils.camY(_loc5_.y) + camPos.y);
         _loc8_.graphics.lineTo(GraphicUtils.camX(_loc7_[1].x * Physics.scale) + camPos.x,GraphicUtils.camY(_loc7_[1].y * Physics.scale) + camPos.y);
         Main.instance.particlesBMD.draw(_loc8_);
         ud.triggerDuration -= TimeLord.speed;
         if(ud.triggerDuration > 0)
         {
            return;
         }
         if(_loc7_[0])
         {
            _loc11_ = _loc7_[0];
            if(!_loc11_.IsStatic())
            {
               if(targetBody != _loc11_)
               {
                  followBody(_loc11_);
                  if(state != "follow")
                  {
                     return;
                  }
                  sounds.play("thunder",body,pixelCenter,1);
                  this.cloudPos = bodyCenter.Copy();
                  _loc13_ = 0;
                  while(_loc13_ < 10)
                  {
                     GameState.particles.addParticles(pixelCenter.x + Math.random() * 40 - 20,pixelCenter.y + Math.random() * 50,1,"thundercloud",bodyVel.x,bodyVel.y,0,0);
                     _loc13_++;
                  }
               }
            }
         }
      }
      
      override protected function follow() : void
      {
         if(!targetBody || userData(targetBody.GetUserData()).dead || ud.triggerDuration > 180)
         {
            beginSeek();
            return;
         }
         fly(this.cloudPos.x - bodyCenter.x,this.cloudPos.y - bodyCenter.y - Vars.gravity,40);
         if(Math.random() > 0.9)
         {
            state = "destroy";
            GameState.particles.addParticles(this.cloudPos.x * Physics.scale + Math.random() * 40 - 20,this.cloudPos.y * Physics.scale + Math.random() * 50,1,"thundercloud",bodyVel.x,bodyVel.y,0,0);
         }
      }
      
      override protected function destroy() : Boolean
      {
         if(!super.destroy())
         {
            return false;
         }
         GameState.objects.addbullet("zap1",this.cloudPos.x,this.cloudPos.y,Math.PI,1,0.4,new b2Vec2(0,10),2,body);
         if(Math.random() > 0.9)
         {
            targetBody = null;
            state = "seek";
            ud.triggerDuration = ud.originalTriggerDuration;
         }
         else
         {
            state = "follow";
         }
         return true;
      }
   }
}

