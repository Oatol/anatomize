package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PFXCorners extends ParticleEffect
   {
      
      public function PFXCorners(param1:b2Body, param2:b2Vec2 = null)
      {
         super(param1,param2);
         this.init();
         applyOffset = false;
      }
      
      override protected function init() : void
      {
         initHull();
      }
      
      override public function update() : void
      {
         super.update();
         var _loc1_:int = int(Math.random() * hull.length);
         var _loc2_:int = _loc1_ + 1;
         if(_loc2_ >= hull.length)
         {
            _loc2_ = 0;
         }
         var _loc3_:Number = Number(hull[_loc1_].x);
         var _loc4_:Number = Number(hull[_loc1_].y);
         var _loc5_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(_loc3_,_loc4_),body.GetAngle());
         addParticles(_loc5_.x + body.GetPosition().x * Physics.scale,_loc5_.y + body.GetPosition().y * Physics.scale,1,"sparkle",0,0,0,0);
      }
   }
}

