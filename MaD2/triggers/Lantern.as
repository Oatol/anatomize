package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Lantern extends Trigger
   {
      
      internal var particles:Boolean = true;
      
      public function Lantern(param1:Boolean = true)
      {
         super();
         this.particles = param1;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc13_:String = null;
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = pixelCenter.Copy();
         var _loc4_:Number = 1;
         if(param2.flipped)
         {
            _loc4_ = -1;
         }
         var _loc5_:b2Vec2 = BoxUtils.rotateVec(triggerPos,bodyAngle * _loc4_);
         _loc5_.Multiply(param2.size);
         _loc3_.y += _loc5_.y;
         if(param2.flipped)
         {
            _loc3_.x -= _loc5_.x;
         }
         else
         {
            _loc3_.x += _loc5_.x;
         }
         Shadows.lightPos = _loc3_;
         Shadows.lightRadius = param2.triggerRadius;
         Main.instance.drawShadowsFor(Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size),2);
         if(!this.particles)
         {
            return;
         }
         var _loc6_:Number = Math.cos(bodyAngle + Math.PI * 0.5);
         var _loc7_:Number = Math.sin(bodyAngle + Math.PI * 0.5);
         var _loc8_:Number = bodyCenter.x * Physics.scale;
         var _loc9_:Number = bodyCenter.y * Physics.scale;
         var _loc10_:b2Vec2 = new b2Vec2(1 * param2.size,6 * param2.size);
         var _loc11_:b2Vec2 = BoxUtils.rotateVec(_loc10_,bodyAngle);
         var _loc12_:b2Vec2 = new b2Vec2(_loc8_ + _loc11_.x,_loc9_ + _loc11_.y);
         if(Math.random() > 0.5)
         {
            _loc13_ = "fire2";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc13_ = param2.pfx.getParticle();
            }
            GameState.particles.addParticles(_loc12_.x,_loc12_.y,1,_loc13_,bodyVel.x * 0.1,bodyVel.y * 0.1 + 1,0,0);
         }
      }
   }
}

