package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class MutatePill extends Trigger
   {
      
      internal var healBody:b2Body;
      
      public function MutatePill()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:userData = null;
         super.trigger(param1,param2);
         if(!this.healBody)
         {
            param2.triggered = false;
            return;
         }
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = userData(_loc4_.GetUserData());
            Body.Mutate(_loc4_);
         }
         param2.dead = true;
         Body.Disintegrate(param1,"heal",20,10,10);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(!userData(param1.GetUserData()).alive)
         {
            return true;
         }
         this.healBody = param1;
         ud.triggered = true;
         return true;
      }
   }
}

