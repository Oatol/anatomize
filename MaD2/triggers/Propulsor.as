package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Propulsor extends Trigger
   {
      
      public function Propulsor()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc12_:String = null;
         super.trigger(param1,param2);
         var _loc3_:Number = bodyCenter.x * Physics.scale;
         var _loc4_:Number = bodyCenter.y * Physics.scale;
         var _loc5_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(0,-15 * param2.size),bodyAngle);
         var _loc6_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(0,-20 * param2.size),bodyAngle);
         var _loc7_:b2Vec2 = new b2Vec2(_loc3_ + _loc5_.x,_loc4_ + _loc5_.y);
         var _loc8_:b2Vec2 = new b2Vec2(_loc3_ + _loc6_.x,_loc4_ + _loc6_.y);
         var _loc9_:Number = bodyAngle + Vars.PI * 0.5;
         var _loc10_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(0,-30 * param2.size),bodyAngle);
         var _loc11_:int = 0;
         while(_loc11_ < 4)
         {
            _loc12_ = "forcefield";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc12_ = param2.pfx.getParticle();
            }
            GameState.particles.addParticles(_loc7_.x,_loc7_.y,1,_loc12_,_loc11_ * -1 * Math.cos(_loc9_),_loc11_ * -1 * Math.sin(_loc9_),3,3);
            _loc11_++;
         }
         param1.WakeUp();
         param1.ApplyForce(new b2Vec2(Math.sin(bodyAngle) * param1.GetMass() * -triggerForce,-Math.cos(bodyAngle) * param1.GetMass() * -triggerForce),bodyCenter);
         if(param2.triggerState == 1)
         {
            param2.triggered = false;
         }
      }
   }
}

