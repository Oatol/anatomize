package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class BigForceSword extends Trigger
   {
      
      public function BigForceSword()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(param2.triggerState == 0)
         {
            return;
         }
         param2.triggerState = 0;
         var _loc3_:b2Vec2 = new b2Vec2(0,-10 * param2.size);
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc5_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y);
         GameState.objects.addbullet("bfg",(_loc5_.x + (Math.random() * 100 - 50) * param2.size) / Physics.scale,(_loc5_.y + (Math.random() * 100 - 50) * param2.size) / Physics.scale,Math.random() * 360,1,1,new b2Vec2(bodyVel.x * 0.1,bodyVel.y * 0.1),100,param1);
      }
      
      override public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
         super.OnSharp(param1);
         if(param1.IsStatic())
         {
            return;
         }
         ud.triggered = true;
         ud.triggerState = 1;
      }
   }
}

