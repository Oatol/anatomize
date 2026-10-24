package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class TwisterBullet extends GenericBullet
   {
      
      public function TwisterBullet()
      {
         super("shock");
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         var _loc3_:Number = 4000;
         var _loc4_:b2Vec2 = new b2Vec2(Math.random() * _loc3_ - _loc3_ * 0.5,Math.random() * _loc3_ - _loc3_ * 0.5 - 2);
         _loc4_.Multiply(param1.GetMass());
         param1.ApplyForce(_loc4_,bodyCenter);
      }
   }
}

