package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class SwordBreaker extends Trigger
   {
      
      private var entry:b2Vec2;
      
      private var exit:b2Vec2;
      
      private var other:b2Body;
      
      public function SwordBreaker()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         ud.triggered = false;
         if(Boolean(this.entry) && Boolean(this.exit))
         {
            GameState.madeby = "swordbreaker";
            GameState.cutter.IncludeSingle(this.other);
            GameState.cutter.CustomCut(this.exit,this.entry,1,100,0);
            this.entry = null;
            this.exit = null;
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(userData(param1.GetUserData()).blunt)
         {
            return true;
         }
         if(!param2.sharp || param3.name != "282828")
         {
            return true;
         }
         param6.Copy().Normalize();
         this.entry = param5.Copy();
         this.exit = this.entry.Copy();
         this.entry.Add(new b2Vec2(param6.x * 1,param6.y * 1));
         this.exit.Add(new b2Vec2(param6.x * -1,param6.y * -1));
         this.entry.Multiply(Physics.scale);
         this.exit.Multiply(Physics.scale);
         this.other = param1;
         ud.triggered = true;
         return false;
      }
   }
}

