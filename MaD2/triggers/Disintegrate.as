package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class Disintegrate extends Trigger
   {
      
      private var particle:String;
      
      private var spread:Number;
      
      private var count:int;
      
      public function Disintegrate(param1:String, param2:int, param3:Number = 0)
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
         Body.Disintegrate(param1,this.particle,this.count,this.spread,this.spread);
      }
   }
}

