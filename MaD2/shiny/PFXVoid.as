package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PFXVoid extends ParticleEffect
   {
      
      public function PFXVoid(param1:b2Body, param2:b2Vec2 = null)
      {
         super(param1,param2);
      }
      
      override protected function init() : void
      {
         initRadius();
      }
      
      override public function update() : void
      {
         super.update();
         var _loc1_:Number = Math.random() * 360;
         var _loc2_:Number = Math.random() * radius * size;
         var _loc3_:b2Vec2 = GeneralUtils.pointOnCircle(0,0,_loc2_,_loc1_);
         var _loc4_:b2Vec2 = GeneralUtils.pointOnCircle(0,0,_loc2_ * 1.5,_loc1_ - 45);
         var _loc5_:Number = (_loc3_.x - _loc4_.x) * 0.1 * speed;
         var _loc6_:Number = (_loc3_.y - _loc4_.y) * 0.1 * speed;
         addParticles(_loc3_.x + body.GetPosition().x * Physics.scale,_loc3_.y + body.GetPosition().y * Physics.scale,1,"sparkle",_loc5_,_loc6_,0,0);
      }
   }
}

