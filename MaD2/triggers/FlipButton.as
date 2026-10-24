package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class FlipButton extends Trigger
   {
      
      internal var flipB:b2Body;
      
      public function FlipButton()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         super.trigger(param1,param2);
         if(!this.flipB)
         {
            ud.triggered = false;
            return;
         }
         if(this.flipB.IsStatic())
         {
            ud.triggered = false;
            return;
         }
         var _loc3_:userData = userData(this.flipB.GetUserData());
         if(!_loc3_ || _loc3_.dead)
         {
            ud.triggered = false;
            return;
         }
         ud.triggerDuration -= TimeLord.speed;
         if(ud.triggerDuration <= 0)
         {
            if(ud.triggerState == 0)
            {
               Body.Flip(this.flipB);
               ud.triggered = false;
            }
            else
            {
               ud.triggered = false;
               _loc4_ = int(ud.connected.length);
               _loc5_ = 0;
               while(_loc5_ < _loc4_)
               {
                  Body.Flip(ud.connected[_loc5_]);
                  _loc5_++;
               }
            }
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param3.name != "9b0711")
         {
            return false;
         }
         this.flipB = param1;
         ud.triggered = true;
         ud.triggerDuration = ud.originalTriggerDuration;
         if(ud.triggerDuration < 10)
         {
            ud.triggerDuration = 10;
         }
         return true;
      }
   }
}

