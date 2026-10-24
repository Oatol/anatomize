package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class RandomEffectOnHit extends Trigger
   {
      
      internal var bod:b2Body;
      
      public function RandomEffectOnHit()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(this.bod)
         {
            Body.RandomEffect(this.bod);
            this.bod = null;
            param2.triggered = false;
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(!ud.triggered)
         {
            return true;
         }
         if(param1.IsStatic())
         {
            return true;
         }
         ud.triggered = true;
         this.bod = param1;
         return true;
      }
   }
}

