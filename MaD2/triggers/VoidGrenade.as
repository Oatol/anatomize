package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class VoidGrenade extends Trigger
   {
      
      public function VoidGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Body = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc10_:b2Vec2 = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:b2Vec2 = null;
         var _loc14_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(param2.triggerDuration == param2.originalTriggerDuration)
         {
            sounds.play("pulse_shoot",param1,pixelCenter);
         }
         param2.ghost = true;
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration <= 0)
         {
            param2.dead = true;
            Body.Disintegrate(param1,"void",100,2,2);
         }
         var _loc3_:Number = param2.triggerRadius;
         var _loc4_:Array = Body.GetAroundPoint(pixelCenter,_loc3_,_loc3_,false);
         for each(_loc5_ in _loc4_)
         {
            if(userData(_loc5_.GetUserData()).name != "voidbullet")
            {
               _loc10_ = new b2Vec2(-_loc5_.GetWorldCenter().x * Physics.scale + pixelCenter.x,-_loc5_.GetWorldCenter().y * Physics.scale + pixelCenter.y);
               _loc11_ = _loc10_.Normalize();
               _loc12_ = (_loc3_ - _loc11_) / _loc3_ * -10000 * param2.size;
               if(_loc12_ < 0)
               {
                  _loc12_ *= -1;
               }
               _loc13_ = new b2Vec2(_loc10_.x * _loc12_,_loc10_.y * _loc12_);
               _loc14_ = _loc5_.GetWorldCenter().Copy();
               _loc14_.Add(new b2Vec2(Math.random() - 0.5,Math.random() - 0.5));
               _loc5_.ApplyForce(_loc13_,_loc14_);
               _loc5_.SetAngularVelocity(_loc5_.GetAngularVelocity() * 1.1);
               if(_loc5_.GetAngularVelocity() > 30)
               {
                  _loc5_.SetAngularVelocity(30);
               }
               if(_loc5_.GetAngularVelocity() < -30)
               {
                  _loc5_.SetAngularVelocity(-30);
               }
            }
         }
         _loc6_ = Math.random() * 360 >> 0;
         _loc7_ = "void";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc7_ = param2.pfx.getParticle();
         }
         var _loc8_:b2Vec2 = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,_loc3_,_loc6_);
         var _loc9_:b2Vec2 = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,_loc3_ * 1.1,_loc6_ - 2);
         GameState.particles.addParticles(_loc8_.x,_loc8_.y,1,_loc7_,bodyVel.x * 0.1 + _loc8_.x - _loc9_.x,bodyVel.y * 0.1 + _loc8_.y - _loc9_.y,0,0);
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration < 0)
         {
            param2.dead = true;
         }
      }
   }
}

