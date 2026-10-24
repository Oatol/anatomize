package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class FireworkGrenade extends Firework
   {
      
      public function FireworkGrenade()
      {
         super();
      }
      
      override protected function damage() : void
      {
         World.explode("firework",pixelCenter,ud.triggerForce,ud.triggerRadius,false,10,"normal",[body]);
         ud.trigger = new PhosphorusGrenade(0.1,false);
         ud.triggerForce = 800;
         ud.triggered = true;
         sounds.random(["thumper_explosion","disc_shoot","carbine_shoot","explosion5","explosion4","explosion3","explosion2","explosion","thunder"],body,pixelCenter,0.5);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         updateTriggerHelpers();
         if(triggerDuration > 0)
         {
            param2.triggerDuration -= TimeLord.speed;
         }
         var _loc3_:b2Vec2 = new b2Vec2(0,0);
         if(param2.triggerPos.x != 0 || param2.triggerPos.y != 0)
         {
            _loc3_ = param2.triggerPos.Copy();
            _loc3_.Multiply(param2.size);
         }
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc5_:String = "fire3";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc5_ = param2.pfx.getParticle();
         }
         GameState.particles.addParticles(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y,1,_loc5_,0,0,10,10);
         if(param2.triggerDuration <= 0)
         {
            if(!which)
            {
               which = int(Math.random() * 5);
            }
            explode(param1,param2);
         }
      }
   }
}

