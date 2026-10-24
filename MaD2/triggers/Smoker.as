package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Smoker extends Trigger
   {
      
      internal var amount:Number = 0.5;
      
      public function Smoker(param1:Number = 0.5)
      {
         super();
         this.amount = param1;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:int = 0;
         var _loc4_:b2Vec2 = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:String = null;
         super.trigger(param1,param2);
         if(Math.random() < this.amount)
         {
            _loc3_ = 0;
            while(_loc3_ < this.amount)
            {
               _loc4_ = param2.triggerPos.Copy();
               _loc4_.Multiply(param2.size);
               if(param2.flipped)
               {
                  _loc4_.x *= -1;
               }
               _loc5_ = BoxUtils.rotateVec(_loc4_,bodyAngle);
               _loc5_.Add(pixelCenter);
               _loc5_.x += (Math.random() * param2.triggerRadius - param2.triggerRadius * 0.5) * param2.size;
               _loc5_.y += (Math.random() * param2.triggerRadius - param2.triggerRadius * 0.5) * param2.size;
               _loc6_ = "smoke";
               if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
               {
                  _loc6_ = param2.pfx.getParticle();
               }
               GameState.particles.addParticles(_loc5_.x,_loc5_.y,1,_loc6_,bodyVel.x * 0.2,bodyVel.y * 0.2,1,1);
               _loc3_++;
            }
         }
      }
   }
}

