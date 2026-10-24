package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PFXRadius extends ParticleEffect
   {
      
      public function PFXRadius(param1:b2Body, param2:b2Vec2 = null)
      {
         super(param1,param2);
         this.init();
      }
      
      override protected function init() : void
      {
         if(!ud.triggerRadius)
         {
            ud.pfx = null;
         }
      }
      
      override public function update() : void
      {
         super.update();
         var _loc1_:b2Vec2 = new b2Vec2();
         if(ud.triggerPos)
         {
            _loc1_ = BoxUtils.rotateVec(new b2Vec2(ud.triggerPos.x * ud.size * (ud.flipped ? -1 : 1),ud.triggerPos.y * ud.size),body.GetAngle());
         }
         var _loc2_:b2Vec2 = GeneralUtils.pointOnCircle(_loc1_.x,_loc1_.y,ud.triggerRadius * ud.size,Math.random() * 360);
         addParticles(_loc2_.x + body.GetPosition().x * Physics.scale,_loc2_.y + body.GetPosition().y * Physics.scale,1,"sparkle",0,0,0,0);
      }
   }
}

