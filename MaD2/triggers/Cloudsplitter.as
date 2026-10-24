package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Cloudsplitter extends Trigger
   {
      
      internal var previousRad:Number = 0;
      
      public function Cloudsplitter()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(param1.IsSleeping())
         {
            return;
         }
         var _loc3_:b2Vec2 = new b2Vec2(0,-15 * param2.size);
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc5_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
         var _loc6_:Number = Math.abs(param1.GetAngularVelocity());
         if(bodyVel.Length() > _loc6_)
         {
            _loc6_ = bodyVel.Length() * 0.1;
         }
         if(_loc6_ > 1)
         {
            param2.triggerRadius = _loc6_ * 10;
            if(param2.triggerRadius > 100 * param2.size)
            {
               param2.triggerRadius = 100 * param2.size;
            }
            if(param2.triggerRadius < 20)
            {
               param2.triggerRadius = 0;
            }
         }
         else
         {
            param2.triggerRadius = 1;
         }
         if(param2.triggerRadius > 10)
         {
            this.Effect();
            if(this.previousRad < 10)
            {
               sounds.play("thunder",param1,pixelCenter,1,false);
            }
         }
         this.previousRad = param2.triggerRadius;
      }
      
      public function Effect() : void
      {
         var _loc9_:Number = NaN;
         var _loc10_:b2Vec2 = null;
         var _loc11_:Vector.<MyLittleParticle> = null;
         var _loc12_:MyLittleParticle = null;
         var _loc1_:b2Vec2 = new b2Vec2(Math.random() * ud.triggerRadius - ud.triggerRadius * 0.5,Math.random() * ud.triggerRadius - ud.triggerRadius * 0.5);
         var _loc2_:b2Body = Spawn.circle(pixelCenter.x + _loc1_.x,pixelCenter.y + _loc1_.y,5,Properties.objectProperties("pulse"),[0.01,1,1]);
         userData(_loc2_.GetUserData()).ghost = true;
         userData(_loc2_.GetUserData()).ignore = "cloudsplitter";
         userData(_loc2_.GetUserData()).killOnContact = true;
         userData(_loc2_.GetUserData()).trigger = new Tesla();
         userData(_loc2_.GetUserData()).triggerRadius = 20;
         userData(_loc2_.GetUserData()).triggered = true;
         userData(_loc2_.GetUserData()).triggerLock = true;
         var _loc3_:b2Vec2 = bodyVel.Copy();
         _loc3_.Multiply(0.01);
         _loc2_.ApplyImpulse(_loc3_,_loc2_.GetWorldCenter());
         var _loc4_:String = "thundercloud";
         if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
         {
            _loc4_ = ud.pfx.getParticle();
         }
         var _loc5_:b2Vec2 = new b2Vec2(triggerPos.x * ud.size * (ud.flipped ? -1 : 1),triggerPos.y * ud.size);
         var _loc6_:b2Vec2 = BoxUtils.rotateVec(_loc5_,bodyAngle);
         var _loc7_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc6_.x,pixelCenter.y + _loc6_.y);
         var _loc8_:int = 0;
         while(_loc8_ < 2)
         {
            _loc9_ = Math.random() * ud.triggerRadius + ud.triggerRadius * 0.5 + 20;
            if(Math.random() > 0.5)
            {
               _loc9_ *= -1;
            }
            _loc10_ = new b2Vec2(_loc9_,Math.sin(_loc9_) + Math.random() * 100 - 20);
            _loc10_ = BoxUtils.rotateVec(_loc10_,bodyAngle);
            _loc11_ = GameState.particles.addParticles(_loc7_.x + _loc10_.x,_loc7_.y + _loc10_.y,1,_loc4_,0,0,0,0);
            if(_loc11_)
            {
               for each(_loc12_ in _loc11_)
               {
                  _loc12_.health = 200;
               }
            }
            _loc8_++;
         }
      }
   }
}

