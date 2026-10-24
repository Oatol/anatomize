package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2JointEdge;
   import Box2D.Dynamics.b2Body;
   
   public class HPDrain extends Trigger
   {
      
      public function HPDrain()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2JointEdge = null;
         var _loc4_:b2Body = null;
         var _loc5_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(Math.random() > 0.9)
         {
            _loc3_ = param1.GetJointList();
            while(_loc3_)
            {
               if(jointUserData(_loc3_.joint.GetUserData()).name == "equip")
               {
                  _loc4_ = _loc3_.joint.GetBody1();
                  if(_loc4_ == param1)
                  {
                     _loc4_ = _loc3_.joint.GetBody2();
                  }
                  _loc5_ = BoxUtils.rotateVec(param2.triggerPos,bodyAngle);
                  _loc5_.Add(bodyCenter);
                  Body.Damage(_loc4_,30,_loc5_,new b2Vec2(_loc5_.x - bodyCenter.x,_loc5_.y - bodyCenter.y));
               }
               _loc3_ = _loc3_.next;
            }
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param3.sticky && userData(param1.GetUserData()).alive)
         {
            Joints.Weld("equip",body,param1,param5,1000);
         }
         return true;
      }
   }
}

