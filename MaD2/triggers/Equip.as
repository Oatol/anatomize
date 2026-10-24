package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2JointEdge;
   import Box2D.Dynamics.b2Body;
   
   public class Equip extends Trigger
   {
      
      public function Equip()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Vec2 = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:Number = NaN;
         var _loc11_:jointUserData = null;
         var _loc12_:b2Vec2 = null;
         super.trigger(param1,param2);
         var _loc3_:b2JointEdge = param1.GetJointList();
         while(_loc3_)
         {
            _loc11_ = jointUserData(_loc3_.joint.GetUserData());
            if(_loc11_.name == "equip")
            {
               param2.trigger = new Unequip();
               Unequip(param2.trigger).init(param1,param2);
               return;
            }
            _loc3_ = _loc3_.next;
         }
         if(triggerState == -1)
         {
            _loc4_ = new b2Vec2(-15 / Physics.scale * param2.size,0 / Physics.scale * param2.size);
            _loc5_ = new b2Vec2(-25 / Physics.scale * param2.size,0 / Physics.scale * param2.size);
            _loc6_ = 8 * param2.size;
         }
         else if(triggerState == 1)
         {
            _loc4_ = new b2Vec2(15 / Physics.scale * param2.size,0 / Physics.scale * param2.size);
            _loc5_ = new b2Vec2(25 / Physics.scale * param2.size,0 / Physics.scale * param2.size);
            _loc6_ = 8 * param2.size;
         }
         else if(triggerState == 0)
         {
            _loc4_ = new b2Vec2(0 / Physics.scale * param2.size,0 / Physics.scale * param2.size);
            _loc5_ = new b2Vec2(0 / Physics.scale * param2.size,-16 / Physics.scale * param2.size);
            _loc6_ = 20 * param2.size;
         }
         var _loc7_:b2Vec2 = BoxUtils.rotateVec(_loc4_,bodyAngle);
         _loc7_.Add(bodyCenter);
         _loc7_.Multiply(Physics.scale);
         var _loc8_:b2Vec2 = BoxUtils.rotateVec(_loc5_,bodyAngle);
         _loc8_.Add(bodyCenter);
         _loc8_.Multiply(Physics.scale);
         var _loc9_:Array = GameState.cutter.CustomRaycast(_loc7_,_loc6_,_loc8_,false,"equip");
         if(_loc9_[1])
         {
            GraphicUtils.efla(Main.instance.particlesBMD,_loc7_.x + camPos.x,_loc7_.y + camPos.y,b2Vec2(_loc9_[1]).x * Physics.scale + camPos.x,b2Vec2(_loc9_[1]).y * Physics.scale + camPos.y,4294967295);
         }
         var _loc10_:b2Body = b2Body(_loc9_[0]);
         if(_loc10_)
         {
            if(_loc10_.IsStatic())
            {
               return;
            }
            if(param2.id != -1 && userData(_loc10_.GetUserData()).id == param2.id)
            {
               return;
            }
            _loc7_.Multiply(1 / Physics.scale);
            _loc12_ = b2Vec2(_loc9_[1]);
            _loc12_.Add(new b2Vec2((-_loc7_.x + _loc12_.x) * 1.1,(-_loc7_.y + _loc12_.y) * 1.1));
            Joints.Weld("equip",param1,_loc10_,_loc7_);
            param2.trigger = new Unequip();
            Unequip(param2.trigger).init(param1,param2);
            param2.triggered = false;
         }
      }
   }
}

