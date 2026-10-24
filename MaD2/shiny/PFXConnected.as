package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PFXConnected extends ParticleEffect
   {
      
      public function PFXConnected(param1:b2Body, param2:b2Vec2 = null)
      {
         super(param1,param2);
      }
      
      override public function update() : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:b2Vec2 = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         super.update();
         var _loc1_:int = int(ud.connected.length);
         if(_loc1_ == 0)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = body.GetPosition().x;
            _loc4_ = body.GetPosition().y;
            _loc5_ = ud.connected[_loc2_].GetPosition();
            _loc6_ = _loc5_.x;
            _loc7_ = _loc5_.y;
            _loc8_ = (_loc7_ - _loc4_) / (_loc6_ - _loc3_);
            _loc9_ = _loc3_ + Math.random() * (_loc6_ - _loc3_);
            _loc10_ = _loc4_ + _loc8_ * (_loc9_ - _loc3_);
            addParticles(_loc9_ * Physics.scale,_loc10_ * Physics.scale,1,"sparkle",0,0,0,0);
            _loc2_++;
         }
      }
   }
}

