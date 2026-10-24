package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DeathGrenade extends Trigger
   {
      
      public function DeathGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Body = null;
         var _loc6_:userData = null;
         var _loc7_:int = 0;
         var _loc8_:b2Vec2 = null;
         var _loc9_:b2Vec2 = null;
         var _loc10_:Number = NaN;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         super.trigger(param1,param2);
         var _loc3_:Number = param2.triggerRadius * param2.size;
         var _loc4_:Array = Body.GetAround(param1,_loc3_,_loc3_,false);
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = userData(_loc5_.GetUserData());
            if(_loc6_.alive)
            {
               _loc6_.health = 0;
               _loc7_ = _loc6_.maxhealth * 0.1 >> 0;
               _loc8_ = pixelCenter.Copy();
               _loc9_ = _loc5_.GetWorldCenter().Copy();
               _loc9_.Multiply(Physics.scale);
               _loc10_ = (_loc9_.y - pixelCenter.y) / (_loc9_.x - pixelCenter.x);
               _loc11_ = 0;
               while(_loc11_ < 20)
               {
                  _loc12_ = "blood";
                  if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
                  {
                     _loc12_ = param2.pfx.getParticle();
                  }
                  _loc13_ = _loc8_.x + _loc11_ / 20 * (_loc9_.x - _loc8_.x);
                  _loc14_ = _loc8_.y + _loc10_ * (_loc13_ - _loc8_.x);
                  GameState.particles.addParticles(_loc13_,_loc14_,1,_loc12_,(_loc8_.x - _loc13_) * 0.03,(_loc8_.y - _loc14_) * 0.03,2,2);
                  _loc11_++;
               }
            }
         }
         Body.Disintegrate(param1,"dark",100,4,4);
      }
   }
}

