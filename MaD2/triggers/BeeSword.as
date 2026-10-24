package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class BeeSword extends Trigger
   {
      
      public function BeeSword()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(param2.triggerDuration > 0)
         {
            param2.triggerDuration -= TimeLord.speed;
            param2.triggerState = 0;
            return;
         }
         if(param2.triggerState == 0)
         {
            return;
         }
         param2.triggerDuration = param2.originalTriggerDuration;
         if(param2.triggerDuration <= 10)
         {
            param2.triggerDuration = 10;
         }
         var _loc3_:b2Vec2 = new b2Vec2(0,-10 * param2.size);
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc5_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
         var _loc6_:int = 0;
         while(_loc6_ < param2.triggerForce * 0.1)
         {
            GameState.objects.addbullet("bee",(_loc5_.x + (Math.random() * 100 - 50) * param2.size) / Physics.scale,(_loc5_.y + (Math.random() * 100 - 50) * param2.size) / Physics.scale,0,1,1,new b2Vec2(bodyVel.x,bodyVel.y),1,param1);
            _loc6_++;
         }
      }
      
      override public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
         super.OnSharp(param1);
         if(!userData(param1.GetUserData()).alive)
         {
            return;
         }
         ud.triggered = true;
         ud.triggerState = 1;
      }
   }
}

