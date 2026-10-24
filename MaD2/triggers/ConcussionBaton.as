package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class ConcussionBaton extends Trigger
   {
      
      public function ConcussionBaton()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(triggerDuration > 0)
         {
            ud.triggerDuration -= TimeLord.speed;
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc14_:b2Body = null;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param1.IsStatic())
         {
            return false;
         }
         if(triggerDuration > 0)
         {
            return false;
         }
         ud.triggerDuration = ud.originalTriggerDuration;
         var _loc7_:String = "poof";
         var _loc8_:String = "light";
         if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
         {
            _loc7_ = ud.pfx.getParticle();
            _loc8_ = ud.pfx.getParticle();
         }
         var _loc9_:b2Vec2 = ud.triggerPos.Copy();
         _loc9_.Multiply(ud.size);
         var _loc10_:b2Vec2 = BoxUtils.rotateVec(_loc9_,body.GetAngle());
         _loc10_.Add(pixelCenter);
         _loc10_.x += (Math.random() * ud.triggerRadius - ud.triggerRadius * 0.5) * ud.size;
         _loc10_.y += (Math.random() * ud.triggerRadius - ud.triggerRadius * 0.5) * ud.size;
         var _loc11_:int = 0;
         while(_loc11_ < 8)
         {
            GameState.particles.addParticles(_loc10_.x,_loc10_.y,4,_loc7_,bodyVel.x * 0.2,bodyVel.y * 0.2,50 * ud.size,50 * ud.size);
            GameState.particles.addParticles(_loc10_.x,_loc10_.y,2,_loc8_,bodyVel.x * 0.2,bodyVel.y * 0.2,50 * ud.size,50 * ud.size);
            _loc11_++;
         }
         sounds.play("explosion5",body,pixelCenter);
         var _loc12_:Array = Body.GetAround(body,ud.triggerRadius * ud.size,ud.triggerRadius * ud.size,false);
         var _loc13_:int = _loc12_.indexOf(body);
         if(_loc13_ != -1)
         {
            _loc12_.splice(_loc13_,1);
         }
         Shadows.lightPos = pixelCenter;
         Shadows.lightRadius = triggerRadius;
         Main.instance.drawShadowsFor(_loc12_,2);
         for each(_loc14_ in _loc12_)
         {
            if(userData(_loc14_.GetUserData()).alive)
            {
               userData(_loc14_.GetUserData()).trigger = new Concussion(1200,userData(_loc14_.GetUserData()).name == "doll_head");
               userData(_loc14_.GetUserData()).triggered = true;
            }
         }
         return true;
      }
   }
}

