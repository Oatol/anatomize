package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class RepelGrenade extends Trigger
   {
      
      public function RepelGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:Array = null;
         var _loc8_:b2Body = null;
         var _loc9_:b2Vec2 = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:b2Vec2 = null;
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         if(triggerDuration <= 90)
         {
            if(triggerDuration <= 0)
            {
               param2.dead = true;
               return;
            }
            _loc3_ = param2.triggerRadius * param2.size;
            _loc4_ = 0;
            while(_loc4_ < 4)
            {
               _loc5_ = "air";
               if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
               {
                  _loc5_ = param2.pfx.getParticle();
               }
               _loc6_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,(90 - (90 - param2.triggerDuration)) * param2.size,_loc4_ * 90 + param2.triggerDuration * 8);
               GameState.particles.addParticles(_loc6_.x,_loc6_.y,1,_loc5_,(pixelCenter.x - _loc6_.x) * 0.05 + bodyVel.x * 0.01,(pixelCenter.y - _loc6_.y) * 0.05 + bodyVel.y * 0.01,1,1);
               _loc4_++;
            }
            if(triggerDuration < 10)
            {
               _loc4_ = 0;
               while(_loc4_ < 36)
               {
                  _loc5_ = "air";
                  if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
                  {
                     _loc5_ = param2.pfx.getParticle();
                  }
                  _loc6_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,(30 - param2.triggerDuration) * param2.size,_loc4_ * 10 + param2.triggerDuration * 2);
                  GameState.particles.addParticles(_loc6_.x,_loc6_.y,1,_loc5_,(-pixelCenter.x + _loc6_.x) * 2,(-pixelCenter.y + _loc6_.y) * 2,1,1);
                  _loc4_++;
               }
               _loc7_ = Body.GetAround(param1,_loc3_,_loc3_,false);
               for each(_loc8_ in _loc7_)
               {
                  if(!userData(_loc8_.GetUserData()).resistGust)
                  {
                     _loc9_ = new b2Vec2(-_loc8_.GetWorldCenter().x * Physics.scale + pixelCenter.x,-_loc8_.GetWorldCenter().y * Physics.scale + pixelCenter.y);
                     _loc10_ = _loc9_.Normalize();
                     _loc11_ = (_loc3_ - _loc10_) / _loc3_ * -20000;
                     _loc12_ = new b2Vec2(_loc9_.x * _loc11_,_loc9_.y * _loc11_);
                     _loc8_.WakeUp();
                     _loc8_.ApplyForce(_loc12_,_loc8_.GetWorldCenter());
                  }
               }
               if(param2.triggerDuration == 9)
               {
                  sounds.play("explosion5",param1,pixelCenter,0.6);
               }
               else
               {
                  sounds.random(["throw1","throw2","throw3"],param1,pixelCenter,0.4);
               }
            }
         }
      }
   }
}

