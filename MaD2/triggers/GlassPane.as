package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class GlassPane extends DisintegratePowder
   {
      
      public function GlassPane()
      {
         super(100,2,true);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(isNaN(ud.triggerForce) && param4 > 100)
         {
            ud.triggerLock = false;
            ud.triggered = true;
            ud.triggerLock = true;
            return true;
         }
         if(param4 > ud.triggerForce)
         {
            ud.triggerLock = false;
            ud.triggered = true;
            ud.triggerLock = true;
         }
         return true;
      }
      
      override public function OnCut() : Boolean
      {
         super.OnCut();
         ud.triggerLock = false;
         ud.triggered = true;
         ud.triggerLock = true;
         return true;
      }
   }
}

