package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PFXInwards extends ParticleEffect
   {
      
      public function PFXInwards(param1:b2Body, param2:b2Vec2 = null)
      {
         super(param1,param2);
         this.init();
      }
      
      override protected function init() : void
      {
         initHull();
      }
      
      override public function update() : void
      {
         var _loc5_:b2Vec2 = null;
         super.update();
         var _loc1_:int = int(Math.random() * hull.length);
         var _loc2_:int = _loc1_ + 1;
         if(_loc2_ >= hull.length)
         {
            _loc2_ = 0;
         }
         var _loc3_:Number = Number(hull[_loc1_].x);
         var _loc4_:Number = Number(hull[_loc1_].y);
         _loc5_ = BoxUtils.rotateVec(new b2Vec2(_loc3_ * size,_loc4_ * size),body.GetAngle());
         _loc5_.x += body.GetPosition().x * Physics.scale;
         _loc5_.y += body.GetPosition().y * Physics.scale;
         var _loc6_:Number = (_loc5_.x - body.GetPosition().x * Physics.scale) * -0.1 * speed;
         var _loc7_:Number = (_loc5_.y - body.GetPosition().y * Physics.scale) * -0.1 * speed;
         addParticles(_loc5_.x,_loc5_.y,1,"sparkle",_loc6_,_loc7_,0,0);
      }
   }
}

