package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.BitmapData;
   
   public class Electrified extends Trigger
   {
      
      public function Electrified()
      {
         super();
         temporary = true;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:String = null;
         var _loc11_:BitmapData = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:uint = 0;
         var _loc15_:Array = null;
         var _loc16_:userData = null;
         var _loc17_:b2Body = null;
         super.trigger(param1,param2);
         if(param2.temperature < 0)
         {
            return;
         }
         if(param1.IsStatic() || !param2.saveable)
         {
            param2.triggered = false;
            return;
         }
         if(param2.resistShock)
         {
            param2.trigger.reset();
            return;
         }
         if(param2.triggerDuration <= 0)
         {
            if(param2.alive)
            {
               param2.stabilise = true;
            }
            param2.graphic.scaleX = 1;
            param2.graphic.scaleY = 1;
            param2.triggerLock = false;
            param2.trigger.reset();
            if(param2.trigger is Equip)
            {
               param2.trigger = new Unequip();
            }
            if(param2.trigger)
            {
               param2.triggered = true;
            }
            return;
         }
         param1.WakeUp();
         param2.triggerDuration -= Math.random() * TimeLord.speed + TimeLord.speed * 0.5;
         if(param2.triggerDuration > 0)
         {
            if(param2.alive)
            {
               param2.stabilise = false;
            }
         }
         if(TimeLord.speed == 1 || Math.random() * TimeLord.speed < TimeLord.speed * 0.25)
         {
            if(param2.alive)
            {
               Body.Damage(param1,4,null,null,null,false);
            }
            param1.SetLinearVelocity(new b2Vec2(bodyVel.x * 0.99,bodyVel.y * 0.99));
            _loc3_ = new b2Vec2(Math.random() - 0.5,Math.random() - 0.5);
            _loc3_.Multiply((Math.random() * 200 + 100) * param1.GetMass());
            param1.ApplyForce(_loc3_,bodyCenter);
            param2.graphic.scaleX = 1 + (Math.random() * 0.4 - 0.2);
            param2.graphic.scaleY = 1 + (Math.random() * 0.4 - 0.2);
         }
         if(param2.triggerDuration > 8)
         {
            _loc4_ = Math.random() * param2.width - param2.width * 0.5;
            _loc5_ = Math.random() * param2.height - param2.height * 0.5;
            _loc6_ = bodyCenter.x * Physics.scale + _loc4_ * Math.cos(bodyAngle) - _loc5_ * Math.sin(bodyAngle);
            _loc7_ = bodyCenter.y * Physics.scale + _loc4_ * Math.sin(bodyAngle) + _loc5_ * Math.cos(bodyAngle);
            _loc8_ = bodyVel.x * 0.1 + Math.random() * Math.random() * Math.random() * Math.random() * (Math.random() * 50 - 25);
            _loc9_ = bodyVel.y * 0.1 + Math.random() * Math.random() * Math.random() * Math.random() * (Math.random() * 50 - 25);
            _loc10_ = "shock";
            GameState.particles.addParticles(_loc6_,_loc7_,1,_loc10_,_loc8_,_loc9_,0,0);
         }
         if(Math.random() > 0.9)
         {
            _loc11_ = BoxUtils.getEffectBMD(param1);
            if(_loc11_)
            {
               _loc12_ = Math.random() * param2.width - 2 + 1;
               _loc13_ = Math.random() * param2.height - 2 + 1;
               _loc14_ = 1118481;
               if(param2.alive)
               {
                  _loc14_ += Math.random() * Math.random() * 128 << 16;
               }
               _loc11_.setPixel32(_loc12_,_loc13_,(Math.random() * 128 << 24) + _loc14_);
               _loc11_.setPixel32(_loc12_ + 1,_loc13_,(Math.random() * 128 << 24) + _loc14_);
               _loc11_.setPixel32(_loc12_ - 1,_loc13_,(Math.random() * 128 << 24) + _loc14_);
               _loc11_.setPixel32(_loc12_,_loc13_ + 1,(Math.random() * 128 << 24) + _loc14_);
               _loc11_.setPixel32(_loc12_,_loc13_ - 1,(Math.random() * 128 << 24) + _loc14_);
            }
         }
         if(Math.random() > 0.9)
         {
            _loc15_ = BoxUtils.connections(param1);
            for each(_loc17_ in _loc15_)
            {
               _loc16_ = userData(_loc17_.GetUserData());
               _loc16_.trigger = new Electrified();
               _loc16_.triggered = true;
               _loc16_.triggerDuration = Math.random() * param2.triggerDuration + param2.triggerDuration * 0.5;
            }
         }
         if(Math.random() > 0.99)
         {
            _loc15_ = Body.GetAround(param1,Math.min(100,param2.triggerDuration),Math.min(100,param2.triggerDuration));
            for each(_loc17_ in _loc15_)
            {
               if(Math.random() > 0.9)
               {
                  _loc16_ = userData(_loc17_.GetUserData());
                  _loc16_.trigger = new Electrified();
                  _loc16_.triggered = true;
                  _loc16_.triggerDuration = Math.random() * param2.triggerDuration + param2.triggerDuration * 0.5;
                  BoxUtils.randomSlopeParticles("shock",new b2Vec2(_loc17_.GetPosition().x * Physics.scale,_loc17_.GetPosition().y * Physics.scale),pixelCenter);
               }
            }
         }
      }
   }
}

