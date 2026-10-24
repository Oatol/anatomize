package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class APRocket extends Explode
   {
      
      internal var part:String = "fire2";
      
      internal var rotMulti:Number = 0.5;
      
      internal var flightForce:Number = 500;
      
      public function APRocket()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc13_:Array = null;
         var _loc15_:b2Body = null;
         updateTriggerHelpers();
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
         param1.ApplyForce(new b2Vec2(Math.sin(bodyAngle + _loc5_) * param1.GetMass() * this.flightForce,-Math.cos(bodyAngle + _loc5_) * param1.GetMass() * this.flightForce),bodyCenter);
         if(param2.triggerState == 0)
         {
            return;
         }
         updateTriggerHelpers();
         var _loc11_:Number = 200;
         var _loc12_:Number = 4000;
         if(param2.triggerRadius)
         {
            _loc11_ = param2.triggerRadius;
         }
         if(param2.triggerForce)
         {
            _loc12_ = param2.triggerForce;
         }
         var _loc14_:int = 0;
         while(_loc14_ < 3)
         {
            _loc13_ = Body.GetAround(param1,_loc11_,_loc11_);
            for each(_loc15_ in _loc13_)
            {
               Body.brittle(_loc15_);
            }
            _loc14_++;
         }
         super.trigger(param1,param2);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(ud.triggerContact == 0)
         {
            return true;
         }
         if(param4 < ud.triggerContact)
         {
            return true;
         }
         ud.triggerState = 1;
         ud.triggered = true;
         return true;
      }
   }
}

