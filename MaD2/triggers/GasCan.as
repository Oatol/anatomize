package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class GasCan extends Trigger
   {
      
      public function GasCan()
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
         param2.dead = true;
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
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Vector.<Array> = null;
         var _loc11_:userData = null;
         var _loc12_:Array = null;
         var _loc13_:b2Body = null;
         var _loc14_:b2Body = null;
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
         if(Math.random() > 0.7)
         {
            _loc3_ = bodyAngle * Vars.toDegrees;
            if(_loc3_ % 360 > 60 && _loc3_ % 360 < 300 || _loc3_ % 360 > -300 && _loc3_ % 360 < -60)
            {
               _loc4_ = 1;
               if(param2.flipped)
               {
                  _loc4_ = -1;
               }
               _loc5_ = BoxUtils.rotateVec(new b2Vec2(_loc4_ * param2.size * 18,param2.size * -30),bodyAngle);
               _loc6_ = BoxUtils.rotateVec(new b2Vec2(_loc4_ * param2.size * 15,param2.size * -30),bodyAngle);
               _loc7_ = (_loc6_.y - _loc5_.y) / (_loc6_.x - _loc5_.x);
               _loc8_ = _loc5_.x + Math.random() * (_loc6_.x - _loc5_.x);
               _loc9_ = _loc5_.y + _loc7_ * (_loc8_ - _loc5_.x);
               _loc10_ = param2.skin;
               _loc11_ = Properties.objBurn("gasoline");
               _loc11_.saveable = false;
               _loc11_.trigger = new Gasoline();
               _loc11_.triggered = true;
               _loc11_.temperature = 30;
               _loc11_.ignition = 40;
               _loc12_ = Body.GetAround(param1,20,20,false);
               for each(_loc13_ in _loc12_)
               {
                  if(userData(_loc13_.GetUserData()).burning)
                  {
                     _loc11_.ignition = _loc11_.temperature;
                  }
               }
               _loc14_ = Spawn.circle(pixelCenter.x + _loc8_,pixelCenter.y + _loc9_,0.1,_loc11_,[1,1,1]);
               _loc14_.ApplyForce(new b2Vec2(bodyVel.x * 0.005,bodyVel.y * 0.005),_loc14_.GetWorldCenter());
            }
         }
      }
      
      override public function OnCut() : Boolean
      {
         ud.triggerState = 2;
         return true;
      }
   }
}

