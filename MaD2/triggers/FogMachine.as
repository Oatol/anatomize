package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class FogMachine extends Trigger
   {
      
      public function FogMachine()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(Math.random() < 0.9)
         {
            return;
         }
         var _loc3_:b2Body = GameState.objects.spawnItem(O.getItem("circle").vertices,[1],2 * param2.size,"fog",pixelCenter.x,pixelCenter.y,0,["clustershrapnel"]);
         if(_loc3_)
         {
            userData(_loc3_.GetUserData()).trigger = new FogBullet();
            userData(_loc3_.GetUserData()).triggered = true;
            userData(_loc3_.GetUserData()).saveable = false;
            userData(_loc3_.GetUserData()).graphic.alpha = 0;
            _loc3_.SetLinearVelocity(new b2Vec2(bodyVel.x * 0.5,bodyVel.y * 0.5));
            _loc3_.ApplyImpulse(new b2Vec2((Math.random() * 80 - 40) * _loc3_.GetMass() * param2.size,(Math.random() * 80 - 40) * _loc3_.GetMass() * param2.size),_loc3_.GetPosition());
         }
      }
   }
}

