package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class FrenchfryBox extends Trigger
   {
      
      public function FrenchfryBox()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(bodyVel.Length() < 50)
         {
            return;
         }
         if(Math.random() < 0.75)
         {
            return;
         }
         var _loc3_:b2Body = GameState.objects.spawnObject("frenchfry",pixelCenter.x,pixelCenter.y,Math.random() * 360,false,true);
         if(_loc3_)
         {
            _loc3_.ApplyImpulse(new b2Vec2((Math.random() * 50 - 25) * _loc3_.GetMass(),(Math.random() * 50 - 25) * _loc3_.GetMass()),_loc3_.GetPosition());
            userData(_loc3_.GetUserData()).saveable = false;
            userData(_loc3_.GetUserData()).trigger = new TempProjectile(Math.random() * 60 + 60);
            userData(_loc3_.GetUserData()).triggerOnContact = true;
         }
      }
   }
}

