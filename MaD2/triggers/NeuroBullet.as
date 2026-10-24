package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class NeuroBullet extends GenericBullet
   {
      
      public function NeuroBullet()
      {
         super("poisongas");
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Body = null;
         var _loc6_:userData = null;
         param1.ApplyForce(new b2Vec2(0,-0.1),param1.GetPosition());
         super.trigger(param1,param2);
         var _loc3_:Number = param2.triggerRadius;
         if(TimeLord.speed == 1 || Math.random() * TimeLord.speed < TimeLord.speed * 0.25)
         {
            GameState.particles.addParticles(pixelCenter.x + Math.random() * _loc3_ - _loc3_ * 0.5,pixelCenter.y + Math.random() * _loc3_ - _loc3_ * 0.5,1,particle,0,0,0,0);
         }
         if(TimeLord.speed == 1 || Math.random() * TimeLord.speed < TimeLord.speed * 0.25)
         {
            if(Math.random() > 0.98)
            {
               param2.dead = true;
            }
         }
         var _loc4_:Array = Body.GetAroundPoint(pixelCenter,_loc3_,_loc3_,false);
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = userData(_loc5_.GetUserData());
            if(!_loc6_.resistPoison)
            {
               if(_loc6_.alive)
               {
                  Body.Damage(_loc5_,4 * TimeLord.speed + _loc6_.health * 0.005,null,null,null,false,false);
               }
            }
         }
      }
   }
}

