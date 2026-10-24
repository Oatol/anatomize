package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Nuke extends Trigger
   {
      
      public function Nuke()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc8_:b2Body = null;
         var _loc9_:int = 0;
         var _loc10_:b2Vec2 = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:b2Vec2 = null;
         var _loc14_:String = null;
         var _loc15_:b2Vec2 = null;
         temporary = true;
         super.trigger(param1,param2);
         param2.graphic.alpha = 0;
         param2.ghost = true;
         var _loc3_:Number = param2.triggerDuration * param2.size * 6;
         var _loc4_:Number = param2.triggerDuration * param2.size;
         var _loc5_:Array = Body.GetAround(param1,_loc3_,_loc3_,true);
         var _loc6_:Array = ["poof","fire2","fire3"];
         var _loc7_:Array = ["explosion","explosion2","explosion3","explosion4"];
         if((param2.triggerDuration >> 0) % 2 == 0 && Math.random() * TimeLord.speed < TimeLord.speed * 0.25)
         {
            sounds.play(_loc7_[Math.random() * 4 >> 0],param1,pixelCenter,0.6);
         }
         for each(_loc8_ in _loc5_)
         {
            _loc10_ = new b2Vec2(-_loc8_.GetWorldCenter().x * Physics.scale + pixelCenter.x,-_loc8_.GetWorldCenter().y * Physics.scale + pixelCenter.y);
            _loc11_ = _loc10_.Normalize();
            _loc12_ = (_loc3_ - _loc11_) / _loc3_ * 200;
            _loc13_ = new b2Vec2(-_loc10_.x * _loc12_,-_loc10_.y * _loc12_);
            _loc8_.SetLinearVelocity(_loc13_);
            Body.Disintegrate(_loc8_,_loc6_[Math.random() * _loc6_.length >> 0],200,2,2);
         }
         _loc6_ = ["poof","explosive","fire2","fire3","poof"];
         _loc9_ = 0;
         while(_loc9_ < 100 * TimeLord.speed)
         {
            _loc14_ = _loc6_[Math.random() * _loc6_.length >> 0];
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc14_ = param2.pfx.getParticle();
            }
            _loc15_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,_loc4_,Math.random() * 360);
            GameState.particles.addParticles(_loc15_.x,_loc15_.y,1,_loc14_,-(pixelCenter.x - _loc15_.x) * 0.5 + bodyVel.x * 0.01,-(pixelCenter.y - _loc15_.y) * 0.5 + bodyVel.y * 0.01,1,1);
            _loc9_++;
         }
         if(param2.triggerDuration > 180)
         {
            param2.dead = true;
            Body.Disintegrate(param1,"poof",100,4,4);
         }
         param2.triggerDuration += TimeLord.speed;
      }
   }
}

