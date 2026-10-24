package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Keypad extends Trigger
   {
      
      public function Keypad()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Array = null;
         var _loc4_:b2Body = null;
         super.trigger(param1,param2);
         if(param2.triggerDuration > 0)
         {
            param2.triggerDuration -= TimeLord.speed;
         }
         if(param2.triggerRadius > 10)
         {
            _loc3_ = Body.GetAround(param1,param2.triggerRadius * 0.5,param2.triggerRadius * 0.5,false);
            for each(_loc4_ in _loc3_)
            {
               this.checkCard(_loc4_);
            }
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         return this.checkCard(param1);
      }
      
      private function checkCard(param1:b2Body) : Boolean
      {
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_)
         {
            return false;
         }
         if(_loc2_.name == "securitycard")
         {
            if(BoxUtils.getSkinColour(ud.skin,"5bb236") == BoxUtils.getSkinColour(_loc2_.skin,"5bb236"))
            {
               if(ud.triggerDuration <= 0)
               {
                  ud.triggerDuration = ud.originalTriggerDuration;
                  ud.triggered = true;
                  this.triggerconnected();
                  return true;
               }
               return false;
            }
         }
         return false;
      }
      
      override public function OnLoadCustom() : void
      {
         ud.triggerDuration = 0;
         ud.triggered = true;
      }
      
      private function triggerconnected() : void
      {
         var _loc2_:b2Body = null;
         var _loc4_:userData = null;
         if(!ud || ud.connected.length == 0)
         {
            return;
         }
         var _loc1_:int = int(ud.connected.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = ud.connected[_loc3_];
            if(_loc2_)
            {
               if(_loc2_ != body)
               {
                  _loc4_ = userData(_loc2_.GetUserData());
                  if(_loc4_)
                  {
                     _loc4_.triggered = !_loc4_.triggered;
                  }
               }
            }
            _loc3_++;
         }
      }
   }
}

