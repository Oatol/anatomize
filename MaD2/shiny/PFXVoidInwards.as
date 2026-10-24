package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PFXVoidInwards extends ParticleEffect
   {
      
      public function PFXVoidInwards(param1:b2Body, param2:b2Vec2 = null)
      {
         super(param1,param2);
      }
      
      override protected function init() : void
      {
         initRadius();
      }
      
      override public function update() : void
      {
         var _loc7_:MyLittleParticle = null;
         var _loc8_:Number = NaN;
         super.update();
         var _loc1_:Number = Math.random() * 360;
         var _loc2_:Number = Math.random() * radius * size;
         var _loc3_:* = Math.random() * 360;
         var _loc4_:b2Vec2 = GeneralUtils.pointOnCircle(body.GetPosition().x * Physics.scale,body.GetPosition().y * Physics.scale,_loc2_,_loc3_);
         var _loc5_:b2Vec2 = GeneralUtils.pointOnCircle(body.GetPosition().x * Physics.scale,body.GetPosition().y * Physics.scale,_loc2_ * 0.9,_loc3_ + (Math.random() > 0.5 ? 5 : -5));
         var _loc6_:Vector.<MyLittleParticle> = addParticles(_loc4_.x,_loc4_.y,1,getParticle(),(_loc5_.x - _loc4_.x) * speed,(_loc5_.y - _loc4_.y) * speed);
         if((Boolean(_loc6_)) && _loc6_.length > 0)
         {
            for each(_loc7_ in _loc6_)
            {
               _loc8_ = 155 * Math.random();
               _loc7_.colour = 4278190080 + (_loc8_ << 16 | _loc8_ << 8 | _loc8_);
               _loc7_.health = 50;
               _loc7_.friction = 0.9;
               _loc7_.wanderX = 0;
               _loc7_.wanderY = 0;
            }
         }
      }
   }
}

