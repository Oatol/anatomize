package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class CorrosionSword extends Trigger
   {
      
      public function CorrosionSword()
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
            param2.triggered = false;
            return;
         }
         param2.triggered = false;
         param2.triggerDuration = param2.originalTriggerDuration;
         if(param2.triggerDuration <= 10)
         {
            param2.triggerDuration = 10;
         }
         var _loc3_:b2Vec2 = new b2Vec2(0,-10 * param2.size);
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc5_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
         GameState.objects.addbullet("neurogas",(_loc5_.x + (Math.random() * 100 - 50) * param2.size) / Physics.scale,(_loc5_.y + (Math.random() * 100 - 50) * param2.size) / Physics.scale,0,1,1,new b2Vec2(bodyVel.x * 0.1,bodyVel.y * 0.1),10,param1);
      }
      
      override public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
         super.OnSharp(param1);
         if(!userData(param1.GetUserData()).alive)
         {
            return;
         }
         ud.triggerState = 1;
         ud.triggered = true;
      }
   }
}

