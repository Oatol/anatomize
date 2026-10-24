package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2JointEdge;
   import Box2D.Dynamics.Joints.b2WeldJoint;
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   
   public class Scope extends Trigger
   {
      
      protected var spreadMulti:Number = 0.5;
      
      protected var hand1:b2Vec2;
      
      protected var ray1:b2Vec2;
      
      protected var rayRange:Number;
      
      internal var gunBody:b2Body;
      
      internal var attachedFirearm:Firearm;
      
      private var origSpread:Number;
      
      protected var equipRay:Boolean = true;
      
      public function Scope()
      {
         super();
         this.hand1 = new b2Vec2(0,15 / Physics.scale);
         this.ray1 = new b2Vec2(0,25 / Physics.scale);
         this.rayRange = 4;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc7_:b2WeldJoint = null;
         super.trigger(param1,param2);
         if(!this.equipRay)
         {
            return;
         }
         if(param2.triggerState == 1)
         {
            this.OnDelete();
            return;
         }
         var _loc3_:b2Vec2 = BoxUtils.rotateVec(this.hand1,bodyAngle);
         _loc3_.Multiply(param2.size);
         _loc3_.Add(bodyCenter);
         _loc3_.Multiply(Physics.scale);
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(this.ray1,bodyAngle);
         _loc4_.Add(bodyCenter);
         _loc4_.Multiply(Physics.scale);
         var _loc5_:Array = GameState.cutter.CustomRaycast(_loc3_,this.rayRange * param2.size,_loc4_,true,"equip");
         if(_loc5_[1])
         {
            GraphicUtils.efla(Main.instance.particlesBMD,_loc3_.x + camPos.x,_loc3_.y + camPos.y,b2Vec2(_loc5_[1]).x * Physics.scale + camPos.x,b2Vec2(_loc5_[1]).y * Physics.scale + camPos.y,4294967295);
         }
         var _loc6_:b2Body = b2Body(_loc5_[0]);
         if(_loc6_)
         {
            if(_loc6_.IsStatic())
            {
               return;
            }
            if(!(userData(_loc6_.GetUserData()).trigger is Gun))
            {
               return;
            }
            _loc3_.Multiply(1 / Physics.scale);
            if(this.isSilenced(_loc6_))
            {
               return;
            }
            _loc7_ = Joints.Weld("equip",param1,_loc6_,_loc3_);
            if(_loc7_)
            {
               jointUserData(_loc7_.GetUserData()).cuttable = false;
               jointUserData(_loc7_.GetUserData()).forceLimit = 1000001;
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
            if(_loc3_.forceLimit == 1000001)
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
         if(this.isSilenced(param1))
         {
            return false;
         }
         this.gunBody = param1;
         this.attachedFirearm = Gun(userData(this.gunBody.GetUserData()).trigger).firearm;
         this.origSpread = this.attachedFirearm.scatter;
         var _loc3_:Number = ud.triggerForce * 0.01;
         if(_loc3_ < 0.2)
         {
            _loc3_ = 0.2;
         }
         this.attachedFirearm.scatter = this.origSpread * _loc3_;
         if(this.equipRay)
         {
            ud.triggered = false;
         }
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
            this.attachedFirearm.scatter = this.origSpread;
         }
      }
   }
}

