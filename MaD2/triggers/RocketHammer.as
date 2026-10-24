package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class RocketHammer extends Trigger
   {
      
      internal var part:String;
      
      public function RocketHammer(param1:String = "fire2")
      {
         super();
         this.part = param1;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:Number = NaN;
         super.trigger(param1,param2);
         var _loc3_:Number = bodyCenter.x * Physics.scale;
         var _loc4_:Number = bodyCenter.y * Physics.scale;
         var _loc5_:Number = Math.PI * 0.5;
         if(param2.flipped)
         {
            _loc5_ *= -1;
         }
         var _loc6_:int = 0;
         while(_loc6_ < 20 * TimeLord.speed)
         {
            _loc7_ = BoxUtils.rotateVec(new b2Vec2((param2.flipped ? 40 : -40) * param2.size,(-50 + Math.random() * 70) * param2.size),bodyAngle);
            _loc8_ = new b2Vec2(_loc3_ + _loc7_.x,_loc4_ + _loc7_.y);
            _loc9_ = bodyAngle;
            if(param2.flipped)
            {
               _loc9_ += Math.PI;
            }
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               this.part = param2.pfx.getParticle();
            }
            GameState.particles.addParticles(_loc8_.x,_loc8_.y,1,this.part,-10 * Math.cos(_loc9_),-10 * Math.sin(_loc9_),2,2);
            _loc6_++;
         }
         param1.ApplyImpulse(new b2Vec2(Math.sin(bodyAngle + _loc5_) * param1.GetMass() * triggerForce,-Math.cos(bodyAngle + _loc5_) * param1.GetMass() * triggerForce),bodyCenter);
         param2.triggered = false;
      }
   }
}

