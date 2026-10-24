package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PlasmaBall extends Trigger
   {
      
      public function PlasmaBall()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc8_:Array = null;
         var _loc9_:b2Body = null;
         var _loc10_:userData = null;
         var _loc11_:b2Vec2 = null;
         var _loc12_:b2Vec2 = null;
         var _loc13_:Number = NaN;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = param2.triggerPos.Copy();
         _loc3_.Multiply(param2.size);
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         _loc4_.Add(pixelCenter);
         var _loc5_:Number = param2.triggerRadius / Physics.scale * param2.size;
         var _loc6_:String = "shock2";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc6_ = param2.pfx.getParticle();
         }
         if(Math.random() > 0.95)
         {
            _loc8_ = Body.GetMultiple(new b2Vec2(_loc4_.x / Physics.scale - _loc5_ * 0.5,_loc4_.y / Physics.scale - _loc5_ * 0.5),_loc5_,_loc5_,false);
            _loc9_ = _loc8_[Math.random() * _loc8_.length >> 0];
            if((Boolean(_loc9_)) && _loc9_ != param1)
            {
               _loc10_ = userData(_loc9_.GetUserData());
               _loc10_.trigger = new Electrified();
               _loc10_.triggered = true;
               _loc10_.triggerDuration = 4;
               _loc11_ = GeneralUtils.pointOnCircle(_loc4_.x,_loc4_.y,20 * param2.size,Math.random() * 360);
               _loc12_ = _loc9_.GetWorldCenter().Copy();
               _loc12_.Multiply(Physics.scale);
               _loc13_ = (_loc12_.y - _loc4_.y) / (_loc12_.x - _loc4_.x);
               _loc14_ = 1;
               _loc15_ = 0;
               while(_loc15_ < 20 * _loc14_)
               {
                  _loc16_ = _loc11_.x + _loc15_ / (20 * _loc14_) * (_loc12_.x - _loc11_.x);
                  _loc17_ = _loc11_.y + _loc13_ * (_loc16_ - _loc11_.x);
                  GameState.particles.addParticles(_loc16_,_loc17_,1,_loc6_,(-_loc11_.x + _loc16_) * 0.05,(-_loc11_.y + _loc17_) * 0.05,2 * _loc14_,2 * _loc14_);
                  _loc15_++;
               }
            }
         }
         var _loc7_:b2Vec2 = GeneralUtils.pointOnCircle(_loc4_.x,_loc4_.y,5 * param2.size,Math.random() * 360);
         GameState.particles.addParticles(_loc7_.x,_loc7_.y,1,_loc6_,(-_loc4_.x + _loc7_.x) * 0.2 + bodyVel.x * 0.1,(-_loc4_.y + _loc7_.y) * 0.2 + bodyVel.y * 0.1,0,0);
      }
   }
}

