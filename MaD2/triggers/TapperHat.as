package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2JointEdge;
   import Box2D.Dynamics.b2Body;
   
   public class TapperHat extends Trigger
   {
      
      public function TapperHat()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:String = null;
         var _loc5_:b2Body = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Vec2 = null;
         super.trigger(param1,param2);
         var _loc3_:b2JointEdge = param1.GetJointList();
         while(_loc3_)
         {
            _loc4_ = jointUserData(_loc3_.joint.GetUserData()).name;
            if(_loc4_ == "equip" || _loc4_ == "armour")
            {
               _loc5_ = _loc3_.joint.GetBody1();
               if(_loc5_ == param1)
               {
                  _loc5_ = _loc3_.joint.GetBody2();
               }
               _loc6_ = param2.triggerPos.Copy();
               if(param2.flipped)
               {
                  _loc6_.x *= -1;
               }
               _loc7_ = BoxUtils.rotateVec(_loc6_,bodyAngle);
               _loc7_.Add(bodyCenter);
               Body.Damage(_loc5_,3,_loc7_);
            }
            _loc3_ = _loc3_.next;
         }
      }
   }
}

