package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2JointEdge;
   import Box2D.Dynamics.Joints.b2WeldJoint;
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   
   public class WeaponMount extends Trigger
   {
      
      protected var recoilMulti:Number = 0.5;
      
      internal var gunBody:b2Body;
      
      internal var attachedFirearm:Firearm;
      
      private var origRecoil:Number;
      
      protected var hand1:b2Vec2;
      
      protected var ray1:b2Vec2;
      
      protected var rayRange:Number;
      
      public function WeaponMount()
      {
         super();
         this.hand1 = new b2Vec2(0,-17 / Physics.scale);
         this.ray1 = new b2Vec2(0,-27 / Physics.scale);
         this.rayRange = 4;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc8_:b2WeldJoint = null;
         super.trigger(param1,param2);
         if(param2.triggerState == 1)
         {
            this.OnDelete();
            return;
         }
         var _loc3_:int = 1;
         if(param2.flipped)
         {
            _loc3_ = -1;
         }
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(this.hand1.x * param2.size * _loc3_,this.hand1.y * param2.size),bodyAngle);
         _loc4_.Add(bodyCenter);
         _loc4_.Multiply(Physics.scale);
         var _loc5_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(this.ray1.x * param2.size * _loc3_,this.ray1.y * param2.size),bodyAngle);
         _loc5_.Add(bodyCenter);
         _loc5_.Multiply(Physics.scale);
         var _loc6_:Array = GameState.cutter.CustomRaycast(_loc4_,this.rayRange * param2.size,_loc5_,true,"equip");
         if(_loc6_[1])
         {
            GraphicUtils.efla(Main.instance.particlesBMD,_loc4_.x + camPos.x,_loc4_.y + camPos.y,b2Vec2(_loc6_[1]).x * Physics.scale + camPos.x,b2Vec2(_loc6_[1]).y * Physics.scale + camPos.y,4294967295);
         }
         var _loc7_:b2Body = b2Body(_loc6_[0]);
         if(_loc7_)
         {
            if(_loc7_.IsStatic())
            {
               return;
            }
            if(!(userData(_loc7_.GetUserData()).trigger is Gun))
            {
               return;
            }
            _loc4_.Multiply(1 / Physics.scale);
            _loc8_ = Joints.Weld("equip",param1,_loc7_,_loc4_);
            if(_loc8_)
            {
               jointUserData(_loc8_.GetUserData()).cuttable = false;
               jointUserData(_loc8_.GetUserData()).forceLimit = 1000002;
            }
         }
      }
      
      private function isSilenced(param1:b2Body) : Boolean
      {
         var _loc3_:jointUserData = null;
         var _loc2_:b2JointEdge = param1.GetJointList();
         while(_loc2_)
         {
            _loc3_ = jointUserData(_loc2_.joint.GetUserData());
            if(_loc3_.forceLimit == 1000002)
            {
               return true;
            }
            _loc2_ = _loc2_.next;
         }
         return false;
      }
      
      override public function OnJoint(param1:b2Body, param2:String) : Boolean
      {
         if(param2 != "weldjoint" && param2 != "equip")
         {
            return true;
         }
         if(param1.IsStatic())
         {
            return false;
         }
         if(!(userData(param1.GetUserData()).trigger is Gun))
         {
            return true;
         }
         this.gunBody = param1;
         this.attachedFirearm = Gun(userData(this.gunBody.GetUserData()).trigger).firearm;
         this.origRecoil = this.attachedFirearm.recoil;
         var _loc3_:Number = ud.triggerForce * 0.01;
         this.attachedFirearm.recoil = this.origRecoil * _loc3_;
         ud.triggered = false;
         ud.triggerState = 1;
         return true;
      }
      
      override public function OnDelete() : void
      {
         super.OnDelete();
         Body.RemoveJointsNextFrame(body);
         ud.triggerState = 0;
         ud.triggered = false;
         if(this.gunBody)
         {
            this.attachedFirearm.recoil = this.origRecoil;
         }
      }
   }
}

