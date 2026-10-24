package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PoisonBullet extends GenericBullet
   {
      
      public function PoisonBullet()
      {
         super(null);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Body = null;
         var _loc6_:String = null;
         var _loc7_:userData = null;
         var _loc8_:b2Vec2 = null;
         super.trigger(param1,param2);
         var _loc3_:Number = param2.triggerRadius * param2.size;
         var _loc4_:Array = Body.GetAroundPoint(pixelCenter,_loc3_,_loc3_,false);
         for each(_loc5_ in _loc4_)
         {
            _loc7_ = userData(_loc5_.GetUserData());
            if(_loc7_.alive)
            {
               _loc7_.trigger = new Poisoned();
               _loc7_.triggered = true;
               _loc7_.triggerDuration = 45;
            }
         }
         _loc6_ = "poison";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc6_ = param2.pfx.getParticle();
         }
         if(triggerDuration)
         {
            param2.triggerDuration -= TimeLord.speed;
            if(param2.triggerDuration <= 0)
            {
               param2.triggered = false;
            }
         }
         if(Math.random() > 0.7)
         {
            _loc8_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,_loc3_ * 0.5,Math.random() * 360);
            GameState.particles.addParticles(_loc8_.x,_loc8_.y,1,_loc6_,pixelCenter.x - _loc8_.x + bodyVel.x,pixelCenter.y - _loc8_.y + bodyVel.y,0,0);
         }
      }
   }
}

