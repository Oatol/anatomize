package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class StingGrenade extends Trigger
   {
      
      public function StingGrenade()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc6_:b2Body = null;
         super.trigger(param1,param2);
         Body.Destroy(param1,"functionality");
         sounds.play("explosion5",param1,pixelCenter);
         var _loc3_:Number = Vars.objRestitution;
         var _loc4_:Number = Vars.objDensity;
         Vars.objRestitution = 1;
         Vars.objDensity = 10;
         var _loc5_:int = 0;
         while(_loc5_ < 20)
         {
            _loc6_ = GameState.objects.spawnItem(O.getItem("circle").vertices,[1],0.5 * param2.size,"circle",pixelCenter.x + Math.random() * 10 - 5,pixelCenter.y + Math.random() * 10 - 5,0,["circle"]);
            _loc6_.SetBullet(true);
            _loc6_.SetLinearVelocity(new b2Vec2(bodyVel.x * 0.5,bodyVel.y * 0.5));
            _loc6_.ApplyImpulse(new b2Vec2((Math.random() * triggerForce - triggerForce * 0.5) * _loc6_.GetMass() * param2.size,(Math.random() * triggerForce - triggerForce * 0.5) * _loc6_.GetMass() * param2.size),_loc6_.GetPosition());
            userData(_loc6_.GetUserData()).trigger = new TempProjectile(Math.random() * 60);
            userData(_loc6_.GetUserData()).triggered = true;
            _loc5_++;
         }
         Vars.objDensity = _loc4_;
         Vars.objRestitution = _loc3_;
      }
   }
}

