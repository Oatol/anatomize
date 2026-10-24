package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class GlitchHammer extends Trigger
   {
      
      private var brittlebody:b2Body;
      
      public function GlitchHammer()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         var _loc3_:Boolean = false;
         if(this.brittlebody)
         {
            Body.Glitch(this.brittlebody);
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
         if(param3.name != "202a35")
         {
            return false;
         }
         if(param1.IsStatic())
         {
            return false;
         }
         if(userData(param1.GetUserData()).effectCounter >= 3)
         {
            return false;
         }
         this.brittlebody = param1;
         ud.triggered = true;
         return true;
      }
   }
}

