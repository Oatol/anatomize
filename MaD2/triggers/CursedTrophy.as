package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2JointEdge;
   import Box2D.Dynamics.b2Body;
   
   public class CursedTrophy extends Armour
   {
      
      private var sp:b2Vec2;
      
      internal var previouslyCursed:b2Body;
      
      public function CursedTrophy(param1:b2Body)
      {
         super(param1,1,0,0,0);
         attachTarget = "doll_hand";
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:userData = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:String = null;
         var _loc10_:b2JointEdge = null;
         var _loc3_:Array = Body.GetAround(body,ud.triggerRadius * ud.size,ud.triggerRadius * ud.size,false);
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_ != this.previouslyCursed)
            {
               _loc5_ = userData(_loc4_.GetUserData());
               if((Boolean(_loc5_)) && Boolean(_loc5_.name == "doll_hand") && _loc5_.health > 50)
               {
                  _loc6_ = _loc4_.GetPosition().Copy();
                  _loc7_ = body.GetPosition().Copy();
                  _loc8_ = new b2Vec2(_loc6_.x - _loc7_.x,_loc6_.y - _loc7_.y);
                  _loc8_.Multiply(-ud.triggerForce);
                  _loc4_.ApplyForce(_loc8_,_loc4_.GetWorldCenter());
                  if(BoxUtils.vectorDist(_loc6_,_loc7_) < 2.5)
                  {
                     _loc10_ = _loc4_.GetJointList();
                     while(_loc10_)
                     {
                        _loc9_ = jointUserData(_loc10_.joint.GetUserData()).name;
                        if(_loc9_ == "weldjoint" || _loc9_ == "equip" || _loc9_ == "armour")
                        {
                           jointUserData(_loc10_.joint.GetUserData()).dead = true;
                        }
                        _loc10_ = _loc10_.next;
                     }
                     if(this.Attach(_loc4_))
                     {
                        ud.triggerLock = false;
                        ud.triggered = false;
                        ud.triggerLock = true;
                        _loc5_.trigger = new Cursed(body);
                        _loc5_.triggered = true;
                        this.previouslyCursed = _loc4_;
                        break;
                     }
                  }
               }
            }
         }
      }
      
      override protected function Attach(param1:b2Body) : Boolean
      {
         var _loc3_:b2Body = null;
         var _loc4_:b2Body = null;
         var _loc2_:Array = BoxUtils.selectCompound(param1);
         for each(_loc4_ in _loc2_)
         {
            if(userData(_loc4_.GetUserData()).name == "doll_head")
            {
               _loc3_ = _loc4_;
               break;
            }
         }
         if(!_loc3_)
         {
            return false;
         }
         var _loc5_:b2Vec2 = new b2Vec2(0,-1);
         var _loc6_:b2Vec2 = new b2Vec2(0,1);
         _loc5_ = BoxUtils.rotateVec(_loc5_,_loc3_.GetAngle());
         _loc6_ = BoxUtils.rotateVec(_loc6_,_loc3_.GetAngle());
         _loc5_.Add(_loc3_.GetPosition());
         _loc6_.Add(_loc3_.GetPosition());
         var _loc7_:Number = GeneralUtils.determinant(_loc5_.x,_loc5_.y,_loc6_.x,_loc6_.y,param1.GetPosition().x,param1.GetPosition().y);
         if(_loc7_ > 0)
         {
            this.sp = new b2Vec2(-20 * ud.size,-18 * ud.size);
            this.sp.Multiply(userData(param1.GetUserData()).size);
         }
         else
         {
            this.sp = new b2Vec2(20 * ud.size,-18 * ud.size);
            this.sp.Multiply(userData(param1.GetUserData()).size);
         }
         this.Position(param1);
         return super.Attach(param1);
      }
      
      override protected function Position(param1:b2Body) : void
      {
         Body.RemoveJoints(body);
         var _loc2_:Number = param1.GetAngle();
         this.sp = BoxUtils.rotateVec(this.sp,_loc2_);
         this.sp.Multiply(1 / Physics.scale);
         body.SetXForm(new b2Vec2(this.sp.x + param1.GetPosition().x,this.sp.y + param1.GetPosition().y),_loc2_ + equipAngle);
      }
      
      override public function OnDelete() : void
      {
         if(attachedBody)
         {
            userData(attachedBody.GetUserData()).trigger.reset();
         }
         super.OnDelete();
      }
   }
}

