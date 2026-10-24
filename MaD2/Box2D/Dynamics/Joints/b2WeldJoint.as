package Box2D.Dynamics.Joints
{
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Common.Math.b2Mat33;
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.Math.b2Vec3;
   import Box2D.Common.b2Settings;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2TimeStep;
   
   public class b2WeldJoint extends b2Joint
   {
      
      private var m_localAnchor1:b2Vec2 = new b2Vec2();
      
      private var m_localAnchor2:b2Vec2 = new b2Vec2();
      
      private var m_referenceAngle:Number;
      
      private var m_impulse:b2Vec3 = new b2Vec3();
      
      private var m_mass:b2Mat33 = new b2Mat33();
      
      public function b2WeldJoint(param1:b2WeldJointDef)
      {
         super(param1);
         this.m_localAnchor1.SetV(param1.localAnchorA);
         this.m_localAnchor2.SetV(param1.localAnchorB);
         this.m_referenceAngle = param1.referenceAngle;
         this.m_impulse.SetZero();
         this.m_mass = new b2Mat33();
      }
      
      override public function GetAnchor1() : b2Vec2
      {
         return m_body1.GetWorldPoint(this.m_localAnchor1);
      }
      
      override public function GetAnchor2() : b2Vec2
      {
         return m_body2.GetWorldPoint(this.m_localAnchor2);
      }
      
      override public function GetReactionForce() : b2Vec2
      {
         return new b2Vec2(m_inv_dt * this.m_impulse.x,m_inv_dt * this.m_impulse.y);
      }
      
      override public function InitVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc2_:b2Mat22 = null;
         var _loc3_:Number = NaN;
         var _loc4_:b2Body = null;
         var _loc5_:b2Body = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         m_inv_dt = param1.inv_dt;
         _loc4_ = m_body1;
         _loc5_ = m_body2;
         _loc2_ = _loc4_.m_xf.R;
         _loc6_ = this.m_localAnchor1.x - _loc4_.m_sweep.localCenter.x;
         _loc7_ = this.m_localAnchor1.y - _loc4_.m_sweep.localCenter.y;
         _loc3_ = _loc2_.col1.x * _loc6_ + _loc2_.col2.x * _loc7_;
         _loc7_ = _loc2_.col1.y * _loc6_ + _loc2_.col2.y * _loc7_;
         _loc6_ = _loc3_;
         _loc2_ = _loc5_.m_xf.R;
         _loc8_ = this.m_localAnchor2.x - _loc5_.m_sweep.localCenter.x;
         _loc9_ = this.m_localAnchor2.y - _loc5_.m_sweep.localCenter.y;
         _loc3_ = _loc2_.col1.x * _loc8_ + _loc2_.col2.x * _loc9_;
         _loc9_ = _loc2_.col1.y * _loc8_ + _loc2_.col2.y * _loc9_;
         _loc8_ = _loc3_;
         _loc10_ = _loc4_.m_invMass;
         _loc11_ = _loc5_.m_invMass;
         _loc12_ = _loc4_.m_invI;
         _loc13_ = _loc5_.m_invI;
         this.m_mass.col1.x = _loc10_ + _loc11_ + _loc7_ * _loc7_ * _loc12_ + _loc9_ * _loc9_ * _loc13_;
         this.m_mass.col2.x = -_loc7_ * _loc6_ * _loc12_ - _loc9_ * _loc8_ * _loc13_;
         this.m_mass.col3.x = -_loc7_ * _loc12_ - _loc9_ * _loc13_;
         this.m_mass.col1.y = this.m_mass.col2.x;
         this.m_mass.col2.y = _loc10_ + _loc11_ + _loc6_ * _loc6_ * _loc12_ + _loc8_ * _loc8_ * _loc13_;
         this.m_mass.col3.y = _loc6_ * _loc12_ + _loc8_ * _loc13_;
         this.m_mass.col1.z = this.m_mass.col3.x;
         this.m_mass.col2.z = this.m_mass.col3.y;
         this.m_mass.col3.z = _loc12_ + _loc13_;
         if(param1.warmStarting)
         {
            this.m_impulse.x *= param1.dtRatio;
            this.m_impulse.y *= param1.dtRatio;
            this.m_impulse.z *= param1.dtRatio;
            _loc4_.m_linearVelocity.x -= _loc10_ * this.m_impulse.x;
            _loc4_.m_linearVelocity.y -= _loc10_ * this.m_impulse.y;
            _loc4_.m_angularVelocity -= _loc12_ * (_loc6_ * this.m_impulse.y - _loc7_ * this.m_impulse.x + this.m_impulse.z);
            _loc5_.m_linearVelocity.x += _loc11_ * this.m_impulse.x;
            _loc5_.m_linearVelocity.y += _loc11_ * this.m_impulse.y;
            _loc5_.m_angularVelocity += _loc13_ * (_loc8_ * this.m_impulse.y - _loc9_ * this.m_impulse.x + this.m_impulse.z);
         }
         else
         {
            this.m_impulse.SetZero();
         }
      }
      
      override public function SolveVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc2_:b2Mat22 = null;
         var _loc3_:Number = NaN;
         var _loc4_:b2Body = m_body1;
         var _loc5_:b2Body = m_body2;
         var _loc6_:b2Vec2 = _loc4_.m_linearVelocity;
         var _loc7_:Number = _loc4_.m_angularVelocity;
         var _loc8_:b2Vec2 = _loc5_.m_linearVelocity;
         var _loc9_:Number = _loc5_.m_angularVelocity;
         var _loc10_:Number = _loc4_.m_invMass;
         var _loc11_:Number = _loc5_.m_invMass;
         var _loc12_:Number = _loc4_.m_invI;
         var _loc13_:Number = _loc5_.m_invI;
         _loc2_ = _loc4_.m_xf.R;
         var _loc14_:Number = this.m_localAnchor1.x - _loc4_.m_sweep.localCenter.x;
         var _loc15_:Number = this.m_localAnchor1.y - _loc4_.m_sweep.localCenter.y;
         _loc3_ = _loc2_.col1.x * _loc14_ + _loc2_.col2.x * _loc15_;
         _loc15_ = _loc2_.col1.y * _loc14_ + _loc2_.col2.y * _loc15_;
         _loc14_ = _loc3_;
         _loc2_ = _loc5_.m_xf.R;
         var _loc16_:Number = this.m_localAnchor2.x - _loc5_.m_sweep.localCenter.x;
         var _loc17_:Number = this.m_localAnchor2.y - _loc5_.m_sweep.localCenter.y;
         _loc3_ = _loc2_.col1.x * _loc16_ + _loc2_.col2.x * _loc17_;
         _loc17_ = _loc2_.col1.y * _loc16_ + _loc2_.col2.y * _loc17_;
         _loc16_ = _loc3_;
         var _loc18_:Number = _loc8_.x - _loc9_ * _loc17_ - _loc6_.x + _loc7_ * _loc15_;
         var _loc19_:Number = _loc8_.y + _loc9_ * _loc16_ - _loc6_.y - _loc7_ * _loc14_;
         var _loc20_:Number = _loc9_ - _loc7_;
         var _loc21_:b2Vec3 = new b2Vec3();
         this.m_mass.Solve33(_loc21_,-_loc18_,-_loc19_,-_loc20_);
         this.m_impulse.Add(_loc21_);
         _loc6_.x -= _loc10_ * _loc21_.x;
         _loc6_.y -= _loc10_ * _loc21_.y;
         _loc7_ -= _loc12_ * (_loc14_ * _loc21_.y - _loc15_ * _loc21_.x + _loc21_.z);
         _loc8_.x += _loc11_ * _loc21_.x;
         _loc8_.y += _loc11_ * _loc21_.y;
         _loc9_ += _loc13_ * (_loc16_ * _loc21_.y - _loc17_ * _loc21_.x + _loc21_.z);
         _loc4_.m_angularVelocity = _loc7_;
         _loc5_.m_angularVelocity = _loc9_;
      }
      
      override public function SolvePositionConstraints() : Boolean
      {
         var _loc1_:b2Mat22 = null;
         var _loc2_:Number = NaN;
         var _loc3_:b2Body = m_body1;
         var _loc4_:b2Body = m_body2;
         _loc1_ = _loc3_.m_xf.R;
         var _loc5_:Number = this.m_localAnchor1.x - _loc3_.m_sweep.localCenter.x;
         var _loc6_:Number = this.m_localAnchor1.y - _loc3_.m_sweep.localCenter.y;
         _loc2_ = _loc1_.col1.x * _loc5_ + _loc1_.col2.x * _loc6_;
         _loc6_ = _loc1_.col1.y * _loc5_ + _loc1_.col2.y * _loc6_;
         _loc5_ = _loc2_;
         _loc1_ = _loc4_.m_xf.R;
         var _loc7_:Number = this.m_localAnchor2.x - _loc4_.m_sweep.localCenter.x;
         var _loc8_:Number = this.m_localAnchor2.y - _loc4_.m_sweep.localCenter.y;
         _loc2_ = _loc1_.col1.x * _loc7_ + _loc1_.col2.x * _loc8_;
         _loc8_ = _loc1_.col1.y * _loc7_ + _loc1_.col2.y * _loc8_;
         _loc7_ = _loc2_;
         var _loc9_:Number = _loc3_.m_invMass;
         var _loc10_:Number = _loc4_.m_invMass;
         var _loc11_:Number = _loc3_.m_invI;
         var _loc12_:Number = _loc4_.m_invI;
         var _loc13_:Number = _loc4_.m_sweep.c.x + _loc7_ - _loc3_.m_sweep.c.x - _loc5_;
         var _loc14_:Number = _loc4_.m_sweep.c.y + _loc8_ - _loc3_.m_sweep.c.y - _loc6_;
         var _loc15_:Number = _loc4_.m_sweep.a - _loc3_.m_sweep.a - this.m_referenceAngle;
         var _loc16_:Number = 10 * b2Settings.b2_linearSlop;
         var _loc17_:Number = Math.sqrt(_loc13_ * _loc13_ + _loc14_ * _loc14_);
         var _loc18_:Number = b2Math.b2Abs(_loc15_);
         if(_loc17_ > _loc16_)
         {
            _loc11_ *= 1;
            _loc12_ *= 1;
         }
         this.m_mass.col1.x = _loc9_ + _loc10_ + _loc6_ * _loc6_ * _loc11_ + _loc8_ * _loc8_ * _loc12_;
         this.m_mass.col2.x = -_loc6_ * _loc5_ * _loc11_ - _loc8_ * _loc7_ * _loc12_;
         this.m_mass.col3.x = -_loc6_ * _loc11_ - _loc8_ * _loc12_;
         this.m_mass.col1.y = this.m_mass.col2.x;
         this.m_mass.col2.y = _loc9_ + _loc10_ + _loc5_ * _loc5_ * _loc11_ + _loc7_ * _loc7_ * _loc12_;
         this.m_mass.col3.y = _loc5_ * _loc11_ + _loc7_ * _loc12_;
         this.m_mass.col1.z = this.m_mass.col3.x;
         this.m_mass.col2.z = this.m_mass.col3.y;
         this.m_mass.col3.z = _loc11_ + _loc12_;
         var _loc19_:b2Vec3 = new b2Vec3();
         this.m_mass.Solve33(_loc19_,-_loc13_,-_loc14_,-_loc15_);
         _loc3_.m_sweep.c.x -= _loc9_ * _loc19_.x;
         _loc3_.m_sweep.c.y -= _loc9_ * _loc19_.y;
         _loc3_.m_sweep.a -= _loc11_ * (_loc5_ * _loc19_.y - _loc6_ * _loc19_.x + _loc19_.z);
         _loc4_.m_sweep.c.x += _loc10_ * _loc19_.x;
         _loc4_.m_sweep.c.y += _loc10_ * _loc19_.y;
         _loc4_.m_sweep.a += _loc12_ * (_loc7_ * _loc19_.y - _loc8_ * _loc19_.x + _loc19_.z);
         _loc3_.SynchronizeTransform();
         _loc4_.SynchronizeTransform();
         return _loc17_ <= b2Settings.b2_linearSlop && _loc18_ <= b2Settings.b2_angularSlop;
      }
   }
}

