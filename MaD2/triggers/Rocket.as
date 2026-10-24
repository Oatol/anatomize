package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Rocket extends Trigger
   {
      
      internal var part:String;
      
      internal var rotMulti:Number;
      
      public function Rocket(param1:String = "fire3", param2:Number = 0.5)
      {
         super();
         this.part = param1;
         this.rotMulti = param2;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         param1.WakeUp();
         var _loc3_:Number = bodyCenter.x * Physics.scale;
         var _loc4_:Number = bodyCenter.y * Physics.scale;
         var _loc5_:Number = -Math.PI * this.rotMulti;
         if(param2.flipped)
         {
            _loc5_ *= -1;
         }
         var _loc6_:Number = param2.triggerPos.x;
         var _loc7_:Number = param2.triggerPos.y;
         var _loc8_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2((param2.flipped ? -_loc6_ : _loc6_) * param2.size,_loc7_ * param2.size),bodyAngle);
         var _loc9_:b2Vec2 = new b2Vec2(_loc3_ + _loc8_.x,_loc4_ + _loc8_.y);
         var _loc10_:Number = bodyAngle + _loc5_ + Math.PI * 0.5;
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            this.part = param2.pfx.getParticle();
         }
         GameState.particles.addParticles(_loc9_.x,_loc9_.y,1,this.part,10 * Math.cos(_loc10_),10 * Math.sin(_loc10_),2,2);
         param1.ApplyForce(new b2Vec2(Math.sin(bodyAngle + _loc5_) * param1.GetMass() * triggerForce,-Math.cos(bodyAngle + _loc5_) * param1.GetMass() * triggerForce),bodyCenter);
      }
   }
}

