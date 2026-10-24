package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class BFG extends Trigger
   {
      
      public function BFG()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:String = null;
         var _loc10_:userData = null;
         var _loc11_:b2Vec2 = null;
         var _loc12_:b2Vec2 = null;
         var _loc13_:Number = NaN;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         super.trigger(param1,param2);
         if(TimeLord.speed < 1 && Math.random() * TimeLord.speed > TimeLord.speed * 0.1)
         {
            return;
         }
         var _loc3_:b2Vec2 = param2.triggerPos.Copy();
         _loc3_.Multiply(param2.size);
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         _loc4_.Add(pixelCenter);
         _loc5_ = "shinygreen";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc5_ = param2.pfx.getParticle();
         }
         var _loc6_:b2Vec2 = new b2Vec2(Math.random() * 80 - 40,Math.random() * 16 - 8);
         _loc6_ = BoxUtils.rotateVec(_loc6_,bodyAngle);
         GameState.particles.addParticles(_loc4_.x + _loc6_.x,_loc4_.y + _loc6_.y,1,_loc5_,bodyVel.x * 0.1,bodyVel.y * 0.1,4,4);
         var _loc7_:Number = param2.triggerRadius / Physics.scale * param2.size;
         var _loc8_:Array = Body.GetMultiple(new b2Vec2(_loc4_.x / Physics.scale - _loc7_ * 0.5,_loc4_.y / Physics.scale - _loc7_ * 0.5),_loc7_,_loc7_,false);
         var _loc9_:b2Body = _loc8_[Math.random() * _loc8_.length >> 0];
         if((Boolean(_loc9_)) && _loc9_ != param1)
         {
            _loc10_ = userData(_loc9_.GetUserData());
            if(_loc10_.trigger is BFG)
            {
               return;
            }
            if(_loc10_.name == "bfg")
            {
               return;
            }
            if(_loc10_.name == "bfs")
            {
               return;
            }
            _loc11_ = GeneralUtils.pointOnCircle(_loc4_.x,_loc4_.y,20 * param2.size,Math.random() * 360);
            _loc12_ = _loc9_.GetWorldCenter().Copy();
            _loc12_.Multiply(Physics.scale);
            _loc13_ = (_loc12_.y - _loc4_.y) / (_loc12_.x - _loc4_.x);
            _loc14_ = 2;
            _loc5_ = "shinygreen";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc5_ = param2.pfx.getParticle();
            }
            _loc15_ = 0;
            while(_loc15_ < 20 * _loc14_)
            {
               _loc17_ = _loc11_.x + _loc15_ / (20 * _loc14_) * (_loc12_.x - _loc11_.x);
               _loc18_ = _loc11_.y + _loc13_ * (_loc17_ - _loc11_.x);
               GameState.particles.addParticles(_loc17_,_loc18_,1,_loc5_,(-_loc11_.x + _loc17_) * 0.05,(-_loc11_.y + _loc18_) * 0.05,2 * _loc14_,2 * _loc14_);
               _loc15_++;
            }
            _loc16_ = 0;
            while(_loc16_ < 10)
            {
               BoxUtils.randomParticlesOnBody(_loc9_,_loc5_,2);
               _loc16_++;
            }
            if(!_loc10_.alive)
            {
               _loc9_.WakeUp();
               _loc9_.ApplyImpulse(new b2Vec2(Math.random() * 1000 - 500 * _loc9_.GetMass(),Math.random() * 1000 - 500 * _loc9_.GetMass()),_loc9_.GetPosition());
               return;
            }
            Body.Damage(_loc9_,Math.random() * 600 + 200,new b2Vec2(),new b2Vec2(),new b2Vec2(),false);
            if(userData(_loc9_.GetUserData()).health < 100)
            {
               Body.Disintegrate(_loc9_,"blood",100,Math.random() * Math.random() * 50 + 5,Math.random() * Math.random() * 50 + 5);
            }
         }
      }
      
      override public function OnDelete() : void
      {
         var _loc3_:b2Body = null;
         var _loc4_:int = 0;
         var _loc5_:userData = null;
         var _loc6_:b2Vec2 = null;
         super.OnDelete();
         GameState.cutter.ExcludeSingle(body);
         World.explode("grenade",pixelCenter,ud.triggerForce * ud.size * 100,ud.triggerRadius * ud.size * 10,false,0);
         sounds.play("bfg",body,pixelCenter,1);
         var _loc1_:String = "shinygreen";
         if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
         {
            _loc1_ = ud.pfx.getParticle();
         }
         var _loc2_:Array = Body.GetAroundPoint(pixelCenter,ud.triggerRadius,ud.triggerRadius);
         for each(_loc3_ in _loc2_)
         {
            _loc5_ = userData(_loc3_.GetUserData());
            if(!(_loc5_.trigger is BFG))
            {
               if(_loc5_.name != "bfg")
               {
                  if(_loc5_.name != "bfs")
                  {
                     if(_loc5_.alive)
                     {
                        _loc4_ = 0;
                        while(_loc4_ < 10)
                        {
                           BoxUtils.randomParticlesOnBody(_loc3_,_loc1_,2);
                           _loc4_++;
                        }
                        Body.Disintegrate(_loc3_,"blood",100,Math.random() * Math.random() * 50 + 5,Math.random() * Math.random() * 50 + 5);
                     }
                     else
                     {
                        Body.Disintegrate(_loc3_,_loc1_,100,100,100);
                     }
                  }
               }
            }
         }
         _loc4_ = 0;
         while(_loc4_ < 100)
         {
            _loc6_ = new b2Vec2(Math.random() * ud.triggerRadius - ud.triggerRadius * 0.5,Math.random() * 16 - 8);
            _loc6_ = BoxUtils.rotateVec(_loc6_,bodyAngle);
            GameState.particles.addParticles(pixelCenter.x + _loc6_.x,pixelCenter.y + _loc6_.y,1,_loc1_,bodyVel.x * 0.1,bodyVel.y * 0.1,Math.random() * 100,Math.random() * 100);
            _loc4_++;
         }
      }
   }
}

