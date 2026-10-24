package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PiggyBank extends Trigger
   {
      
      public function PiggyBank()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:String = null;
         var _loc6_:b2Body = null;
         super.trigger(param1,param2);
         ud.ghost = true;
         if(triggerDuration <= 0)
         {
            ud.dead = true;
            Body.Disintegrate(body,"inherit",100,4,4);
         }
         var _loc3_:Array = ["moneypack","diamond","goldbar","coin","coin","coin","coin","coin"];
         var _loc5_:String = "coiny";
         if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
         {
            _loc5_ = ud.pfx.getParticle();
         }
         GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,_loc5_,bodyVel.x * 0.1,bodyVel.y * 0.1 + 1,10,10);
         if(Math.random() > 0.8)
         {
            _loc4_ = _loc3_[_loc3_.length * Math.random() >> 0];
            _loc6_ = GameState.objects.spawnObject(_loc4_,pixelCenter.x,pixelCenter.y,Math.random() * 360,false,true);
            if(_loc6_)
            {
               --ud.triggerDuration;
               _loc6_.ApplyImpulse(new b2Vec2((Math.random() * 50 - 25) * _loc6_.GetMass(),(Math.random() * 50 - 25) * _loc6_.GetMass()),_loc6_.GetPosition());
               userData(_loc6_.GetUserData()).saveable = false;
               userData(_loc6_.GetUserData()).trigger = new TempProjectile(Math.random() * 360 + 60);
               userData(_loc6_.GetUserData()).triggerOnContact = true;
            }
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(!ud.triggered)
         {
            ud.triggerLock = false;
            ud.triggered = true;
            ud.triggerDuration = Math.random() * 24;
         }
         return true;
      }
      
      override public function OnCut() : Boolean
      {
         if(!ud.triggered)
         {
            ud.triggerLock = false;
            ud.triggered = true;
            ud.triggerDuration = Math.random() * 24;
         }
         return true;
      }
   }
}

