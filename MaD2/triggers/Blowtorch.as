package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Blowtorch extends Lighter
   {
      
      internal var soundDuration:Number = 0;
      
      public function Blowtorch(param1:b2Vec2, param2:b2Vec2)
      {
         super(param1,param2,"frostfire");
         burnForce = 12;
         thawForce = 32;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         if(!sounds.isPlaying("burn"))
         {
            this.soundDuration -= TimeLord.speed;
            if(this.soundDuration <= 0)
            {
               sounds.play("flamer_shoot",param1,pixelCenter,0.2);
               this.soundDuration = 20;
            }
         }
         else
         {
            this.soundDuration = 0;
         }
         super.trigger(param1,param2);
         if(!burnbod)
         {
            return;
         }
         param2 = userData(burnbod.GetUserData());
         if(!param2)
         {
            return;
         }
         if(param2.armour)
         {
            param2.health += 10;
         }
      }
      
      override protected function Effect(param1:b2Vec2) : void
      {
         var _loc6_:MyLittleParticle = null;
         if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
         {
            papa = ud.pfx.getParticle();
         }
         var _loc2_:int = 1;
         if(ud.flipped)
         {
            _loc2_ = -1;
         }
         var _loc3_:Number = bodyAngle + Vars.PI;
         var _loc4_:Number = 8;
         var _loc5_:Vector.<MyLittleParticle> = GameState.particles.addParticles(param1.x,param1.y,1,papa,_loc4_ * Math.cos(_loc3_) * ud.size * _loc2_,_loc4_ * Math.sin(_loc3_) * ud.size * _loc2_);
         if(_loc5_)
         {
            for each(_loc6_ in _loc5_)
            {
               _loc6_.friction = 0.7;
            }
         }
      }
   }
}

