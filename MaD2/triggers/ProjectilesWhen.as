package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ProjectilesWhen extends SpawnItems
   {
      
      internal var spawn:Boolean = false;
      
      internal var projectile:String;
      
      public function ProjectilesWhen()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration > 0)
         {
            return;
         }
         if(this.spawn)
         {
            if(Boolean(customs) && Boolean(customs["items"]))
            {
               super.trigger(param1,param2);
            }
            else
            {
               this.projectile = param2.triggerCustom;
               this.bullets();
            }
            param2.triggerDuration = param2.originalTriggerDuration;
         }
      }
      
      protected function bullets() : *
      {
         var _loc1_:b2Vec2 = null;
         var _loc3_:b2Vec2 = null;
         if(ud.triggerPos)
         {
            _loc3_ = triggerPos.Copy();
            _loc3_.Multiply(1 / Physics.scale);
            _loc1_ = bodyCenter;
            _loc1_.Add(_loc3_);
         }
         else
         {
            _loc1_ = BoxUtils.randomPointOnBody(body);
         }
         var _loc2_:Number = Math.random() * 1.5 + 0.5;
         if(ud.triggerRadius)
         {
            _loc2_ = 1;
            _loc2_ -= Math.random() * (ud.triggerRadius * 0.01);
            _loc2_ += Math.random() * (ud.triggerRadius * 0.01);
         }
         GameState.objects.addbullet(this.projectile,_loc1_.x,_loc1_.y,Math.random() * 360,1,_loc2_,bodyVel,Math.abs(body.GetAngularVelocity()) * 0.01,body);
      }
   }
}

