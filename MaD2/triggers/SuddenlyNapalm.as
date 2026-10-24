package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class SuddenlyNapalm extends Rocket
   {
      
      internal var dur:Number;
      
      public function SuddenlyNapalm(param1:String = "fire3", param2:Number = 30)
      {
         super(param1);
         this.dur = param2;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(param2.triggerDuration)
         {
            param2.triggerDuration -= TimeLord.speed;
            if(param2.triggerDuration <= 0)
            {
               param2.triggerForce = 100;
               param2.trigger = new Thermite();
               param2.triggered = true;
            }
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         ud.triggerLock = false;
         ud.triggerDuration = Math.random() * this.dur + this.dur;
         return true;
      }
   }
}

