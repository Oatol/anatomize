package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DeathsTouch extends Trigger
   {
      
      internal var ob:b2Body;
      
      internal var op:b2Vec2;
      
      public function DeathsTouch()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(!this.ob)
         {
            return;
         }
         Body.Kill(this.ob,this.op);
         this.ob = null;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc8_:b2Vec2 = null;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(!ud.triggered)
         {
            return true;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(!_loc7_)
         {
            return true;
         }
         if(!_loc7_.alive)
         {
            return true;
         }
         if(param3.name == "2a0d0d")
         {
            _loc8_ = param5.Copy();
            _loc8_.Multiply(Physics.scale);
            this.ob = param1;
            this.op = _loc8_;
            ud.triggered = true;
            _loc7_.trigger = new Poisoned();
            _loc7_.triggerDuration = 600;
            _loc7_.triggered = true;
         }
         return true;
      }
   }
}

