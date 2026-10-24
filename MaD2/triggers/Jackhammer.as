package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Jackhammer extends Trigger
   {
      
      private var tcg:String;
      
      internal var dir:int = 1;
      
      public function Jackhammer()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         param1.SetLinearVelocity(new b2Vec2(0,Vars.gravity));
         param1.SetAngularVelocity(param1.GetAngularVelocity() * 0.9);
         var _loc3_:b2Vec2 = new b2Vec2(Math.cos(bodyAngle + Vars.PI * 0.5),Math.sin(bodyAngle + Vars.PI * 0.5));
         _loc3_.Multiply(param2.triggerForce * this.dir);
         this.dir *= -1;
         param1.ApplyImpulse(_loc3_,bodyCenter);
      }
   }
}

