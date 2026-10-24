package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class PowderGrenade extends Trigger
   {
      
      public function PowderGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Body = null;
         var _loc6_:int = 0;
         var _loc7_:b2Vec2 = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:b2Vec2 = null;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         var _loc13_:b2Vec2 = null;
         super.trigger(param1,param2);
         var _loc3_:Number = param2.triggerRadius * param2.size;
         var _loc4_:Array = Body.GetAround(param1,_loc3_,_loc3_,false);
         sounds.play("explosion5",param1,pixelCenter,0.5);
         for each(_loc5_ in _loc4_)
         {
            _loc7_ = new b2Vec2(-_loc5_.GetWorldCenter().x * Physics.scale + pixelCenter.x,-_loc5_.GetWorldCenter().y * Physics.scale + pixelCenter.y);
            _loc8_ = _loc7_.Normalize();
            _loc9_ = (_loc3_ - _loc8_) / _loc3_ * -100;
            _loc10_ = new b2Vec2(_loc7_.x * _loc9_,_loc7_.y * _loc9_);
            _loc5_.SetLinearVelocity(_loc10_);
            _loc11_ = "poof";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc11_ = param2.pfx.getParticle();
            }
            Body.Disintegrate(_loc5_,_loc11_,200,4,4);
         }
         _loc6_ = 0;
         while(_loc6_ < 20)
         {
            _loc12_ = 0;
            while(_loc12_ < 6)
            {
               _loc11_ = "poof";
               if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
               {
                  _loc11_ = param2.pfx.getParticle();
               }
               _loc13_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,20 * param2.size,_loc12_ * 60 + bodyAngle * Vars.toDegrees);
               GameState.particles.addParticles(_loc13_.x,_loc13_.y,1,_loc11_,(pixelCenter.x - _loc13_.x) * 0.5 + bodyVel.x * 0.01,(pixelCenter.y - _loc13_.y) * 0.5 + bodyVel.y * 0.01,1,1);
               _loc12_++;
            }
            _loc6_++;
         }
         param2.dead = true;
         Body.Disintegrate(param1,"poof",100,4,4);
      }
   }
}

