package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DeleterFist extends ArmourGlove
   {
      
      private var sp:b2Vec2;
      
      internal var convert:b2Body;
      
      public function DeleterFist(param1:b2Body)
      {
         super(param1,400,0.2,0.5,100);
         collideWithDolls = true;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         if(!attachedBody && ud.triggerState == 1)
         {
            super.trigger(param1,param2);
            ud.triggerState = 0;
            ud.triggered = true;
            return;
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param3.name != "941f1f")
         {
            ud.triggerState = 1;
            ud.triggered = true;
            return true;
         }
         if(param1.IsStatic())
         {
            return true;
         }
         var _loc7_:userData = param1.GetUserData();
         if(!_loc7_ || _loc7_.dead)
         {
            return true;
         }
         _loc7_.trigger = new Disintegrate("delete",50,5);
         _loc7_.triggerLock = false;
         _loc7_.triggered = true;
         return true;
      }
      
      override public function OnDelete() : void
      {
         if(attachedBody)
         {
            userData(attachedBody.GetUserData()).trigger.reset();
         }
         super.OnDelete();
      }
   }
}

