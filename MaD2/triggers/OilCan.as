package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class OilCan extends Trigger
   {
      
      public function OilCan()
      {
         super();
      }
      
      public function explode(param1:b2Body, param2:userData) : *
      {
         var _loc4_:b2Body = null;
         var _loc5_:int = 0;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         for each(_loc4_ in _loc3_)
         {
            userData(_loc4_.GetUserData()).temperature = userData(_loc4_.GetUserData()).temperature + triggerForce * param2.size / BoxUtils.vectorDist(bodyCenter,_loc4_.GetPosition());
         }
         Body.Disintegrate(param1,"poof");
         _loc5_ = 0;
         while(_loc5_ < 80 * param2.size)
         {
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,1,"fire2",bodyVel.x * 0.1,bodyVel.y * 0.1,10 * param2.size,10 * param2.size);
            GameState.particles.addParticles(pixelCenter.x + Math.random() * 100 - 50,pixelCenter.y + Math.random() * 100 - 50,1,"fire3",bodyVel.x * 0.1,bodyVel.y * 0.1,10 * param2.size,10 * param2.size);
            _loc5_++;
         }
         sounds.play("incendiary",param1,pixelCenter);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:int = 0;
         var _loc4_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(triggerState == 2)
         {
            this.explode(param1,param2);
            return;
         }
         if(param2.burning || param2.temperature > 200)
         {
            param2.triggerState = 2;
         }
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration <= 0)
         {
            param2.triggerDuration = param2.originalTriggerDuration;
            param2.triggered = false;
         }
         if(Math.random() > 0.7)
         {
            _loc3_ = 1;
            if(param2.flipped)
            {
               _loc3_ = -1;
            }
            _loc4_ = BoxUtils.rotateVec(new b2Vec2(_loc3_ * param2.size * 55,param2.size * -36),bodyAngle);
            this.Spill(_loc4_);
         }
      }
      
      private function Spill(param1:b2Vec2) : void
      {
         var _loc5_:b2Body = null;
         var _loc6_:b2Body = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         var _loc2_:Vector.<Array> = ud.skin;
         var _loc3_:userData = Properties.objBurn("gasoline");
         _loc3_.saveable = false;
         _loc3_.trigger = new Oil();
         _loc3_.triggered = true;
         _loc3_.temperature = 30;
         _loc3_.ignition = 40;
         _loc3_.ignore = "oilcan";
         var _loc4_:Array = Body.GetAround(body,20,20,false);
         for each(_loc5_ in _loc4_)
         {
            if(userData(_loc5_.GetUserData()).burning)
            {
               _loc3_.ignition = _loc3_.temperature;
            }
         }
         _loc6_ = Spawn.circle(pixelCenter.x + param1.x,pixelCenter.y + param1.y,0.1,_loc3_,[1,1,1]);
         _loc7_ = new b2Vec2(bodyVel.x * 0.005,bodyVel.y * 0.005);
         _loc8_ = new b2Vec2(bodyCenter.x - _loc6_.GetPosition().x,bodyCenter.y - _loc6_.GetPosition().y);
         _loc8_.Add(new b2Vec2(Math.random() * 4 - 2,Math.random() * 4 - 2));
         _loc8_.Multiply(-0.005);
         _loc7_.Add(_loc8_);
         _loc6_.ApplyForce(_loc7_,_loc6_.GetWorldCenter());
      }
      
      override public function OnCut() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < 20)
         {
            this.Spill(new b2Vec2(Math.random() * 40 - 20,Math.random() * 40 - 20));
            _loc1_++;
         }
         return false;
      }
   }
}

