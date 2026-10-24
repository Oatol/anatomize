package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2JointEdge;
   import Box2D.Dynamics.b2Body;
   
   public class PFXJointAnchor extends ParticleEffect
   {
      
      public function PFXJointAnchor(param1:b2Body, param2:b2Vec2 = null)
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
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         super.update();
         var _loc1_:b2JointEdge = body.GetJointList();
         while(_loc1_)
         {
            _loc2_ = _loc1_.joint.GetAnchor1().x;
            _loc3_ = _loc1_.joint.GetAnchor1().y;
            addParticles(_loc2_ * Physics.scale,_loc3_ * Physics.scale,1,"sparkle",0,0,1,1);
            _loc1_ = _loc1_.next;
         }
      }
   }
}

