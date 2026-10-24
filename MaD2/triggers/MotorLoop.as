package triggers
{
   import Box2D.Dynamics.Joints.*;
   import Box2D.Dynamics.b2Body;
   
   public class MotorLoop extends Trigger
   {
      
      internal var dir:int = 1;
      
      internal var prismatic:Vector.<b2PrismaticJoint>;
      
      internal var revolute:Vector.<b2RevoluteJoint>;
      
      public function MotorLoop()
      {
         super();
      }
      
      override public function OnJoint(param1:b2Body, param2:String) : Boolean
      {
         if(!super.OnJoint(param1,param2))
         {
            return false;
         }
         ud.triggered = true;
         return true;
      }
      
      internal function initJoints() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:b2Body = null;
         var _loc3_:b2JointEdge = null;
         if(!body)
         {
            return;
         }
         this.prismatic = new Vector.<b2PrismaticJoint>();
         this.revolute = new Vector.<b2RevoluteJoint>();
         for each(_loc2_ in ud.connected)
         {
            _loc3_ = _loc2_.GetJointList();
            while(_loc3_)
            {
               switch(_loc3_.joint.GetType())
               {
                  case b2Joint.e_prismaticJoint:
                     this.prismatic.push(_loc3_.joint);
                     break;
                  case b2Joint.e_revoluteJoint:
                     this.revolute.push(_loc3_.joint);
               }
               _loc3_ = _loc3_.next;
            }
         }
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2PrismaticJoint = null;
         var _loc4_:b2RevoluteJoint = null;
         if(!this.prismatic && !this.revolute)
         {
            this.initJoints();
         }
         param2.triggerDuration -= TimeLord.speed * this.dir;
         if(param2.triggerDuration < -param2.originalTriggerDuration || param2.triggerDuration > param2.originalTriggerDuration)
         {
            this.dir *= -1;
         }
         param1.WakeUp();
         for each(_loc3_ in this.prismatic)
         {
            _loc3_.EnableMotor(true);
            _loc3_.SetMotorSpeed(param2.triggerDuration);
            _loc3_.SetMaxMotorForce(param2.triggerForce);
         }
         for each(_loc4_ in this.revolute)
         {
            _loc4_.EnableMotor(true);
            _loc4_.SetMotorSpeed(param2.triggerDuration);
            _loc4_.SetMaxMotorTorque(param2.triggerForce);
         }
         super.trigger(param1,param2);
      }
   }
}

