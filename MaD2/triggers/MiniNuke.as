package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class MiniNuke extends Trigger
   {
      
      public function MiniNuke()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc7_:b2Body = null;
         var _loc8_:int = 0;
         var _loc9_:b2Vec2 = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:b2Vec2 = null;
         var _loc13_:String = null;
         var _loc14_:b2Vec2 = null;
         temporary = true;
         super.trigger(param1,param2);
         var _loc3_:Number = param2.triggerDuration * param2.size * 30;
         var _loc4_:Array = Body.GetAround(param1,_loc3_,_loc3_,false);
         var _loc5_:Array = ["poof","fire2","fire3"];
         var _loc6_:Array = ["explosion","explosion2","explosion3","explosion4"];
         if((param2.triggerDuration >> 0) % 2 == 0 && Math.random() * TimeLord.speed < TimeLord.speed * 0.25)
         {
            sounds.play(_loc6_[Math.random() * 4 >> 0],param1,pixelCenter,0.6);
         }
         for each(_loc7_ in _loc4_)
         {
            _loc9_ = new b2Vec2(-_loc7_.GetWorldCenter().x * Physics.scale + pixelCenter.x,-_loc7_.GetWorldCenter().y * Physics.scale + pixelCenter.y);
            _loc10_ = _loc9_.Normalize();
            _loc11_ = (_loc3_ - _loc10_) / _loc3_ * 200;
            _loc12_ = new b2Vec2(_loc9_.x * _loc11_,_loc9_.y * _loc11_);
            _loc7_.SetLinearVelocity(_loc12_);
            Body.Disintegrate(_loc7_,_loc5_[Math.random() * _loc5_.length >> 0],200,2,2);
         }
         _loc5_ = ["poof","explosive","fire2","fire3","poof"];
         _loc8_ = 0;
         while(_loc8_ < 100 * TimeLord.speed)
         {
            _loc13_ = _loc5_[Math.random() * _loc5_.length >> 0];
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc13_ = param2.pfx.getParticle();
            }
            _loc14_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,_loc3_,Math.random() * 360);
            GameState.particles.addParticles(_loc14_.x,_loc14_.y,1,_loc13_,(pixelCenter.x - _loc14_.x) * 0.5 + bodyVel.x * 0.01,(pixelCenter.y - _loc14_.y) * 0.5 + bodyVel.y * 0.01,1,1);
            _loc8_++;
         }
         if(_loc3_ > 400 * param2.size)
         {
            param2.dead = true;
            Body.Disintegrate(param1,"poof",100,4,4);
         }
         param2.triggerDuration += TimeLord.speed;
      }
   }
}

