package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class InkBrush extends PaintBrush
   {
      
      internal var ink:Number = 20;
      
      public function InkBrush()
      {
         super();
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(Boolean(param3) && param3.name == "202026")
         {
            if(userData(param1.GetUserData()).name == "inkwell")
            {
               this.ink = 100;
               return false;
            }
         }
         if(this.ink <= 0)
         {
            return false;
         }
         --this.ink;
         return super.OnCollision(param1,param2,param3,param4,param5,param6);
      }
   }
}

