package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ChunkStaff extends Trigger
   {
      
      internal var chunk:b2Body;
      
      public function ChunkStaff()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         param2.triggered = false;
         Body.Gib(this.chunk,0.0002);
         this.chunk = null;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(this.chunk)
         {
            return true;
         }
         if(param3.name == "421c17")
         {
            this.chunk = param1;
            ud.triggered = true;
         }
         return true;
      }
   }
}

