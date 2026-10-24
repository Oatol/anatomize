package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ArmsCrate extends Trigger
   {
      
      private var burnPos:b2Vec2;
      
      internal var gifts:* = R.firearms;
      
      public function ArmsCrate()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = param2.triggerPos.Copy();
         _loc3_.Multiply(param2.size);
         this.burnPos = BoxUtils.rotateVec(_loc3_,bodyAngle);
         this.burnPos.Add(pixelCenter);
         var _loc4_:String = "shock";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc4_ = param2.pfx.getParticle();
         }
         var _loc5_:b2Vec2 = GeneralUtils.pointOnCircle(this.burnPos.x,this.burnPos.y,36,Math.random() * 360);
         GameState.particles.addParticles(_loc5_.x,_loc5_.y,1,_loc4_,(this.burnPos.x - _loc5_.x) * 0.1,(this.burnPos.y - _loc5_.y) * 0.1,0.1,0.1);
         param2.triggerDuration -= TimeLord.timerSpeed;
         if(param2.triggerDuration <= 0)
         {
            param2.triggerDuration = param2.originalTriggerDuration;
            param2.triggered = false;
            this.spawn();
         }
      }
      
      private function spawn() : *
      {
         var _loc1_:b2Body = GameState.objects.spawnObject(this.gifts[int(Math.random() * this.gifts.length)],this.burnPos.x,this.burnPos.y,bodyAngle * Vars.toDegrees,Math.random() > 0.5,true);
         var _loc2_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(0,-ud.triggerForce * _loc1_.GetMass() * 2),bodyAngle);
         _loc1_.ApplyForce(_loc2_,_loc1_.GetWorldCenter());
      }
   }
}

