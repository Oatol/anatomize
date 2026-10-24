package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2JointEdge;
   import Box2D.Dynamics.b2Body;
   
   public class PFXJoint extends ParticleEffect
   {
      
      public function PFXJoint(param1:b2Body, param2:b2Vec2 = null)
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
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         super.update();
         var _loc1_:b2JointEdge = body.GetJointList();
         while(_loc1_)
         {
            _loc2_ = _loc1_.joint.GetAnchor1().x;
            _loc3_ = _loc1_.joint.GetAnchor1().y;
            _loc4_ = _loc1_.joint.GetAnchor2().x;
            _loc5_ = _loc1_.joint.GetAnchor2().y;
            _loc6_ = (_loc5_ - _loc3_) / (_loc4_ - _loc2_);
            _loc7_ = _loc2_ + Math.random() * (_loc4_ - _loc2_);
            _loc8_ = _loc3_ + _loc6_ * (_loc7_ - _loc2_);
            addParticles(_loc7_ * Physics.scale,_loc8_ * Physics.scale,1,"sparkle",0,0,0,0);
            _loc1_ = _loc1_.next;
         }
      }
   }
}

