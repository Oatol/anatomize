package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class BlasterBullet extends Trigger
   {
      
      public function BlasterBullet()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(TimeLord.speed == 1 || Math.random() * TimeLord.speed < TimeLord.speed * 0.25)
         {
            if(bodyVel.Length() > 1)
            {
               GameState.objects.addbullet("las",bodyCenter.x,bodyCenter.y,0,1,1,new b2Vec2(bodyVel.x,bodyVel.y),0,param1);
            }
         }
      }
   }
}

