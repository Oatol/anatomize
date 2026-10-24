package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class BeamBullet extends Trigger
   {
      
      public function BeamBullet()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(TimeLord.speed == 1 || Math.random() * TimeLord.speed < TimeLord.speed * 0.1)
         {
            if(bodyVel.Length() > 1)
            {
               _loc3_ = GeneralUtils.pointOnCircle(bodyCenter.x,bodyCenter.y,param2.triggerDuration / Physics.scale,Math.random() * 360);
               param2.triggerDuration += triggerRadius;
               if(param1)
               {
                  GameState.objects.addbullet("bea",_loc3_.x,_loc3_.y,0,1,1,new b2Vec2(bodyVel.x,bodyVel.y),0,param1);
               }
            }
         }
      }
   }
}

