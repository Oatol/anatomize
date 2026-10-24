package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DisintegrateOnNextHit extends Trigger
   {
      
      private var particle:String;
      
      private var spread:Number;
      
      private var count:int;
      
      internal var hit:Boolean = false;
      
      public var ignore:Array = [];
      
      public var breakforce:* = 0;
      
      public function DisintegrateOnNextHit(param1:String, param2:int, param3:Number = 0)
      {
         super();
         this.particle = param1;
         this.spread = param3;
         this.count = param2;
         if(this.count > 50)
         {
            this.count = 50;
         }
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(this.hit)
         {
            Body.Disintegrate(param1,this.particle,this.count,this.spread,this.spread);
         }
         param2.triggered = false;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(this.breakforce > 0)
         {
            if(param4 < this.breakforce)
            {
               return false;
            }
         }
         if(!ud)
         {
            return false;
         }
         if(this.ignore.indexOf(userData(param1.GetUserData()).name) != -1)
         {
            return false;
         }
         this.hit = true;
         ud.triggered = true;
         return true;
      }
      
      override public function OnCut() : Boolean
      {
         if(!ud)
         {
            return false;
         }
         this.hit = true;
         ud.triggered = true;
         return true;
      }
   }
}

