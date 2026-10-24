package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class BrickMine extends Trigger
   {
      
      internal var victim:b2Body;
      
      public function BrickMine()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         super.trigger(param1,param2);
         if(!this.victim)
         {
            param2.triggered = false;
            return;
         }
         _loc3_ = [4281147,8087646,10394229,6308921];
         if(Boolean(param2.skin) && param2.skin.length > 0)
         {
            _loc3_ = ["41533b","7b685e","9e9a75","604439"];
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc3_[_loc4_] = BoxUtils.getSkinColour(param2.skin,_loc3_[_loc4_]);
               _loc4_++;
            }
         }
         Body.Brick(this.victim,Math.random() * 6 + 6,0.6,10,_loc3_);
         Body.Brick(param1,12,0.4,500,_loc3_);
         this.victim = null;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param1.IsStatic())
         {
            return true;
         }
         if(this.victim)
         {
            return true;
         }
         if(userData(param1.GetUserData()).name.indexOf("brick") != -1)
         {
            return true;
         }
         ud.triggered = true;
         this.victim = param1;
         return true;
      }
   }
}

