package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.b2Body;
   
   public class DroneMask extends ArmourHelmet
   {
      
      public function DroneMask(param1:b2Body, param2:Number, param3:Number = 0.1, param4:Number = 0.5, param5:Number = 100)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         super.trigger(param1,param2);
         ud.triggered = true;
         _loc3_ = new b2Vec2(Math.random() * ud.triggerForce - ud.triggerForce * 0.5,Math.random() * ud.triggerForce - ud.triggerForce * 0.5);
         if(attachedBody)
         {
            _loc3_.Multiply(attachedBody.GetMass() * 10);
         }
         _loc3_.y -= GameState.environment.gravity;
         _loc3_.Multiply(body.GetMass());
         body.ApplyForce(_loc3_,bodyCenter);
         body.ApplyTorque(body.GetMass() * (Math.random() * ud.triggerForce - ud.triggerForce * 0.5));
      }
      
      override protected function Attach(param1:b2Body) : Boolean
      {
         var _loc2_:Array = null;
         var _loc3_:userData = null;
         var _loc4_:b2Body = null;
         if(super.Attach(param1))
         {
            _loc2_ = BoxUtils.selectCompound(attachedBody);
            _loc2_.push(attachedBody);
            for each(_loc4_ in _loc2_)
            {
               userData(_loc4_.GetUserData()).zerograv = true;
            }
            return true;
         }
         return false;
      }
      
      override public function Detach() : void
      {
         if(attachedBody)
         {
            this.Destroy();
         }
         super.Detach();
      }
      
      private function Destroy() : void
      {
         var _loc2_:userData = null;
         var _loc3_:b2Body = null;
         var _loc1_:Array = BoxUtils.selectCompound(attachedBody);
         _loc1_.push(attachedBody);
         for each(_loc3_ in _loc1_)
         {
            userData(_loc3_.GetUserData()).zerograv = false;
         }
      }
      
      override public function OnDelete() : void
      {
         super.OnDelete();
         this.Destroy();
      }
      
      override public function OnJointDelete(param1:b2Joint) : void
      {
         super.OnJointDelete(param1);
         if(!isAttached(body))
         {
            this.Destroy();
         }
      }
   }
}

