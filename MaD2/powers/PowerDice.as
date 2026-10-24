package powers
{
   import Box2D.Common.Math.b2Vec2;
   
   public class PowerDice extends Power
   {
      
      public function PowerDice()
      {
         super(Tool.DICE,"slice");
         noThrow = true;
         noEffectRadius = false;
         noPressRadius = true;
      }
      
      override public function Press(param1:b2Vec2, param2:b2Vec2) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:b2Vec2 = null;
         var _loc5_:Number = NaN;
         super.Press(param1,param2);
         var _loc6_:Number = Tweak.toolEffectRadius;
         if(_loc6_ > 80)
         {
            _loc6_ = 80;
         }
         var _loc7_:* = 10;
         _loc5_ = _loc6_ * _loc7_ * 0.5;
         var _loc8_:Number = _loc6_ * 0.5;
         var _loc9_:Number = param1.x - _loc8_ * 5;
         var _loc10_:Number = param1.y - _loc8_ * 5;
         var _loc11_:int = Math.random() * _loc7_;
         var _loc12_:int = Math.random() * _loc7_;
         _loc3_ = new b2Vec2(_loc9_ + _loc12_ * _loc8_,_loc10_);
         _loc4_ = new b2Vec2(_loc9_ + _loc12_ * _loc8_,_loc10_ + _loc7_);
         GameState.madeby = "dicepower";
         GameState.cutter.CustomCut(_loc3_,_loc4_,1,_loc5_,0);
         GameState.particles.addParticles(_loc3_.x,Math.random() * _loc5_ + _loc3_.y,1,particle,0,0,0,15);
         _loc3_ = new b2Vec2(_loc9_,_loc10_ + _loc11_ * _loc8_);
         _loc4_ = new b2Vec2(_loc9_ + _loc7_,_loc10_ + _loc11_ * _loc8_);
         GameState.madeby = "dicepower";
         GameState.cutter.CustomCut(_loc3_,_loc4_,1,_loc5_,0);
         GameState.particles.addParticles(Math.random() * _loc5_ + _loc3_.x,_loc3_.y,1,particle,0,0,15,0);
      }
      
      override protected function AddParticles(param1:b2Vec2, param2:b2Vec2) : void
      {
      }
   }
}

