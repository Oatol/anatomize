package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Chalkboard extends Trigger
   {
      
      internal var pcolour:uint;
      
      public function Chalkboard()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:userData = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,100 * param2.size,100 * param2.size);
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = userData(_loc4_.GetUserData());
            if((Boolean(_loc5_)) && Boolean(_loc5_.trigger is PaintBrush) && _loc4_.GetLinearVelocity().Length() > 10)
            {
               PaintBrush(_loc5_.trigger).OnCollision(param1,null,null,100,_loc4_.GetPosition(),new b2Vec2());
            }
         }
      }
   }
}

