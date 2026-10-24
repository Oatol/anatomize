package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Doorbell extends Trigger
   {
      
      public function Doorbell()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc6_:userData = null;
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration > 0)
         {
            return;
         }
         param2.triggered = false;
         if(param2.connected.length == 0)
         {
            return;
         }
         var _loc3_:int = int(param2.connected.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = param2.connected[_loc5_];
            if(_loc4_)
            {
               _loc6_ = userData(_loc4_.GetUserData());
               if(_loc6_.group < 1000)
               {
                  _loc6_.group += 1000;
                  if(_loc6_.graphic.alpha == 1)
                  {
                     _loc6_.graphic.alpha = 0.2;
                  }
               }
               else
               {
                  _loc6_.group -= 1000;
                  if(_loc6_.graphic.alpha != 0)
                  {
                     _loc6_.graphic.alpha = 1;
                  }
               }
            }
            _loc5_++;
         }
      }
      
      override public function onTrigger() : void
      {
         super.onTrigger();
         if(ud.triggerDuration != ud.originalTriggerDuration)
         {
            sounds.play("doorbell");
         }
         ud.triggerDuration = ud.originalTriggerDuration;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param3.name != "800000")
         {
            return true;
         }
         if(ud.triggered)
         {
            return true;
         }
         ud.triggered = true;
         return true;
      }
   }
}

