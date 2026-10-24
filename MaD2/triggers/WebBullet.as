package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class WebBullet extends GenericBullet
   {
      
      public function WebBullet()
      {
         super("spider");
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(param2.triggerState == 1)
         {
            _loc3_ = 400;
            _loc4_ = new b2Vec2(Math.random() * _loc3_ - _loc3_ * 0.5,Math.random() * _loc3_ - _loc3_ * 0.5 - 2);
            if(Math.random() < 0.9)
            {
               _loc4_.y = 0;
            }
            if(Math.random() > 0.99)
            {
               _loc4_.y *= 10;
            }
            _loc4_.Multiply(param1.GetMass());
            param1.ApplyForce(_loc4_,bodyCenter);
            if(Math.random() > 0.99)
            {
               param2.dead = true;
            }
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         ud.triggerState = 1;
         if(param1.IsStatic())
         {
            return false;
         }
         if(Math.random() > 0.5)
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(_loc7_.name == "web" || _loc7_.name == "webgun")
         {
            return false;
         }
         if(_loc7_.resistSnare)
         {
            return true;
         }
         _loc7_.trigger = new Webbed();
         _loc7_.triggered = true;
         _loc7_.triggerForce = 1;
         ud.dead = true;
         return true;
      }
   }
}

