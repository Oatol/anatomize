package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class SpawnItemsCraft extends SpawnItems
   {
      
      internal var targets:Array;
      
      public function SpawnItemsCraft()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         this.targets = customs["targets"].split(",");
         ud.triggered = false;
         ud.triggerLock = true;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(this.targets.indexOf(_loc7_.name) != -1)
         {
            ud.triggerLock = false;
            ud.triggered = true;
            _loc7_.dead = true;
            other = param1;
         }
         return true;
      }
   }
}

