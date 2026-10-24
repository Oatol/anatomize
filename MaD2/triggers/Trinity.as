package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Trinity extends Trigger
   {
      
      public function Trinity()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:userData = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size);
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_ != param2.body)
            {
               _loc5_ = _loc4_.GetUserData();
               if(triggerState == 0)
               {
                  Body.Freeze(_loc4_);
               }
               else if(triggerState == 1)
               {
                  _loc5_.conductivity = 0.01;
                  _loc5_.ignition = 100;
                  _loc5_.temperature = 150;
               }
               else if(triggerState == 2)
               {
                  _loc5_.trigger = new Electrified();
                  _loc5_.triggerDuration = 20;
                  _loc5_.triggered = true;
               }
            }
         }
         if(triggerState == 0)
         {
            sounds.play("cryo",param1,pixelCenter);
         }
         else if(triggerState == 1)
         {
            sounds.play("flamer_shoot",param1,pixelCenter);
         }
         else if(triggerState == 2)
         {
            sounds.play("tesla_shoot",param1,pixelCenter);
         }
         param2.triggered = false;
         param2.triggerLock = true;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param1.IsStatic())
         {
            return false;
         }
         if(userData(param1.GetUserData()).trigger is Electrified)
         {
            return false;
         }
         if(userData(param1.GetUserData()).burning)
         {
            return false;
         }
         if(userData(param1.GetUserData()).temperature < 0)
         {
            return false;
         }
         ud.triggerLock = false;
         ud.triggered = true;
         var _loc7_:Array = ["5fd4d9","ff4300","e4e50d"];
         ud.triggerState = _loc7_.indexOf(param3.name);
         return true;
      }
   }
}

