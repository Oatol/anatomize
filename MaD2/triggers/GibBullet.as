package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class GibBullet extends GenericBullet
   {
      
      internal var gibBody:b2Body;
      
      public function GibBullet()
      {
         super("spatter");
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(this.gibBody)
         {
            Body.Gib(this.gibBody);
            param2.dead = true;
            this.gibBody = null;
            return;
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(this.gibBody)
         {
            return false;
         }
         this.gibBody = param1;
         return true;
      }
   }
}

