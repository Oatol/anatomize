package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.Joints.b2JointEdge;
   import Box2D.Dynamics.Joints.b2WeldJoint;
   import Box2D.Dynamics.b2Body;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class Armour extends Trigger
   {
      
      protected var safeDestroy:Boolean = false;
      
      public var linkOnEquip:Boolean = false;
      
      public var triggerOnEquip:Boolean = false;
      
      public var attachedBody:b2Body;
      
      private var _equipAngle:Number = 0;
      
      public var equipAngleOffset:Number = 0;
      
      public var equipRadius:Number = 20;
      
      public var protectFromCuts:Boolean = true;
      
      public var collideWithDolls:Boolean = false;
      
      public var requireAliveToEquip:Boolean = true;
      
      protected var dmgCut:Number = 100;
      
      protected var dmgBlunt:Number = 0.1;
      
      protected var dmgBullet:Number = 0.5;
      
      internal var bodypart:int = 0;
      
      public var attachTarget:String;
      
      public var allowOther:Boolean = false;
      
      internal var cols:Array;
      
      public var OnAttach:Function;
      
      public var OnDetach:Function;
      
      public var OnDamage:Function;
      
      public function Armour(param1:b2Body, param2:Number, param3:Number = 0.1, param4:Number = 0.5, param5:Number = 1)
      {
         var _loc7_:int = 0;
         super();
         this.dmgCut = param5;
         this.dmgBlunt = param3;
         this.dmgBullet = param4;
         ud = userData(param1.GetUserData());
         ud.maxhealth = param2;
         ud.health = param2;
         ud.unbreakable = true;
         ud.resistShock = true;
         ud.resistPoison = true;
         ud.resistBleed = true;
         ud.resistConcuss = true;
         ud.layer = 2;
         GraphicUtils.addGraphicToLayer(ud);
         this.attachTarget = "doll_body";
         ud.armour = this;
         var _loc6_:Item = O.getItem(ud.name);
         if((Boolean(_loc6_)) && Boolean(_loc6_.colours))
         {
            this.cols = _loc6_.colours.slice();
            _loc7_ = 0;
            while(_loc7_ < this.cols.length)
            {
               if(this.cols[_loc7_] is ShapeUserData)
               {
                  if(ShapeUserData(this.cols[_loc7_]).invisible)
                  {
                     this.cols[_loc7_] = "333333";
                  }
                  else
                  {
                     this.cols[_loc7_] = ShapeUserData(this.cols[_loc7_]).name;
                  }
               }
               _loc7_++;
            }
         }
         else
         {
            this.cols = ["333333"];
         }
         ud.triggered = true;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:userData = null;
         var _loc5_:b2Body = null;
         var _loc6_:Vector.<b2Body> = null;
         super.trigger(param1,param2);
         if(this.safeDestroy)
         {
            _loc6_ = Body.Decompose(body);
            for each(_loc5_ in _loc6_)
            {
               userData(_loc5_.GetUserData()).name = this.cols[int(Math.random() * this.cols.length)];
               Body.Disintegrate(_loc5_,"inherit",50,1,1);
            }
            return;
         }
         if(!this.attachedBody || userData(this.attachedBody.GetUserData()).dead)
         {
            this.Detach();
         }
         if(this.attachedBody)
         {
            return;
         }
         var _loc3_:Array = Body.GetAround(param1,this.equipRadius,this.equipRadius);
         for each(_loc5_ in _loc3_)
         {
            _loc4_ = userData(_loc5_.GetUserData());
            if(this.EquipCheck(_loc5_))
            {
               if(this.equip(_loc5_))
               {
                  break;
               }
            }
         }
      }
      
      protected function EquipCheck(param1:b2Body) : Boolean
      {
         if(this.requireAliveToEquip && !userData(param1.GetUserData()).alive)
         {
            return false;
         }
         return true;
      }
      
      protected function equip(param1:b2Body, param2:Boolean = false) : Boolean
      {
         var _loc3_:b2Body = null;
         var _loc5_:userData = null;
         var _loc7_:b2Body = null;
         var _loc4_:Array = BoxUtils.selectCompound(param1);
         if(param2)
         {
            for each(_loc7_ in _loc4_)
            {
               _loc5_ = userData(_loc7_.GetUserData());
               if(_loc5_.name == "doll_head")
               {
                  _loc3_ = _loc7_;
                  break;
               }
            }
            if(_loc3_)
            {
               _loc4_ = BoxUtils.selectCompound(_loc3_);
            }
         }
         var _loc6_:int = 0;
         for each(_loc7_ in _loc4_)
         {
            _loc5_ = userData(_loc7_.GetUserData());
            if(_loc5_.resistArmour)
            {
               return false;
            }
            if(this.AttachCheck(_loc5_.name))
            {
               if(!this.isAttached(_loc7_))
               {
                  if(this.bodypart == _loc6_ || this.bodypart == 999)
                  {
                     this.Position(_loc7_);
                     return this.Attach(_loc7_);
                  }
                  _loc6_++;
               }
            }
         }
         return false;
      }
      
      protected function AttachCheck(param1:String) : Boolean
      {
         return param1 == this.attachTarget;
      }
      
      protected function Position(param1:b2Body) : void
      {
         var _loc2_:b2Vec2 = ud.triggerPos.Copy();
         if(ud.flipped && Boolean(ud.triggerPosFlipped))
         {
            _loc2_ = ud.triggerPosFlipped.Copy();
         }
         _loc2_.Multiply(userData(param1.GetUserData()).size);
         var _loc3_:b2Vec2 = param1.GetPosition().Copy();
         var _loc4_:Number = param1.GetAngle();
         _loc2_ = BoxUtils.rotateVec(_loc2_,_loc4_);
         _loc2_.Multiply(1 / Physics.scale);
         body.SetXForm(new b2Vec2(_loc2_.x + _loc3_.x,_loc2_.y + _loc3_.y),_loc4_ + this.equipAngle);
      }
      
      override public function OnJoint(param1:b2Body, param2:String) : Boolean
      {
         if(param1 == ud.body)
         {
            return true;
         }
         if(this.isAttached(param1))
         {
            return false;
         }
         if(param2 == "armour" || param2 == "weld")
         {
            this.attachedBody = param1;
            if(this.linkOnEquip)
            {
               this.LinkTo(param1);
            }
            if(this.triggerOnEquip)
            {
               ud.triggered = true;
            }
            if(Boolean(this.OnAttach))
            {
               this.OnAttach.call();
            }
         }
         return true;
      }
      
      protected function LinkTo(param1:b2Body) : *
      {
         var _loc3_:b2Body = null;
         var _loc2_:Array = BoxUtils.selectCompound(param1);
         for each(_loc3_ in _loc2_)
         {
            if(ud.connected.indexOf(_loc3_) == -1)
            {
               ud.connected.push(_loc3_);
            }
         }
      }
      
      protected function Attach(param1:b2Body) : Boolean
      {
         var _loc2_:b2WeldJoint = Joints.Weld("armour",body,param1,param1.GetPosition());
         if(_loc2_)
         {
            _loc2_.m_collideConnected = false;
            jointUserData(_loc2_.GetUserData()).cuttable = false;
            if(!this.allowOther)
            {
               jointUserData(_loc2_.GetUserData()).forceLimit = 1000000 + this.bodypart;
            }
            userData(param1.GetUserData()).armoured = true;
            this.attachedBody = param1;
            if(Boolean(this.OnAttach))
            {
               this.OnAttach.call();
            }
            return true;
         }
         return false;
      }
      
      protected function isAttached(param1:b2Body) : Boolean
      {
         var _loc3_:jointUserData = null;
         var _loc2_:b2JointEdge = param1.GetJointList();
         while(_loc2_)
         {
            _loc3_ = jointUserData(_loc2_.joint.GetUserData());
            if(this.allowOther)
            {
               return false;
            }
            if(_loc3_.forceLimit == 1000000 + this.bodypart)
            {
               return true;
            }
            _loc2_ = _loc2_.next;
         }
         return false;
      }
      
      public function Detach() : void
      {
         if(Boolean(this.OnDetach))
         {
            this.OnDetach.call();
         }
         if(!this.attachedBody)
         {
            return;
         }
         userData(this.attachedBody.GetUserData()).armoured = false;
         this.attachedBody = null;
      }
      
      override public function OnDelete() : void
      {
         this.Detach();
         super.OnDelete();
      }
      
      protected function Damage(param1:Number, param2:Boolean = true) : void
      {
         if(Boolean(this.OnDamage))
         {
            this.OnDamage.call(null,param1);
         }
         ud.health -= param1;
         if(param2 && ud.health <= 10)
         {
            this.safeDestroy = true;
            return;
         }
      }
      
      override public function OnCut() : Boolean
      {
         if(this.protectFromCuts)
         {
            return false;
         }
         return true;
      }
      
      override public function OnJointDelete(param1:b2Joint) : void
      {
         super.OnJointDelete(param1);
         this.Detach();
      }
      
      override public function OnCutDamage(param1:b2Vec2, param2:b2Vec2) : void
      {
         super.OnCutDamage(param1,param2);
         var _loc3_:Number = BoxUtils.vectorDist(param1,param2) * this.dmgCut;
         this.Damage(_loc3_);
      }
      
      public function bulletHole(param1:b2Vec2, param2:b2Vec2) : *
      {
         var _loc4_:b2Vec2 = null;
         var _loc5_:Sprite = null;
         var _loc6_:Bitmap = null;
         var _loc7_:int = 0;
         if(ud.dead || !body)
         {
            return;
         }
         var _loc3_:BitmapData = BoxUtils.getEffectBMD(body);
         if(_loc3_)
         {
            _loc4_ = body.GetLocalPoint(param1).Copy();
            _loc5_ = new Sprite();
            _loc4_.Multiply(Physics.scale);
            _loc6_ = Bitmap(ud.graphic.getChildByName("effects"));
            _loc4_.x -= _loc6_.x;
            _loc4_.y -= _loc6_.y;
            _loc7_ = 0;
            while(_loc7_ < 3)
            {
               _loc5_.graphics.beginFill(6710886 * ((_loc7_ + 1) / 3),0.3 * (_loc7_ + 1));
               _loc5_.graphics.drawCircle(_loc4_.x + Math.random() * param2.x * (_loc7_ / 25),_loc4_.y + Math.random() * param2.y * (_loc7_ / 25),_loc7_ * 1.5);
               _loc5_.graphics.endFill();
               _loc7_++;
            }
            _loc3_.draw(_loc5_);
         }
      }
      
      public function DamageBlunt(param1:Number, param2:b2Vec2, param3:b2Vec2) : void
      {
         this.Damage(param1 * this.dmgBlunt);
      }
      
      public function DamageBullet(param1:Number, param2:b2Vec2, param3:b2Vec2) : void
      {
         this.Damage(param1 * this.dmgBullet);
      }
      
      public function get equipAngle() : Number
      {
         return this._equipAngle + this.equipAngleOffset * Vars.toRadians * (ud.flipped ? -1 : 1);
      }
      
      public function set equipAngle(param1:Number) : void
      {
         this._equipAngle = param1;
      }
   }
}

