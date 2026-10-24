package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PFXOutline extends ParticleEffect
   {
      
      public function PFXOutline(param1:b2Body, param2:b2Vec2 = null)
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
         super.update();
         var _loc1_:int = int(Math.random() * hull.length);
         var _loc2_:int = _loc1_ + 1;
         if(_loc2_ >= hull.length)
         {
            _loc2_ = 0;
         }
         var _loc3_:Number = Number(hull[_loc1_].x);
         var _loc4_:Number = Number(hull[_loc2_].x);
         var _loc5_:Number = Number(hull[_loc1_].y);
         var _loc6_:Number = Number(hull[_loc2_].y);
         var _loc7_:b2Vec2 = new b2Vec2(_loc3_ - Math.random() * (_loc3_ - _loc4_),_loc5_ - Math.random() * (_loc5_ - _loc6_));
         _loc7_ = BoxUtils.rotateVec(_loc7_,body.GetAngle());
         addParticles(_loc7_.x + body.GetPosition().x * Physics.scale,_loc7_.y + body.GetPosition().y * Physics.scale,1,"sparkle",0,0,0,0);
      }
   }
}

