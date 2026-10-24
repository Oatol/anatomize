package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class SnowBall extends Trigger
   {
      
      public function SnowBall()
      {
         super();
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc8_:b2Body = null;
         var _loc9_:userData = null;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         super.trigger(body,ud);
         if(userData(param1.GetUserData()).name == "snowball")
         {
            return false;
         }
         var _loc7_:Array = Body.GetAround(body,ud.triggerRadius * ud.size,ud.triggerRadius * ud.size);
         for each(_loc8_ in _loc7_)
         {
            _loc9_ = userData(_loc8_.GetUserData());
            if(_loc9_.name != "snowball")
            {
               if(Boolean(_loc9_) && _loc9_.temperature > 0)
               {
                  _loc9_.temperature -= 20;
                  if(_loc9_.temperature < 0)
                  {
                     Body.Freeze(body);
                  }
               }
            }
         }
         ud.trigger = new Disintegrate("gas",50 * ud.size,ud.size * 0.1 * bodyVel.Length());
         ud.triggered = true;
         return true;
      }
   }
}

