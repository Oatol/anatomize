package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Guitar extends PlayRandomSound
   {
      
      public function Guitar()
      {
         super(["guitar1","guitar2","guitar3","guitar4","guitar5","guitar6"],[1,1,1,1,1,1]);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         ud.triggerDuration -= TimeLord.speed;
         if(ud.triggerDuration <= 0)
         {
            _loc3_ = 0.6;
            _loc4_ = 0.6;
            vol = [Math.random() * _loc4_ + _loc3_,Math.random() * _loc4_ + _loc3_,Math.random() * _loc4_ + _loc3_,Math.random() * _loc4_ + _loc3_,Math.random() * _loc4_ + _loc3_,Math.random() * _loc4_ + _loc3_];
            _loc5_ = ud.originalTriggerDuration;
            if(_loc5_ < 3)
            {
               _loc5_ = 3;
            }
            ud.triggerDuration = _loc5_;
            super.trigger(param1,param2);
            sfx = ["guitar1","guitar2","guitar3","guitar4","guitar5","guitar6"];
            vol = [1,1,1,1,1,1];
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc8_:int = 0;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if((Boolean(_loc7_)) && _loc7_.name == "guitarpick")
         {
            _loc8_ = _loc7_.triggerForce;
            if(_loc8_ < 1)
            {
               _loc8_ = 1;
            }
            if(_loc8_ > 6)
            {
               _loc8_ = 6;
            }
            sfx = ["guitar" + (7 - _loc8_).toString()];
            vol = [1];
            ud.triggered = true;
         }
         return true;
      }
      
      public function Play(param1:int) : void
      {
         sfx = ["guitar" + (7 - param1).toString()];
         ud.triggered = true;
      }
   }
}

