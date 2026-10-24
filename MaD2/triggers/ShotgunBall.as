package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class ShotgunBall extends Trigger
   {
      
      public function ShotgunBall()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:b2Vec2 = null;
         var _loc8_:int = 0;
         var _loc9_:b2Vec2 = null;
         var _loc10_:String = null;
         super.trigger(param1,param2);
         var _loc3_:Number = param2.triggerRadius * param2.size;
         var _loc4_:Array = Body.GetAround(param1,_loc3_,_loc3_,false);
         sounds.play("shotgun_shoot",param1,pixelCenter,0.5);
         var _loc5_:int = 0;
         while(_loc5_ < 8)
         {
            _loc6_ = _loc5_ * 45 + bodyAngle * Vars.toDegrees;
            _loc7_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,25 * param2.size,_loc6_);
            _loc8_ = 0;
            while(_loc8_ < 20)
            {
               _loc10_ = "poof";
               if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
               {
                  _loc10_ = param2.pfx.getParticle();
               }
               GameState.particles.addParticles(_loc7_.x,_loc7_.y,1,_loc10_,(-pixelCenter.x + _loc7_.x) * 0.5 + bodyVel.x * 0.01,(-pixelCenter.y + _loc7_.y) * 0.5 + bodyVel.y * 0.01,1,1);
               _loc8_++;
            }
            _loc9_ = _loc7_.Copy();
            _loc9_.x -= pixelCenter.x;
            _loc9_.y -= pixelCenter.y;
            _loc9_.Multiply(100 / Physics.scale);
            GameState.objects.addbullet("sho",_loc7_.x / Physics.scale,_loc7_.y / Physics.scale,_loc6_,4,0.5,_loc9_,1,param1);
            _loc5_++;
         }
         param2.dead = true;
         Body.Disintegrate(param1,"poof",100,4,4);
      }
   }
}

