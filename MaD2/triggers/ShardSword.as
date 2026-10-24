package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ShardSword extends Trigger
   {
      
      public function ShardSword()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:Vector.<b2Body> = Body.Decompose(param1);
         for each(_loc4_ in _loc3_)
         {
            _loc4_.ApplyImpulse(new b2Vec2((_loc4_.GetPosition().x - bodyCenter.x) * 100,(_loc4_.GetPosition().y - bodyCenter.y) * 100),_loc4_.GetPosition());
            _loc4_.m_linearDamping = 1;
            _loc4_.m_angularDamping = 1;
            userData(_loc4_.GetUserData()).name = "shard";
            userData(_loc4_.GetUserData()).sharp = true;
            userData(_loc4_.GetUserData()).projectile = true;
            userData(_loc4_.GetUserData()).triggerLock = false;
            userData(_loc4_.GetUserData()).trigger = new TempProjectile(Math.random() * 20 + 20);
            userData(_loc4_.GetUserData()).triggerOnContact = true;
            userData(_loc4_.GetUserData()).ignore = "shard";
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(!param3.sharp)
         {
            return false;
         }
         ud.triggerLock = false;
         ud.triggered = true;
         ud.triggerLock = true;
         return true;
      }
   }
}

