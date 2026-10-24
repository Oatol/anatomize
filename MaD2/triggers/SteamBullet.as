package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class SteamBullet extends GenericBullet
   {
      
      public function SteamBullet()
      {
         trail = true;
         super("poof");
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         param1.ApplyForce(new b2Vec2(0,-10 * param1.GetMass()),bodyCenter);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         ud.triggerLock = false;
         ud.trigger = new JetGoblet(0.5 * ud.triggerForce,1.4 * ud.triggerForce,12);
         ud.triggerDuration = 0;
         ud.killOnContact = true;
         return true;
      }
   }
}

