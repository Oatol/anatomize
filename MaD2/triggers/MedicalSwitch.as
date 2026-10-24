package triggers
{
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.b2Body;
   
   public class MedicalSwitch extends Trigger
   {
      
      internal var jointedBody:b2Body;
      
      internal var jud:userData;
      
      public function MedicalSwitch()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc6_:b2Body = null;
         var _loc7_:userData = null;
         var _loc8_:b2Body = null;
         super.trigger(param1,param2);
         if(!this.jointedBody)
         {
            return;
         }
         var _loc3_:Boolean = false;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         if(triggerState == 1)
         {
            for each(_loc6_ in this.jud.connected)
            {
               _loc7_ = userData(_loc6_.GetUserData());
               if(_loc7_.alive)
               {
                  _loc4_ += _loc7_.health;
                  _loc5_ += _loc7_.maxhealth;
               }
            }
            _loc3_ = _loc4_ / _loc5_ < _loc5_ * (param2.triggerForce * 0.01);
         }
         else
         {
            _loc3_ = this.jud.health < this.jud.maxhealth * (param2.triggerForce * 0.01);
         }
         if(_loc3_)
         {
            for each(_loc8_ in param2.connected)
            {
               userData(_loc8_.GetUserData()).triggered = true;
            }
         }
      }
      
      override public function OnJoint(param1:b2Body, param2:String) : Boolean
      {
         if(!super.OnJoint(param1,param2))
         {
            return false;
         }
         this.jointedBody = param1;
         this.jud = userData(this.jointedBody.GetUserData());
         return true;
      }
      
      override public function OnJointDelete(param1:b2Joint) : void
      {
         if(this.jointedBody)
         {
            if(param1.GetBody1() == this.jointedBody || param1.GetBody2() == this.jointedBody)
            {
               this.jointedBody = null;
               this.jud = null;
            }
         }
         super.OnJointDelete(param1);
      }
   }
}

