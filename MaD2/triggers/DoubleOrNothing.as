package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DoubleOrNothing extends Trigger
   {
      
      public function DoubleOrNothing()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Body = null;
         var _loc6_:b2Body = null;
         var _loc7_:userData = null;
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration > 0 || param2.triggerState == 0)
         {
            return;
         }
         param2.triggerState = 0;
         param2.triggerDuration = param2.originalTriggerDuration;
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius,param2.triggerRadius);
         var _loc4_:Boolean = Math.random() > 0.5;
         for each(_loc5_ in _loc3_)
         {
            if(_loc5_ != param1)
            {
               if(param2.ignored.indexOf(_loc5_) == -1)
               {
                  if(_loc4_)
                  {
                     userData(_loc5_.GetUserData()).trigger = new Disintegrate("fire2",10,5);
                     userData(_loc5_.GetUserData()).triggered = true;
                  }
                  else
                  {
                     _loc6_ = Body.Clone(_loc5_);
                     if(_loc6_)
                     {
                        _loc6_.SetXForm(_loc5_.GetWorldCenter(),_loc5_.GetAngle());
                        _loc7_ = userData(_loc6_.GetUserData());
                        _loc7_.saveable = false;
                     }
                  }
               }
            }
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!param1.IsStatic() && param3.name == ud.triggerColour && ud.triggerDuration <= 0)
         {
            ud.triggerState = 1;
         }
         return super.OnCollision(param1,param2,param3,param4,param5,param6);
      }
   }
}

