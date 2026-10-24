package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ShockwaveGrenade extends Trigger
   {
      
      public function ShockwaveGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Vec2 = null;
         var _loc5_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:int = 0;
         while(_loc3_ < 18)
         {
            _loc4_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,100 * param2.size,bodyAngle * Vars.toDegrees + _loc3_ * 20);
            _loc5_ = Spawn.circle(_loc4_.x,_loc4_.y,5,Properties.objectProperties("pulse"),[0.01,1,1]);
            userData(_loc5_.GetUserData()).ghost = true;
            userData(_loc5_.GetUserData()).killOnContact = true;
            userData(_loc5_.GetUserData()).trigger = new Tesla();
            userData(_loc5_.GetUserData()).triggerRadius = 50;
            userData(_loc5_.GetUserData()).triggered = true;
            userData(_loc5_.GetUserData()).triggerLock = true;
            userData(_loc5_.GetUserData()).zerograv = true;
            _loc5_.SetLinearVelocity(new b2Vec2((-pixelCenter.x + _loc4_.x) * 0.01,(-pixelCenter.y + _loc4_.y) * 0.01));
            _loc3_++;
         }
         param2.trigger = new Disintegrate("shock",100,20);
      }
   }
}

