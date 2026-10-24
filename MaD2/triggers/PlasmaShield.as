package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PlasmaShield extends Trigger
   {
      
      public function PlasmaShield()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc8_:b2Body = null;
         var _loc9_:userData = null;
         var _loc10_:String = null;
         var _loc11_:int = 0;
         super.trigger(param1,param2);
         _loc3_ = param2.triggerPos.Copy();
         if(param2.flipped)
         {
            _loc3_.x *= -1;
         }
         _loc3_.x *= param2.triggerRadius / 30;
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc5_:Number = param2.triggerRadius * param2.size;
         var _loc6_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
         var _loc7_:Array = Body.GetAroundPoint(_loc6_,_loc5_,_loc5_,false);
         for each(_loc8_ in _loc7_)
         {
            if(_loc8_ != param1)
            {
               _loc9_ = userData(_loc8_.GetUserData());
               if(!_loc9_.hasBeenCut)
               {
                  if(!_loc9_.saveable)
                  {
                     _loc9_.dead = true;
                     _loc10_ = "forcefield";
                     if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
                     {
                        _loc10_ = param2.pfx.getParticle();
                     }
                     _loc11_ = 0;
                     while(_loc11_ < 10)
                     {
                        GameState.particles.addParticles(_loc8_.GetPosition().x * Physics.scale,_loc8_.GetPosition().y * Physics.scale,1,_loc10_,_loc8_.GetLinearVelocity().x * 0.01,_loc8_.GetLinearVelocity().y * 0.01 + 1,2,2);
                        _loc11_++;
                     }
                  }
               }
            }
         }
      }
   }
}

