package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class GlassHammer extends Trigger
   {
      
      private var brittlebody:b2Body;
      
      public function GlassHammer()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:Number = NaN;
         super.trigger(param1,param2);
         var _loc3_:Boolean = false;
         if(this.brittlebody)
         {
            if(ud.triggerForce == 20)
            {
               _loc4_ = 1000;
            }
            else
            {
               _loc4_ = ud.triggerForce * 10;
            }
            Body.Glass(this.brittlebody,_loc4_);
            if(userData(this.brittlebody.GetUserData()).trigger is DisintegrateOnNextHit)
            {
               DisintegrateOnNextHit(userData(this.brittlebody.GetUserData()).trigger).ignore.push("glasshammer");
            }
         }
         ud.triggered = false;
         this.brittlebody = null;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param3.name != "64cbe2")
         {
            return false;
         }
         if(param1.IsStatic())
         {
            return false;
         }
         this.brittlebody = param1;
         ud.triggered = true;
         return true;
      }
   }
}

