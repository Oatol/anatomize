package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2JointEdge;
   import Box2D.Dynamics.Joints.b2WeldJoint;
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   
   public class BarrelAttachment extends Trigger
   {
      
      protected var attachedFirearm:Firearm;
      
      internal var attachedBody:b2Body;
      
      internal var origBarrel:b2Vec2;
      
      protected var rayFrom:b2Vec2;
      
      protected var rayTo:b2Vec2;
      
      protected var rayRange:Number;
      
      protected var barrelX:Number;
      
      protected var barrelY:Number = 0;
      
      protected var attachX:Number;
      
      protected var attachY:Number = 0;
      
      public function BarrelAttachment()
      {
         super();
         this.barrelX = 40;
         this.attachX = 0;
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
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(this.rayFrom.x * param2.size * _loc3_,this.rayFrom.y * param2.size),bodyAngle);
         _loc4_.Add(bodyCenter);
         _loc4_.Multiply(Physics.scale);
         var _loc5_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(this.rayTo.x * param2.size * _loc3_,this.rayTo.y * param2.size),bodyAngle);
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
            if(this.isSilenced(_loc7_))
            {
               return;
            }
            if(!(userData(_loc7_.GetUserData()).trigger is Gun))
            {
               return;
            }
            if(Gun(userData(_loc7_.GetUserData()).trigger).firearm.allowBarrelAttachments == false)
            {
               return;
            }
            _loc8_ = Joints.Weld("equip",param1,_loc7_,null);
            if(_loc8_)
            {
               jointUserData(_loc8_.GetUserData()).cuttable = false;
               jointUserData(_loc8_.GetUserData()).forceLimit = 1000000;
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
            if(_loc3_.forceLimit == 1000000)
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
         if(Gun(userData(param1.GetUserData()).trigger).firearm.allowBarrelAttachments == false)
         {
            return true;
         }
         if(this.isSilenced(param1))
         {
            return false;
         }
         this.Attach(param1);
         return true;
      }
      
      protected function Attach(param1:b2Body) : void
      {
         var _loc3_:b2Vec2 = null;
         this.attachedBody = param1;
         this.attachedFirearm = Gun(userData(this.attachedBody.GetUserData()).trigger).firearm;
         this.origBarrel = this.attachedFirearm.barrelPos.Copy();
         var _loc2_:int = -1;
         if(userData(param1.GetUserData()).flipped)
         {
            _loc2_ = 1;
         }
         this.origBarrel.x *= _loc2_;
         _loc3_ = this.attachedFirearm.barrelPos;
         _loc3_.x += _loc2_ * this.attachX / Physics.scale;
         _loc3_.y += this.attachY / Physics.scale;
         _loc3_.Multiply(userData(param1.GetUserData()).size);
         var _loc4_:Number = param1.GetAngle();
         _loc3_ = BoxUtils.rotateVec(_loc3_,_loc4_);
         if(userData(param1.GetUserData()).flipped)
         {
            _loc4_ += Math.PI;
         }
         if(ud.flipped)
         {
            _loc4_ += Math.PI;
         }
         body.SetXForm(new b2Vec2(_loc3_.x + param1.GetPosition().x,_loc3_.y + param1.GetPosition().y),_loc4_);
         ud.triggerState = 1;
         ud.triggered = false;
         var _loc5_:Number = userData(param1.GetUserData()).size;
         var _loc6_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(this.barrelX * _loc2_ / Physics.scale * ud.size,this.barrelY / Physics.scale),param1.GetAngle());
         var _loc7_:b2Vec2 = param1.GetLocalPoint(new b2Vec2(body.GetPosition().x + _loc6_.x,body.GetPosition().y + _loc6_.y));
         _loc7_.x *= _loc2_;
         _loc7_.Multiply(1 / _loc5_);
         this.attachedFirearm.shootPos = _loc7_;
      }
      
      protected function Detach() : void
      {
         if(this.attachedBody)
         {
            this.attachedFirearm.shootPos = new b2Vec2(this.origBarrel.x,this.origBarrel.y);
         }
      }
      
      override public function OnDelete() : void
      {
         super.OnDelete();
         Body.RemoveJointsNextFrame(body);
         ud.triggerState = 0;
         ud.triggered = false;
         this.Detach();
      }
   }
}

