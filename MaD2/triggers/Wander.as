package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Wander extends Trigger
   {
      
      public var wander:Number;
      
      public function Wander(param1:Number = 500)
      {
         super();
         this.wander = param1;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = new b2Vec2(Math.random() * this.wander - this.wander * 0.5,Math.random() * this.wander - this.wander * 0.5);
         _loc3_.Multiply(param1.GetMass());
         param1.ApplyForce(_loc3_,bodyCenter);
      }
   }
}

