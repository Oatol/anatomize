package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Balloon extends Trigger
   {
      
      public function Balloon()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(0,-1 * param2.size),bodyAngle);
         _loc3_.Add(bodyCenter);
         param1.WakeUp();
         param1.ApplyForce(new b2Vec2(0,-param2.triggerForce * param1.GetMass()),_loc3_);
         param1.SetAngularVelocity(param1.GetAngularVelocity() * 0.95);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param4 > 800 * ud.size || param2.sharp || param2.sticky)
         {
            this.OnCut();
            return true;
         }
         return true;
      }
      
      override public function OnCut() : Boolean
      {
         ud.trigger = new DisintegratePowder(100,5);
         ud.triggered = true;
         return true;
      }
   }
}

