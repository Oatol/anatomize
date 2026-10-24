package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class EVEHypo extends Trigger
   {
      
      public function EVEHypo()
      {
         super();
      }
      
      override public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
         var _loc5_:b2Body = null;
         var _loc6_:int = 0;
         if(!ud)
         {
            return;
         }
         if(!ud.triggered)
         {
            return;
         }
         if(ud.triggerDuration > 0)
         {
            return;
         }
         var _loc3_:userData = userData(param1.GetUserData());
         if(!_loc3_.alive)
         {
            return;
         }
         var _loc4_:Array = BoxUtils.selectCompound(param1);
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = 0;
            while(_loc6_ < 10)
            {
               BoxUtils.randomParticlesOnBody(_loc5_,"forcefield");
               _loc6_++;
            }
         }
         ud.triggerDuration = ud.originalTriggerDuration;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(param2.triggerDuration > 0)
         {
            param2.triggerDuration -= TimeLord.speed;
         }
      }
   }
}

