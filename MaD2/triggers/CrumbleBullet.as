package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class CrumbleBullet extends Trigger
   {
      
      internal var crumble:b2Body;
      
      public function CrumbleBullet()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:Array = null;
         var _loc5_:b2Body = null;
         super.trigger(param1,param2);
         Body.brittle(this.crumble);
         var _loc3_:int = 0;
         while(_loc3_ < 3)
         {
            _loc4_ = Body.GetAround(body,20,20);
            for each(_loc5_ in _loc4_)
            {
               if(!(userData(_loc5_.GetUserData()).trigger is CrumbleBullet))
               {
                  Body.brittle(_loc5_);
               }
            }
            _loc3_++;
         }
         if(ud.triggerCustom != "noDelete")
         {
            ud.dead = true;
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc7_:userData = userData(param1.GetUserData());
         if(!_loc7_)
         {
            return false;
         }
         if(param1.IsStatic())
         {
            ud.dead = true;
            return true;
         }
         if(ud.ignored.indexOf(param1) != -1)
         {
            return true;
         }
         this.crumble = param1;
         ud.triggered = true;
         return true;
      }
   }
}

