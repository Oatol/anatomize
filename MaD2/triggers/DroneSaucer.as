package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.Sprite;
   
   public class DroneSaucer extends Drone
   {
      
      internal var collected:int = 0;
      
      public function DroneSaucer()
      {
         super();
      }
      
      override protected function seek() : void
      {
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
         var _loc3_:b2Body = this.raycast();
         if(_loc3_)
         {
            followBody(_loc3_);
            state = "destroy";
         }
      }
      
      private function raycast() : b2Body
      {
         var _loc6_:b2Body = null;
         var _loc7_:userData = null;
         var _loc8_:Sprite = null;
         var _loc9_:uint = 0;
         var _loc10_:Vector.<Array> = null;
         var _loc1_:Number = Math.cos(bodyAngle + Math.PI * 0.5);
         var _loc2_:Number = Math.sin(bodyAngle + Math.PI * 0.5);
         var _loc3_:b2Vec2 = new b2Vec2(pixelCenter.x,pixelCenter.y + 50);
         var _loc4_:b2Vec2 = new b2Vec2(pixelCenter.x,pixelCenter.y + 80);
         var _loc5_:Array = GameState.cutter.CustomRaycast(_loc3_,500,_loc4_,false);
         ud.triggerDuration -= TimeLord.speed;
         if(ud.triggerDuration > 0)
         {
            return null;
         }
         if(_loc5_[0])
         {
            _loc8_ = new Sprite();
            _loc9_ = 501700;
            _loc10_ = ud.skin;
            if((Boolean(_loc10_)) && _loc10_.length > 0)
            {
               _loc9_ = BoxUtils.getSkinColour(_loc10_,"07a7c4");
            }
            _loc8_.graphics.lineStyle(20,_loc9_,0.1);
            _loc8_.graphics.beginFill(_loc9_,0.5);
            _loc8_.graphics.moveTo(GraphicUtils.camX(_loc3_.x) + camPos.x,GraphicUtils.camY(_loc3_.y) + camPos.y);
            _loc8_.graphics.lineTo(GraphicUtils.camX(_loc5_[1].x * Physics.scale) + camPos.x,GraphicUtils.camY(_loc5_[1].y * Physics.scale) + camPos.y);
            _loc8_.graphics.drawCircle(GraphicUtils.camX(_loc5_[1].x * Physics.scale) + camPos.x,GraphicUtils.camY(_loc5_[1].y * Physics.scale) + camPos.y,10 * Main.instance.cam.scaleX);
            Main.instance.particlesBMD.draw(_loc8_);
            _loc6_ = _loc5_[0];
            if(_loc6_.IsStatic())
            {
               return null;
            }
            if(userData(_loc6_.GetUserData()).name.indexOf("antialienhat") != -1)
            {
               return null;
            }
            return _loc6_;
         }
         return null;
      }
      
      override protected function follow() : void
      {
         var _loc1_:b2Vec2 = null;
         var _loc2_:b2Vec2 = null;
         var _loc3_:Sprite = null;
         super.follow();
         body.SetAngularVelocity(body.GetAngularVelocity() * 0.9);
         body.ApplyTorque(-bodyAngle * 1000);
         if(targetBody)
         {
            _loc1_ = bodyCenter;
            _loc2_ = targetBody.GetWorldCenter().Copy();
            _loc3_ = new Sprite();
            _loc3_.graphics.lineStyle(2,11184810,Math.random());
            _loc3_.graphics.moveTo(_loc1_.x * Physics.scale + camPos.x,_loc1_.y * Physics.scale + camPos.y);
            _loc3_.graphics.lineTo(_loc2_.x * Physics.scale + camPos.x,_loc2_.y * Physics.scale + camPos.y);
            Main.instance.particlesBMD.draw(_loc3_);
         }
      }
      
      override protected function destroy() : Boolean
      {
         if(!super.destroy())
         {
            return false;
         }
         var _loc1_:b2Body = this.raycast();
         if(!_loc1_ || !targetBody)
         {
            beginSeek();
            return false;
         }
         if(_loc1_ != targetBody)
         {
            followBody(_loc1_);
            state = "destroy";
            return false;
         }
         body.SetAngularVelocity(body.GetAngularVelocity() * 0.9);
         body.ApplyTorque(-bodyAngle * 1000);
         var _loc2_:b2Body = targetBody;
         _loc2_.WakeUp();
         _loc2_.GetLinearVelocity().Multiply(0.5);
         _loc2_.SetAngularVelocity(_loc2_.GetAngularVelocity() * 0.9);
         var _loc3_:Number = 24;
         if(ud.triggerForce != 0)
         {
            _loc3_ = ud.triggerForce;
         }
         _loc2_.ApplyForce(new b2Vec2(body.GetLinearVelocity().x * _loc2_.GetMass() * 24,-_loc2_.GetMass() * _loc3_),_loc2_.GetWorldCenter());
         sounds.play("carbine_shoot",body,pixelCenter,0.2,false);
         var _loc4_:String = "forcefield";
         if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
         {
            _loc4_ = ud.pfx.getParticle();
         }
         BoxUtils.randomParticlesOnBody(_loc2_,_loc4_);
         ud.triggerDuration -= TimeLord.speed;
         var _loc5_:Number = BoxUtils.vectorDist(bodyCenter,targetBody.GetPosition());
         if(_loc5_ < 50)
         {
            sounds.play("disc_shoot",body,pixelCenter,0.5);
            userData(targetBody.GetUserData()).trigger = new Disintegrate(_loc4_,100,10);
            userData(targetBody.GetUserData()).triggered = true;
            userData(targetBody.GetUserData()).triggerLock = true;
            beginSeek();
            ++this.collected;
            if(this.collected > 5)
            {
               this.flyaway();
            }
         }
         return true;
      }
      
      private function flyaway() : void
      {
         ud.sensor = true;
         state = "end";
         ud.ignore = "!projectiles";
         ud.zerograv = true;
         ud.unbreakable = true;
         ud.triggerLock = true;
         ud.ghost = true;
         Body.RemoveJoints(body);
         body.SetLinearVelocity(new b2Vec2());
         body.ApplyImpulse(new b2Vec2(0,-1000),bodyCenter);
         var _loc1_:int = 0;
         while(_loc1_ < 100)
         {
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,"forcefield",0,1,Math.random() * 4 - 2,Math.random() * 10);
            _loc1_++;
         }
      }
   }
}

