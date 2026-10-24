package triggers
{
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.b2Body;
   
   public class NecromancerMask extends ArmourHelmet
   {
      
      public function NecromancerMask(param1:b2Body, param2:Number, param3:Number = 0.1, param4:Number = 0.5, param5:Number = 100)
      {
         super(param1,param2,param3,param4,param5);
         hideHead = true;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:userData = null;
         var _loc5_:b2Body = null;
         super.trigger(param1,param2);
         ud.triggered = true;
         if(!attachedBody)
         {
            return;
         }
         var _loc3_:Array = BoxUtils.selectCompound(attachedBody);
         _loc3_.push(attachedBody);
         for each(_loc5_ in _loc3_)
         {
            _loc4_ = userData(_loc5_.GetUserData());
            if(!(!_loc4_ || !_loc4_.alive))
            {
               _loc4_.health = 666;
               _loc4_.maxhealth = 666;
               _loc4_.resistAliveBreak = true;
               _loc4_.bleeding = [];
            }
         }
      }
      
      override public function OnJointDelete(param1:b2Joint) : void
      {
         super.OnJointDelete(param1);
         if(jointUserData(param1.GetUserData()).name == "armour")
         {
            ud.dead = true;
            this.OnDelete();
         }
      }
      
      override public function OnDelete() : void
      {
         var _loc2_:userData = null;
         var _loc3_:b2Body = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:Array = BoxUtils.selectCompound(attachedBody);
         _loc1_.push(attachedBody);
         for each(_loc3_ in _loc1_)
         {
            _loc2_ = userData(_loc3_.GetUserData());
            if(!(!_loc2_ || !_loc2_.alive))
            {
               _loc2_.health = 0;
               _loc2_.maxhealth = 0;
               _loc2_.resistAliveBreak = false;
               _loc5_ = 0;
               while(_loc5_ < 5)
               {
                  Body.Exsanguinate(_loc3_);
                  _loc5_++;
               }
            }
         }
         _loc4_ = 0;
         while(_loc4_ < 20)
         {
            BoxUtils.randomParticlesOnBody(body,"bigSmoke",2);
            _loc4_++;
         }
         super.OnDelete();
      }
   }
}

