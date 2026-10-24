package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ToxicBarrel extends Trigger
   {
      
      public function ToxicBarrel()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Body = null;
         var _loc7_:userData = null;
         super.trigger(param1,param2);
         if(Math.random() > 0.8)
         {
            _loc3_ = bodyAngle * Vars.toDegrees;
            if(_loc3_ % 360 > 60 && _loc3_ % 360 < 300 || _loc3_ % 360 > -300 && _loc3_ % 360 < -60)
            {
               _loc4_ = -1;
               if(param2.flipped)
               {
                  _loc4_ = 1;
               }
               _loc5_ = BoxUtils.rotateVec(new b2Vec2(param2.size * _loc4_ * 28,param2.size * -68),bodyAngle);
               _loc6_ = GameState.objects.spawnItem(O.getItem("circle").vertices,[1],0.2 * param2.size,"toxinbullet",pixelCenter.x + _loc5_.x,pixelCenter.y + _loc5_.y,0,["toxinbullet"],"toxinbullet");
               _loc7_ = userData(_loc6_.GetUserData());
               _loc7_.trigger = new ToxinBullet();
               _loc7_.triggered = true;
               _loc7_.triggerRadius = 30;
               _loc7_.resistPoison = true;
               _loc6_.ApplyForce(new b2Vec2(bodyVel.x * 0.01,bodyVel.y * 0.01),_loc6_.GetWorldCenter());
            }
         }
      }
   }
}

