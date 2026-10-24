package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class HealStim extends Trigger
   {
      
      public function HealStim()
      {
         super();
      }
      
      override public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
         var _loc6_:b2Body = null;
         var _loc7_:int = 0;
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
         var _loc5_:String = "steak";
         if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
         {
            _loc5_ = ud.pfx.getParticle();
         }
         for each(_loc6_ in _loc4_)
         {
            if(userData(_loc6_.GetUserData()).alive)
            {
               _loc7_ = 0;
               while(_loc7_ < 10)
               {
                  BoxUtils.randomParticlesOnBody(_loc6_,_loc5_);
                  _loc7_++;
               }
               userData(_loc6_.GetUserData()).maxhealth = userData(_loc6_.GetUserData()).maxhealth * 2;
               if(userData(_loc6_.GetUserData()).maxhealth > 99999)
               {
                  userData(_loc6_.GetUserData()).maxhealth = 99999;
               }
               userData(_loc6_.GetUserData()).health = userData(_loc6_.GetUserData()).maxhealth;
            }
         }
         sounds.play("harpoon_shoot",body,pixelCenter);
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

