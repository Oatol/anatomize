package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Adrenaline extends Trigger
   {
      
      public function Adrenaline()
      {
         super();
      }
      
      override public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
         var _loc6_:b2Body = null;
         var _loc7_:int = 0;
         var _loc8_:userData = null;
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
         if(ud.resistAdrenaline)
         {
            return;
         }
         var _loc3_:userData = userData(param1.GetUserData());
         if(!_loc3_.alive)
         {
            return;
         }
         var _loc4_:Array = BoxUtils.selectCompound(param1);
         var _loc5_:String = "fire3";
         if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
         {
            _loc5_ = ud.pfx.getParticle();
         }
         for each(_loc6_ in _loc4_)
         {
            _loc7_ = 0;
            while(_loc7_ < 10)
            {
               BoxUtils.randomParticlesOnBody(_loc6_,_loc5_);
               _loc7_++;
            }
            _loc8_ = userData(_loc6_.GetUserData());
            _loc8_.trigger = new Hyped(ud.triggerForce);
            _loc8_.triggerDuration = 220;
            _loc8_.triggered = true;
            if(_loc8_.health < 0.7 * _loc8_.maxhealth)
            {
               _loc8_.health = 0.7 * _loc8_.maxhealth;
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

