package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Lemonade extends Trigger
   {
      
      public function Lemonade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc7_:Number = NaN;
         var _loc8_:b2Vec2 = null;
         var _loc9_:int = 0;
         var _loc10_:b2Vec2 = null;
         var _loc11_:String = null;
         super.trigger(param1,param2);
         var _loc3_:Number = param2.triggerRadius * param2.size;
         var _loc4_:Array = Body.GetAround(param1,_loc3_,_loc3_,false);
         sounds.play("splash",param1,pixelCenter,0.5);
         var _loc5_:int = 8;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = _loc6_ * (360 / _loc5_) + bodyAngle * Vars.toDegrees;
            _loc8_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,25 * param2.size,_loc7_);
            _loc9_ = 0;
            while(_loc9_ < 20)
            {
               _loc11_ = "poof";
               if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
               {
                  _loc11_ = param2.pfx.getParticle();
               }
               GameState.particles.addParticles(_loc8_.x,_loc8_.y,1,_loc11_,(-pixelCenter.x + _loc8_.x) * 0.5 + bodyVel.x * 0.01,(-pixelCenter.y + _loc8_.y) * 0.5 + bodyVel.y * 0.01,1,1);
               _loc9_++;
            }
            _loc10_ = _loc8_.Copy();
            _loc10_.x -= pixelCenter.x;
            _loc10_.y -= pixelCenter.y;
            _loc10_.Multiply(10 / Physics.scale);
            GameState.objects.addbullet("lemon",_loc8_.x / Physics.scale,_loc8_.y / Physics.scale,_loc7_,1,0.5,_loc10_,1,param1);
            _loc6_++;
         }
         param2.dead = true;
         Body.Disintegrate(param1,"poof",100,4,4);
      }
   }
}

