package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class TemporaryRocket extends Rocket
   {
      
      public var durr:Number;
      
      public function TemporaryRocket(param1:String = "fire3", param2:Number = 20, param3:Number = 0.5)
      {
         super(param1,param3);
         this.durr = param2;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         ud.triggerLock = false;
         ud.triggerOnContact = true;
         ud.trigger = new TempProjectile(this.durr,1);
         ud.saveable = false;
         ud.triggered = true;
         return true;
      }
   }
}

