package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class HailBullet extends GenericBullet
   {
      
      public function HailBullet()
      {
         super("hail");
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc9_:b2Body = null;
         var _loc10_:userData = null;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:Array = BoxUtils.selectCompound(param1);
         var _loc8_:userData = userData(param1.GetUserData());
         if(_loc8_.temperature > 0)
         {
            Body.Freeze(param1);
         }
         for each(_loc9_ in _loc7_)
         {
            _loc10_ = userData(_loc9_.GetUserData());
            _loc10_.temperature -= 4;
            if(_loc10_.temperature < 0)
            {
               Main.instance.brittleArray.push(_loc9_);
            }
         }
         return true;
      }
   }
}

