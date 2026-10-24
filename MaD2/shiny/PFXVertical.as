package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PFXVertical extends ParticleEffect
   {
      
      public function PFXVertical(param1:b2Body, param2:b2Vec2 = null)
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
         var _loc1_:Number = Math.random() * ud.height - ud.height * 0.5;
         var _loc2_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(0,_loc1_),body.GetAngle());
         addParticles(_loc2_.x + body.GetPosition().x * Physics.scale,_loc2_.y + body.GetPosition().y * Physics.scale,1,"sparkle",0,0,0,0);
      }
   }
}

