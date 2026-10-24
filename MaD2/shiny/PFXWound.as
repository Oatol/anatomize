package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PFXWound extends ParticleEffect
   {
      
      public function PFXWound(param1:b2Body, param2:b2Vec2 = null)
      {
         super(param1,param2);
         applyOffset = false;
         init();
      }
      
      override public function update() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:b2Vec2 = null;
         super.update();
         for each(_loc1_ in ud.bleeding)
         {
            _loc2_ = Number(_loc1_[0].x);
            _loc3_ = Number(_loc1_[0].y);
            _loc4_ = Number(_loc1_[1].x);
            _loc5_ = Number(_loc1_[1].y);
            _loc6_ = (_loc5_ - _loc3_) / (_loc4_ - _loc2_);
            _loc7_ = _loc2_ + Math.random() * (_loc4_ - _loc2_);
            _loc8_ = _loc3_ + _loc6_ * (_loc7_ - _loc2_);
            _loc9_ = BoxUtils.rotateVec(new b2Vec2(_loc7_,_loc8_),body.GetAngle());
            addParticles((body.GetPosition().x + _loc9_.x) * Physics.scale,(body.GetPosition().y + _loc9_.y) * Physics.scale,1,"sparkle",0,0,0,0);
         }
      }
   }
}

