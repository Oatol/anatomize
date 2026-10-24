package triggers
{
   import Box2D.Dynamics.b2Body;
   
   public class ArrowBall extends Trigger
   {
      
      public function ArrowBall()
      {
         super();
      }
      
      override public function OnStick(param1:b2Body) : void
      {
         var _loc3_:int = 0;
         super.OnStick(param1);
         var _loc2_:userData = userData(param1.GetUserData());
         if(!param1.IsStatic())
         {
            userData(param1.GetUserData()).temperature = userData(param1.GetUserData()).temperature - 50;
         }
         if(_loc2_.temperature < 0 && _loc2_.temperature > -40)
         {
            Body.Freeze(param1);
            _loc3_ = 0;
            while(_loc3_ < 20)
            {
               GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,2,"crystal",bodyVel.x * 0.05,bodyVel.y * 0.05,bodyVel.x * 0.01 + Math.random() * 10,bodyVel.y * 0.01 + Math.random() * 10);
               _loc3_++;
            }
         }
      }
   }
}

