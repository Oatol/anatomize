package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class MaimArrow extends Trigger
   {
      
      public function MaimArrow()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(triggerState == 1)
         {
            this.Effect();
            ud.triggerState = 0;
            return;
         }
         var _loc3_:Number = Math.PI * 0.5;
         if(ud.flipped)
         {
            _loc3_ *= -1;
         }
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2((ud.flipped ? -30 : 30) * ud.size,0),bodyAngle);
         var _loc5_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
         var _loc6_:Number = bodyAngle;
         if(ud.flipped)
         {
            _loc6_ -= Math.PI;
         }
         body.ApplyForce(new b2Vec2(Math.sin(bodyAngle + _loc3_) * body.GetMass() * triggerForce,-Math.cos(bodyAngle + _loc3_) * body.GetMass() * triggerForce),bodyCenter);
      }
      
      public function Effect() : void
      {
         body.SetLinearVelocity(new b2Vec2());
         body.SetAngularVelocity(0);
         var _loc1_:b2Vec2 = new b2Vec2(Math.random() * 800 / Physics.scale,Math.random() * 600 / Physics.scale);
         var _loc2_:int = 0;
         while(_loc2_ < 8)
         {
            GameState.particles.addParticles(_loc1_.x * Physics.scale,_loc1_.y * Physics.scale,1,"void",0,0,4,4);
            _loc2_++;
         }
         body.SetXForm(_loc1_,Math.random() * Math.PI * 2);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(!userData(param1.GetUserData()).alive)
         {
            ud.triggerState = 1;
         }
         else
         {
            if(ud.connected.indexOf(param1) != -1)
            {
               ud.triggerState = 1;
               return false;
            }
            ud.trigger = new TempProjectile(20);
            ud.triggered = true;
         }
         return true;
      }
   }
}

