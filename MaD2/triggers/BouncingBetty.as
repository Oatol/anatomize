package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class BouncingBetty extends Trigger
   {
      
      public function BouncingBetty()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:b2Body = null;
         super.trigger(param1,param2);
         if(param2.triggerPos.x == 0 && param2.triggerPos.y == 0)
         {
            param2.triggerPos = bodyCenter.Copy();
            param1.WakeUp();
            param1.ApplyImpulse(new b2Vec2(Math.sin(bodyAngle) * param1.GetMass() * 40,Math.cos(bodyAngle) * -param1.GetMass() * 40),bodyCenter);
         }
         else if(BoxUtils.vectorDist(bodyCenter,param2.triggerPos) > 30 * param2.size)
         {
            param2.dead = true;
            Body.Disintegrate(param1,"poof");
            _loc3_ = 0;
            while(_loc3_ < 10 * param2.size)
            {
               _loc4_ = Math.random() > 0.5;
               _loc5_ = GameState.objects.spawnItem(O.getItem("circle").vertices,[1],0.2 * param2.size,"clustershrapnel",pixelCenter.x,pixelCenter.y,0,["clustershrapnel"]);
               userData(_loc5_.GetUserData()).killOnContact = true;
               userData(_loc5_.GetUserData()).trigger = new Trail();
               userData(_loc5_.GetUserData()).triggered = true;
               _loc5_.SetBullet(true);
               _loc5_.ApplyImpulse(new b2Vec2(Math.cos(bodyAngle) * Math.random() * (_loc4_ ? 200 : -200) * _loc5_.GetMass(),Math.sin(bodyAngle) * Math.random() * (_loc4_ ? 200 : -200) * _loc5_.GetMass()),_loc5_.GetPosition());
               _loc3_++;
            }
         }
      }
   }
}

