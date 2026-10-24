package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Parachute extends Trigger
   {
      
      public function Parachute()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(0,-1 * param2.size),bodyAngle);
         _loc3_.Add(bodyCenter);
         if(pixelCenter.y > GameState.height - param2.triggerRadius * param2.size)
         {
            if(triggerState == 2)
            {
               param2.trigger = new Disintegrate("poof",50,1);
            }
            return;
         }
         if(Math.abs(param1.GetAngle() % (Vars.PI * 2)) > 1.2)
         {
            return;
         }
         if(param1.GetLinearVelocity().y > 1)
         {
            param1.SetLinearVelocity(new b2Vec2(param1.GetLinearVelocity().x,param1.GetLinearVelocity().y * (100 - param2.triggerForce) / 100));
            param1.SetAngularVelocity(param1.GetAngularVelocity() * 0.95);
         }
      }
   }
}

