package powers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PowerForcefield extends Power
   {
      
      internal var bubbleBodies:Array;
      
      internal var first:Boolean = true;
      
      public function PowerForcefield()
      {
         super(Tool.TEST,"forcefield");
         this.bubbleBodies = [];
         noThrow = true;
         noEffectForce = false;
      }
      
      override public function Press(param1:b2Vec2, param2:b2Vec2) : void
      {
         var _loc5_:b2Body = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:b2Vec2 = null;
         var _loc10_:b2Vec2 = null;
         super.Press(param1,param2);
         var _loc3_:Number = Tweak.toolRadius;
         var _loc4_:Array = Body.GetAroundPoint(param1,_loc3_,_loc3_,false);
         if(this.first && this.bubbleBodies.length == 0)
         {
            this.bubbleBodies = _loc4_.slice();
         }
         this.first = false;
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = new b2Vec2(-_loc5_.GetWorldCenter().x * Physics.scale + param1.x,-_loc5_.GetWorldCenter().y * Physics.scale + param1.y);
            _loc7_ = _loc6_.Normalize();
            _loc8_ = 10 * Tweak.toolEffectForce / ((_loc3_ - _loc7_) / _loc3_);
            if(_loc8_ > 0)
            {
               _loc8_ *= -1;
            }
            if(this.bubbleBodies.indexOf(_loc5_) != -1)
            {
               _loc8_ *= -1;
               _loc10_ = _loc5_.GetWorldCenter().Copy();
               _loc10_.Multiply(Physics.scale);
               GameState.particles.addParticles(_loc10_.x,_loc10_.y,1,particle,(-_loc10_.x + param1.x) * 0.08,(-_loc10_.y + param1.y) * 0.08,1,1);
            }
            _loc9_ = new b2Vec2(_loc6_.x * _loc8_,_loc6_.y * _loc8_);
            _loc5_.GetLinearVelocity().Multiply(0.9);
            _loc5_.SetAngularVelocity(_loc5_.GetAngularVelocity() * 0.9);
            _loc5_.ApplyForce(_loc9_,_loc5_.GetWorldCenter());
         }
      }
      
      override public function Release() : void
      {
         super.Release();
         this.bubbleBodies = [];
         this.first = true;
      }
      
      override public function Particles(param1:b2Vec2, param2:b2Vec2) : void
      {
         var _loc5_:b2Vec2 = null;
         particleRadius = Tweak.toolRadius;
         var _loc3_:b2Vec2 = GeneralUtils.pointOnCircle(param1.x,param1.y,Math.random() * particleRadius,Math.random() * 360);
         GameState.particles.addParticles(_loc3_.x,_loc3_.y,1,particle,(-param1.x + _loc3_.x) * 0.08,(-param1.y + _loc3_.y) * 0.08,1,1);
         var _loc4_:int = 0;
         while(_loc4_ < 4)
         {
            _loc5_ = GeneralUtils.pointOnCircle(param1.x,param1.y,particleRadius,Math.random() * 360);
            GameState.particles.addParticles(_loc5_.x,_loc5_.y,1,particle,(-param1.x + _loc5_.x) * 0.01,(-param1.y + _loc5_.y) * 0.01,1,1);
            _loc4_++;
         }
      }
   }
}

