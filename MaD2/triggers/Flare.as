package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Flare extends Trigger
   {
      
      public function Flare()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc9_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = param2.triggerPos.Copy();
         _loc3_.Multiply(param2.size);
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         _loc4_.Add(pixelCenter);
         var _loc5_:Number = 0.01 + 0.1 * Math.random();
         var _loc6_:int = Math.floor(Math.random() * 200) + 55;
         GameState.particles.addSimpleParticles(_loc4_.x,_loc4_.y,1,uint(255 << 24 | _loc6_ << 16),_loc5_,_loc5_,2,2);
         var _loc7_:String = "fire3";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc7_ = param2.pfx.getParticle();
         }
         GameState.particles.addParticles(_loc4_.x,_loc4_.y,2,_loc7_,bodyVel.x * 0.05,bodyVel.y * 0.05,bodyVel.x * 0.01,bodyVel.y * 0.01);
         var _loc8_:Array = Body.GetAroundPoint(_loc4_,param2.triggerRadius,param2.triggerRadius,false);
         for each(_loc9_ in _loc8_)
         {
            if(_loc9_ != param1)
            {
               userData(_loc9_.GetUserData()).temperature = userData(_loc9_.GetUserData()).temperature + 2 * param2.size;
            }
         }
      }
   }
}

