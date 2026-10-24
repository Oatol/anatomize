package triggers
{
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Crit extends Trigger
   {
      
      public function Crit()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:userData = null;
         var _loc5_:b2Body = null;
         var _loc6_:int = 0;
         var _loc7_:* = undefined;
         super.trigger(param1,param2);
         var _loc3_:Array = BoxUtils.selectCompound(param1);
         for each(_loc5_ in _loc3_)
         {
            _loc4_ = userData(_loc5_.GetUserData());
            if(_loc4_.alive)
            {
               _loc4_.trigger = new Disintegrate("blood",_loc4_.maxhealth * 0.1,1.1);
               _loc4_.triggered = true;
            }
         }
         _loc6_ = 0;
         while(_loc6_ < 3)
         {
            _loc7_ = ["cut1","cut2","cut4"][_loc6_];
            sounds.play(_loc7_,null,pixelCenter,Math.random() * 0.3 + 0.3);
            _loc6_++;
         }
         param2.trigger.reset();
      }
   }
}

