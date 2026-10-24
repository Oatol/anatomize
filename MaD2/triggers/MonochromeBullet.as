package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class MonochromeBullet extends Paint
   {
      
      internal var extract:Array;
      
      internal var other:b2Body;
      
      public function MonochromeBullet()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         kill = false;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(Math.random() > 0.8)
         {
            param2.dead = true;
         }
         if(param2.triggerState == 1 && Boolean(this.other))
         {
            Body.MeltIntoPaint(this.other,5 + Math.random() * param2.triggerForce);
            Body.Destroy(param1,"functionality");
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(param1.IsStatic())
         {
            ud.dead = true;
            return false;
         }
         ud.triggerState = 1;
         ud.ghost = true;
         this.other = param1;
         return super.OnCollision(param1,param2,param3,param4,param5,param6);
      }
   }
}

