package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class JetPack extends Trigger
   {
      
      internal var part:String;
      
      public function JetPack(param1:String = "fire2")
      {
         super();
         this.part = param1;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         param1.WakeUp();
         var _loc3_:Number = bodyCenter.x * Physics.scale;
         var _loc4_:Number = bodyCenter.y * Physics.scale;
         var _loc5_:Number = 0;
         if(param2.flipped)
         {
            _loc5_ *= -1;
         }
         var _loc6_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2((Math.random() > 0.5 ? param2.triggerPos.x : -param2.triggerPos.x) * param2.size,param2.triggerPos.y * param2.size),bodyAngle);
         var _loc7_:b2Vec2 = new b2Vec2(_loc3_ + _loc6_.x,_loc4_ + _loc6_.y);
         var _loc8_:Number = bodyAngle - Math.PI * 0.5;
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            this.part = param2.pfx.getParticle();
         }
         GameState.particles.addParticles(_loc7_.x,_loc7_.y,1,this.part,-10 * Math.cos(_loc8_),-10 * Math.sin(_loc8_),2,2);
         param1.WakeUp();
         param1.ApplyForce(new b2Vec2(Math.sin(bodyAngle + _loc5_) * param1.GetMass() * triggerForce,-Math.cos(bodyAngle + _loc5_) * param1.GetMass() * triggerForce),bodyCenter);
      }
   }
}

