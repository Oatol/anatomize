package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class VoltGrip extends Trigger
   {
      
      internal var jetW:Number = 8;
      
      public function VoltGrip()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Vec2 = null;
         var _loc11_:b2Vec2 = null;
         var _loc12_:b2Vec2 = null;
         var _loc13_:b2Vec2 = null;
         var _loc14_:b2Vec2 = null;
         var _loc15_:b2Vec2 = null;
         var _loc16_:String = null;
         var _loc17_:userData = null;
         super.trigger(param1,param2);
         if(param1.GetLinearVelocity().Length() > 30)
         {
            _loc11_ = new b2Vec2(0,-10 * param2.size);
            _loc12_ = BoxUtils.rotateVec(_loc11_,bodyAngle);
            _loc13_ = new b2Vec2(pixelCenter.x + _loc12_.x,pixelCenter.y + _loc12_.y);
            GameState.objects.addbullet("tinyele",(_loc13_.x + (Math.random() * 100 - 50) * param2.size) / Physics.scale,(_loc13_.y + (Math.random() * 100 - 50) * param2.size) / Physics.scale,0,1,1,new b2Vec2(bodyVel.x * 10,bodyVel.y * 10),10,param1);
            return;
         }
         var _loc3_:Number = bodyCenter.x * Physics.scale;
         var _loc4_:Number = bodyCenter.y * Physics.scale;
         var _loc7_:int = 0;
         while(_loc7_ < 2)
         {
            _loc14_ = BoxUtils.rotateVec(new b2Vec2((Math.random() * this.jetW - this.jetW * 0.5) * param2.size,param2.triggerPos.y * param2.size),bodyAngle);
            _loc15_ = BoxUtils.rotateVec(new b2Vec2(0,-param2.triggerRadius * param2.size),bodyAngle);
            _loc5_ = new b2Vec2(_loc3_ + _loc14_.x,_loc4_ + _loc14_.y);
            _loc6_ = new b2Vec2(_loc3_ + _loc15_.x,_loc4_ + _loc15_.y);
            _loc5_.x += Math.random() * 20 - 10;
            _loc5_.y += Math.random() * 20 - 10;
            _loc6_.x += Math.random() * 20 - 10;
            _loc6_.y += Math.random() * 20 - 10;
            _loc16_ = "shock";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc16_ = param2.pfx.getParticle();
            }
            GameState.particles.addParticles(_loc5_.x,_loc5_.y,1,_loc16_,(-_loc5_.x + _loc6_.x) * 0.1,(-_loc5_.y + _loc6_.y) * 0.1,0,0);
            GameState.particles.addParticles(_loc5_.x,_loc5_.y,1,_loc16_,0,0,2,2);
            _loc7_++;
         }
         if(param2.triggerState != 0)
         {
            return;
         }
         var _loc8_:Array = GameState.cutter.CustomRaycast(_loc5_,1000 * param2.size,_loc6_,false);
         var _loc9_:Array = [];
         var _loc10_:b2Body = _loc8_[0];
         if((Boolean(_loc10_)) && _loc10_ != param1)
         {
            if(userData(_loc10_.GetUserData()).trigger is Tesla)
            {
               return;
            }
            _loc17_ = userData(_loc10_.GetUserData());
            _loc17_.trigger = new Electrified();
            _loc17_.triggered = true;
            _loc17_.triggerDuration = Math.random() * 30 + 30;
         }
      }
   }
}

