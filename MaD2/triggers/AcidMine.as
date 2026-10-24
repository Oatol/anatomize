package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class AcidMine extends Trigger
   {
      
      public function AcidMine()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(param2.triggerState != 1)
         {
            return;
         }
         var _loc3_:int = Math.random() * -9;
         var _loc4_:b2Vec2 = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,Math.random() * param2.triggerRadius * param2.size,bodyAngle * Vars.toDegrees + _loc3_ * 20);
         var _loc5_:b2Body = Spawn.circle(_loc4_.x,_loc4_.y,1,Properties.objectProperties("gas"),[0.01,1,1]);
         userData(_loc5_.GetUserData()).ghost = true;
         userData(_loc5_.GetUserData()).killOnContact = true;
         userData(_loc5_.GetUserData()).trigger = new NeuroBullet();
         userData(_loc5_.GetUserData()).triggerRadius = 100;
         userData(_loc5_.GetUserData()).triggered = true;
         userData(_loc5_.GetUserData()).triggerLock = true;
         _loc5_.SetLinearVelocity(new b2Vec2((-pixelCenter.x + _loc4_.x) * 0.1,(-pixelCenter.y + _loc4_.y) * 0.1));
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration <= 0)
         {
            param2.trigger = new Disintegrate("poisongas",100,20);
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param1.IsStatic())
         {
            return true;
         }
         ud.triggerState = 1;
         return true;
      }
   }
}

