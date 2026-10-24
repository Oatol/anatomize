package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class DecoyGrenade extends Trigger
   {
      
      internal var pepes:Array = ["blood","explosive","portal1","portal2","gas","smoke","fire2","fire3","poof","forcefield","sparkle","crystal","bees","heal","air","shock","shock2","trailblazer","water","void","dark","light","bubbles","decoration","gravity","poison","slice","snare","gasoline","laser","sleep","bigSmoke","acid","hail","petrify"];
      
      internal var soundArr:Array = ["explosion","explosion2","explosion3","explosion4","explosion5"];
      
      public function DecoyGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:b2Vec2 = null;
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         param2.triggerForce += TimeLord.speed;
         if(triggerForce > 10)
         {
            param2.triggerForce = 0;
            if(triggerDuration <= 0)
            {
               param2.dead = true;
            }
            _loc3_ = this.pepes[int(Math.random() * this.pepes.length)];
            _loc4_ = 0;
            while(_loc4_ < 36)
            {
               _loc5_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,(20 + Math.random() * 20) * param2.size,_loc4_ * 10);
               GameState.particles.addParticles(_loc5_.x,_loc5_.y,1,_loc3_,(-pixelCenter.x + _loc5_.x) * Math.random(),(-pixelCenter.y + _loc5_.y) * Math.random(),1,1);
               _loc4_++;
            }
            sounds.random(this.soundArr,param1,pixelCenter,0.4 + Math.random() * 0.4);
         }
      }
   }
}

