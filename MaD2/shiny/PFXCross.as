package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PFXCross extends ParticleEffect
   {
      
      public function PFXCross(param1:b2Body, param2:b2Vec2 = null)
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
         var _loc1_:Number = Math.random() * ud.width - ud.width * 0.5;
         var _loc2_:Number = Math.random() * ud.height - ud.height * 0.5;
         var _loc3_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(_loc1_,0),body.GetAngle());
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(0,_loc2_),body.GetAngle());
         addParticles(_loc3_.x + body.GetPosition().x * Physics.scale,_loc3_.y + body.GetPosition().y * Physics.scale,1,"sparkle",0,0,0,0);
         addParticles(_loc4_.x + body.GetPosition().x * Physics.scale,_loc4_.y + body.GetPosition().y * Physics.scale,1,"sparkle",0,0,0,0);
      }
   }
}

