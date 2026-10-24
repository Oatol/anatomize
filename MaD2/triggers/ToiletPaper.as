package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ToiletPaper extends Trigger
   {
      
      public function ToiletPaper()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         param2.ignore = "toiletpaperresidue";
         param2.triggerDuration = 5;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration > 0)
         {
            return;
         }
         if(param1.GetLinearVelocity().Length() > param2.triggerForce && Math.random() > 0.9)
         {
            this.onUntrigger();
         }
      }
      
      override public function onUntrigger() : void
      {
         super.onUntrigger();
         if(ud.triggerDuration > 0)
         {
            return;
         }
         ud.triggerDuration = ud.originalTriggerDuration;
         var _loc1_:b2Vec2 = BoxUtils.randomPointOnBody(body);
         _loc1_.Multiply(Physics.scale);
         var _loc2_:b2Vec2 = body.GetLinearVelocity().Copy();
         var _loc3_:b2Body = GameState.objects.spawnObject("toiletpaperresidue",_loc1_.x,_loc1_.y,Math.atan2(_loc2_.y,_loc2_.x) * Vars.toDegrees,false,true,ud.skin);
         userData(_loc3_.GetUserData()).name = "toiletpaperresidue";
         userData(_loc3_.GetUserData()).ignore = "toiletpaperresidue";
         userData(_loc3_.GetUserData()).trigger = new TempProjectile(Math.random() * 20 + 20,Math.random() * 8 + 2,"gas");
         userData(_loc3_.GetUserData()).triggerOnContact = true;
         _loc2_.Multiply(Math.random() * 0.5 + 0.5);
         _loc3_.SetLinearVelocity(_loc2_);
         _loc3_.SetAngularVelocity(body.GetAngularVelocity() * 0.1);
         ud.triggered = true;
      }
   }
}

