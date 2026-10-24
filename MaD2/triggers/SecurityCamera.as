package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import caurina.transitions.Tweener;
   import flash.display.Sprite;
   
   public class SecurityCamera extends Trigger
   {
      
      private var decals:Sprite;
      
      internal var busy:Boolean = false;
      
      public function SecurityCamera()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc6_:b2Body = null;
         super.trigger(param1,param2);
         if(!this.decals)
         {
            this.decals = param2.graphic.getChildByName("decals") as Sprite;
         }
         if(!this.busy)
         {
            this.animate();
         }
         if(param2.triggerDuration <= 30)
         {
            param2.triggerDuration = 30;
         }
         param2.triggerPos.x = -param2.triggerRadius - 40;
         param2.triggerPos.y = param2.triggerRadius * 0.5;
         var _loc3_:int = 1;
         if(param2.flipped)
         {
            _loc3_ = -1;
         }
         var _loc4_:b2Vec2 = new b2Vec2(_loc3_ * param2.triggerPos.x,param2.triggerPos.y);
         _loc4_ = BoxUtils.rotateVec(_loc4_,bodyAngle);
         _loc4_.Add(pixelCenter);
         var _loc5_:Array = Body.GetAroundPoint(_loc4_,param2.triggerRadius,param2.triggerRadius);
         for each(_loc6_ in _loc5_)
         {
            if(_loc6_.GetLinearVelocity().Length() > param2.triggerForce * 0.1)
            {
               this.triggerconnected(true);
               break;
            }
         }
      }
      
      private function animate() : void
      {
         if(GameState.paused)
         {
            this.busy = false;
            return;
         }
         var _loc1_:Number = ud.triggerState == 1 ? 0 : -1;
         var _loc2_:Number = ud.triggerState == 1 ? 0 : -5;
         var _loc3_:Number = ud.triggerState == 1 ? 0 : -30;
         if(ud.flipped)
         {
            _loc1_ = ud.triggerState == 1 ? 0 : -2;
            _loc2_ *= -1;
            _loc3_ *= -1;
         }
         Tweener.addTween(this.decals,{
            "y":_loc2_,
            "x":_loc1_,
            "rotation":_loc3_,
            "time":ud.triggerDuration * 0.01,
            "transition":"easeInOutQuint",
            "onComplete":this.wait
         });
         ud.triggerState *= -1;
         this.busy = true;
      }
      
      private function wait() : void
      {
         Tweener.addTween(this.decals,{
            "time":ud.triggerDuration * 0.005,
            "onComplete":this.animate
         });
      }
      
      private function triggerconnected(param1:Boolean) : void
      {
         var _loc3_:b2Body = null;
         var _loc5_:userData = null;
         if(ud.connected.length == 0)
         {
            return;
         }
         var _loc2_:int = int(ud.connected.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = ud.connected[_loc4_];
            if(_loc3_)
            {
               _loc5_ = userData(_loc3_.GetUserData());
               _loc5_.triggered = param1;
            }
            _loc4_++;
         }
      }
   }
}

