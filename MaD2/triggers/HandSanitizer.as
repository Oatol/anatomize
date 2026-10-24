package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class HandSanitizer extends Trigger
   {
      
      public function HandSanitizer()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:b2Vec2 = null;
         var _loc5_:Vector.<Array> = null;
         var _loc6_:userData = null;
         var _loc7_:b2Body = null;
         super.trigger(param1,param2);
         if(Math.random() > 0.9)
         {
            _loc3_ = bodyAngle * Vars.toDegrees;
            if(_loc3_ % 360 > 60 && _loc3_ % 360 < 300 || _loc3_ % 360 > -300 && _loc3_ % 360 < -60)
            {
               _loc4_ = BoxUtils.rotateVec(param2.triggerPos,bodyAngle);
               _loc5_ = param2.skin;
               _loc6_ = Properties.objTemp("sanitizer");
               _loc6_.trigger = new Water();
               Water(_loc6_.trigger).setParticle("snow");
               _loc6_.triggered = true;
               _loc6_.projectileName = "gas";
               _loc6_.ignore = "sanitizer";
               _loc7_ = Spawn.circle(pixelCenter.x + _loc4_.x,pixelCenter.y + _loc4_.y,0.1,_loc6_,[1,1,1]);
               _loc7_.ApplyForce(new b2Vec2(bodyVel.x * 0.005,bodyVel.y * 0.005),_loc7_.GetWorldCenter());
            }
         }
      }
   }
}

