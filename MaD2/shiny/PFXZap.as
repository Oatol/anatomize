package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PFXZap extends ParticleEffect
   {
      
      internal var loopy:Number = 0;
      
      public function PFXZap(param1:b2Body, param2:b2Vec2 = null)
      {
         super(param1,param2);
         this.init();
      }
      
      override protected function init() : void
      {
         radius = 80;
      }
      
      override public function update() : void
      {
         var _loc1_:String = null;
         var _loc2_:b2Vec2 = null;
         var _loc3_:b2Vec2 = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         super.update();
         if(Math.random() < 0.96)
         {
            return;
         }
         _loc1_ = getParticle();
         if(!_loc1_)
         {
            return;
         }
         _loc2_ = body.GetPosition().Copy();
         _loc3_ = body.GetPosition().Copy();
         _loc2_.Multiply(Physics.scale);
         _loc3_.Multiply(Physics.scale);
         _loc4_ = 20 + Math.random() * radius * size;
         _loc3_.x += Math.random() * _loc4_ * 2 - _loc4_;
         _loc3_.y += Math.random() * _loc4_ * 2 - _loc4_;
         _loc5_ = 0.6;
         _loc6_ = 0.02;
         BoxUtils.randomSlopeParticles(_loc1_,_loc2_,_loc3_,12,_loc5_,_loc6_);
         _loc7_ = _loc3_.Copy();
         _loc7_.x += Math.random() * _loc4_ * 2 - _loc4_;
         _loc7_.y += Math.random() * _loc4_ * 2 - _loc4_;
         BoxUtils.randomSlopeParticles(_loc1_,_loc3_,_loc7_,8,_loc5_,_loc6_);
         _loc8_ = _loc7_.Copy();
         _loc8_.x += Math.random() * _loc4_ * 2 - _loc4_;
         _loc8_.y += Math.random() * _loc4_ * 2 - _loc4_;
         BoxUtils.randomSlopeParticles(_loc1_,_loc7_,_loc8_,6,_loc5_,_loc6_);
      }
   }
}

