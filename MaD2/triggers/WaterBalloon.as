package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class WaterBalloon extends Trigger
   {
      
      public function WaterBalloon()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:userData = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Body = null;
         super.trigger(param1,param2);
         Body.Destroy(param1,"waterballoon");
         var _loc3_:int = 36 * param2.size >> 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = Properties.objTemp("water");
            _loc5_.trigger = new Water();
            _loc5_.triggered = true;
            _loc5_.projectileName = "wat";
            _loc6_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,Math.random() * param2.size * 25,_loc4_ * (360 / _loc3_));
            _loc7_ = Spawn.circle(_loc6_.x,_loc6_.y,0.1,_loc5_,[1,1,1]);
            _loc7_.SetLinearVelocity(new b2Vec2(bodyVel.x * 0.5,bodyVel.y * 0.5));
            _loc7_.ApplyImpulse(new b2Vec2((Math.random() * 10 - 5) * _loc7_.GetMass() * param2.size,(Math.random() * 10 - 5) * _loc7_.GetMass() * param2.size),_loc7_.GetPosition());
            _loc4_++;
         }
      }
   }
}

