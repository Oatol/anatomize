package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DisintegrateOnHit extends Trigger
   {
      
      internal var customs:Object;
      
      public function DisintegrateOnHit()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         this.customs = ud.ParseTriggerCustom();
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
         var _loc7_:userData = userData(param1.GetUserData());
         if(_loc7_.name == ud.ignore)
         {
            return true;
         }
         if(!_loc7_ || _loc7_.trigger is DisintegrateIntoItems)
         {
            return true;
         }
         _loc7_.triggerDuration = ud.triggerDuration;
         _loc7_.triggerCustom = ud.triggerCustom;
         _loc7_.trigger = new DisintegrateIntoItems();
         _loc7_.ghost = true;
         _loc7_.triggered = true;
         _loc7_.triggerLock = true;
         if(this.customs["destroy"])
         {
            ud.dead = true;
         }
         return true;
      }
   }
}

