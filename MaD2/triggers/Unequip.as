package triggers
{
   import Box2D.Dynamics.Joints.b2JointEdge;
   import Box2D.Dynamics.b2Body;
   
   public class Unequip extends Trigger
   {
      
      public function Unequip()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:jointUserData = null;
         var _loc6_:b2Body = null;
         var _loc7_:userData = null;
         super.trigger(param1,param2);
         param2.triggered = false;
         var _loc3_:Boolean = false;
         var _loc4_:b2JointEdge = param1.GetJointList();
         while(_loc4_)
         {
            _loc5_ = jointUserData(_loc4_.joint.GetUserData());
            if(_loc5_.name == "equip")
            {
               if(GameState.roleplaying)
               {
                  if(_loc4_.joint.GetBody1() == param1)
                  {
                     _loc6_ = _loc4_.joint.GetBody2();
                  }
                  else
                  {
                     _loc6_ = _loc4_.joint.GetBody1();
                  }
                  _loc7_ = userData(_loc6_.GetUserData());
                  if(Boolean(_loc7_.trigger) && !_loc7_.triggerLock)
                  {
                     _loc7_.triggered = true;
                     _loc3_ = true;
                  }
                  else
                  {
                     _loc5_.dead = true;
                     _loc3_ = false;
                  }
               }
               else
               {
                  _loc5_.dead = true;
               }
            }
            _loc4_ = _loc4_.next;
         }
         if(_loc3_)
         {
            return;
         }
         param2.trigger = new Equip();
         Equip(param2.trigger).init(param1,param2);
      }
   }
}

