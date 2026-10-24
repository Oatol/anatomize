package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class RandomPropertiesOnHit extends Trigger
   {
      
      public function RandomPropertiesOnHit()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(Math.random() < 0.99)
         {
            return;
         }
         this.randomize();
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
         this.randomize();
         return true;
      }
      
      protected function randomize() : void
      {
         var _loc1_:int = ud.triggerForce;
         if(_loc1_ > 50)
         {
            _loc1_ = 50;
         }
         Body.RandomProperty(body,_loc1_);
      }
   }
}

