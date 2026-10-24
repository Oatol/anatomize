package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class AcidPotion extends Trigger
   {
      
      public function AcidPotion()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:Vector.<b2Body> = null;
         var _loc6_:b2Body = null;
         var _loc7_:userData = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size);
         for each(_loc4_ in _loc3_)
         {
            _loc7_ = userData(_loc4_.GetUserData());
            if(_loc7_)
            {
               _loc7_.trigger = new Acided();
               _loc7_.triggerDuration = 520;
               _loc7_.triggered = true;
            }
         }
         _loc5_ = Body.Decompose(param1);
         for each(_loc6_ in _loc5_)
         {
            if(userData(_loc6_.GetUserData()).name != "88A9AD")
            {
               Body.Disintegrate(_loc6_,"acid",20,20,20);
            }
            else
            {
               userData(_loc6_.GetUserData()).trigger = new triggers.Disintegrate("inherit",100,0.2 * bodyVel.Length());
               userData(_loc6_.GetUserData()).triggered = false;
               userData(_loc6_.GetUserData()).triggerContact = 20;
            }
         }
         sounds.play("acidburn",param1,pixelCenter);
      }
   }
}

