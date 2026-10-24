package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class RegenKit extends Trigger
   {
      
      public function RegenKit()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         var _loc5_:userData = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = userData(_loc4_.GetUserData());
            if(this.filter(_loc4_))
            {
               if(_loc5_.hasBeenCut)
               {
                  Body.FixBrokenItem(_loc4_);
               }
               else
               {
                  Body.GrowMissingBodypart(_loc4_);
               }
            }
         }
         param2.dead = true;
         Body.Disintegrate(param1,"heal",20,10,10);
      }
      
      protected function filter(param1:b2Body) : Boolean
      {
         var _loc2_:userData = userData(param1.GetUserData());
         if(!_loc2_.alive)
         {
            return false;
         }
         return true;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(!this.filter(param1))
         {
            return true;
         }
         ud.triggered = true;
         return true;
      }
   }
}

