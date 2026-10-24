package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class BrittleExplosion extends Explode
   {
      
      public function BrittleExplosion()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:Array = null;
         var _loc7_:b2Body = null;
         updateTriggerHelpers();
         var _loc3_:Number = 200;
         var _loc4_:Number = 4000;
         if(param2.triggerRadius)
         {
            _loc3_ = param2.triggerRadius;
         }
         if(param2.triggerForce)
         {
            _loc4_ = param2.triggerForce;
         }
         var _loc6_:int = 0;
         while(_loc6_ < 3)
         {
            _loc5_ = Body.GetAround(param1,_loc3_,_loc3_);
            for each(_loc7_ in _loc5_)
            {
               Body.brittle(_loc7_);
            }
            _loc6_++;
         }
         super.trigger(param1,param2);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(ud.triggerContact == 0)
         {
            return true;
         }
         if(param4 < ud.triggerContact)
         {
            return true;
         }
         ud.triggered = true;
         return true;
      }
   }
}

