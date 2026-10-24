package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class DroneBroken extends Drone
   {
      
      internal var dirx:Number = 0;
      
      internal var diry:Number = 0;
      
      internal var spin:Number = 0;
      
      internal var gravity:Number = 0;
      
      public function DroneBroken()
      {
         super();
      }
      
      override protected function seek() : void
      {
         state = "destroy";
      }
      
      override protected function destroy() : Boolean
      {
         if(Math.random() > 0.9)
         {
            this.Effect();
         }
         if(Math.random() > 0.95)
         {
            this.dirx = (Math.random() * 30 - 15) * 50;
         }
         if(Math.random() > 0.9)
         {
            this.gravity = Math.random() * Vars.gravity * 2;
         }
         if(Math.random() > 0.99)
         {
            this.diry = (Math.random() * 30 - 15) * 25;
         }
         if(Math.random() > 0.95)
         {
            this.spin = (Math.random() * 20 - 10) * 100;
         }
         if(this.spin > 0)
         {
            --this.spin;
         }
         else
         {
            ++this.spin;
         }
         fly(this.dirx,this.diry - this.gravity,this.spin);
         return true;
      }
      
      private function Effect() : void
      {
         var _loc9_:userData = null;
         var _loc10_:String = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc1_:Number = ud.triggerRadius;
         var _loc2_:Array = Body.GetAround(body,_loc1_,_loc1_,false);
         var _loc3_:b2Body = _loc2_[Math.random() * _loc2_.length >> 0];
         var _loc4_:b2Vec2 = new b2Vec2(pixelCenter.x + Math.random() * _loc1_ - _loc1_ * 0.5,pixelCenter.y + Math.random() * _loc1_ - _loc1_ * 0.5);
         if(Boolean(_loc3_) && _loc3_ != body)
         {
            _loc9_ = userData(_loc3_.GetUserData());
            if(_loc9_.trigger is Tesla)
            {
               return;
            }
            if(_loc9_.name == "electropulsegun")
            {
               return;
            }
            if(_loc9_.name == "shockwavemine")
            {
               return;
            }
            if(_loc9_.name == "electronicbottle")
            {
               return;
            }
            if(_loc9_.name == "bottleofzap")
            {
               return;
            }
            _loc9_.trigger = new Electrified();
            _loc9_.triggered = true;
            _loc9_.triggerDuration = Math.random() * 30 + 30;
            Body.Damage(_loc3_,Math.random() * 128 + 32,new b2Vec2(),new b2Vec2(),new b2Vec2(),false);
            _loc4_ = _loc3_.GetWorldCenter().Copy();
            _loc4_.Multiply(Physics.scale);
         }
         var _loc5_:b2Vec2 = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,20 * ud.size,Math.random() * 360);
         var _loc6_:Number = (_loc4_.y - pixelCenter.y) / (_loc4_.x - pixelCenter.x);
         var _loc7_:int = 2;
         var _loc8_:int = 0;
         while(_loc8_ < 20 * _loc7_)
         {
            _loc10_ = "shock";
            if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
            {
               _loc10_ = ud.pfx.getParticle();
            }
            _loc11_ = _loc5_.x + _loc8_ / (20 * _loc7_) * (_loc4_.x - _loc5_.x);
            _loc12_ = _loc5_.y + _loc6_ * (_loc11_ - _loc5_.x);
            GameState.particles.addParticles(_loc11_,_loc12_,1,_loc10_,(-_loc5_.x + _loc11_) * 0.05,(-_loc5_.y + _loc12_) * 0.05,2 * _loc7_,2 * _loc7_);
            _loc8_++;
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         this.dirx = (Math.random() * 30 - 15) * 50;
         this.gravity = Math.random() * Vars.gravity * 2;
         this.diry = (Math.random() * 30 - 15) * 25;
         this.spin = (Math.random() * 20 - 10) * 100;
         return true;
      }
   }
}

