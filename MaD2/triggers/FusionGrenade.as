package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class FusionGrenade extends Trigger
   {
      
      public function FusionGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:int = 24;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,100 * param2.size,bodyAngle * Vars.toDegrees + _loc4_ * (360 / _loc3_));
            _loc6_ = Spawn.circle(_loc5_.x,_loc5_.y,1,Properties.objectProperties("pulse"),[0.01,1,1]);
            userData(_loc6_.GetUserData()).killOnContact = true;
            userData(_loc6_.GetUserData()).trigger = new ElectroSphere();
            userData(_loc6_.GetUserData()).triggerDuration = 1;
            userData(_loc6_.GetUserData()).triggerRadius = 150;
            userData(_loc6_.GetUserData()).ignore = "pulse";
            userData(_loc6_.GetUserData()).zerograv = true;
            userData(_loc6_.GetUserData()).shocking = true;
            userData(_loc6_.GetUserData()).resistShock = true;
            userData(_loc6_.GetUserData()).triggered = true;
            userData(_loc6_.GetUserData()).triggerLock = true;
            _loc6_.SetLinearVelocity(new b2Vec2((-pixelCenter.x + _loc5_.x) * 0.01,(-pixelCenter.y + _loc5_.y) * 0.01));
            _loc4_++;
         }
         param2.trigger = new Disintegrate("shock",100,20);
      }
   }
}

