package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class LightningRod extends Trigger
   {
      
      internal var jetW:Number = 10;
      
      public function LightningRod()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Vec2 = null;
         var _loc11_:b2Vec2 = null;
         var _loc12_:b2Vec2 = null;
         var _loc13_:String = null;
         var _loc14_:userData = null;
         super.trigger(param1,param2);
         var _loc3_:Number = bodyCenter.x * Physics.scale;
         var _loc4_:Number = bodyCenter.y * Physics.scale;
         var _loc7_:int = 0;
         while(_loc7_ < 2)
         {
            _loc11_ = BoxUtils.rotateVec(new b2Vec2((Math.random() * this.jetW - this.jetW * 0.5) * param2.size,param2.triggerPos.y * param2.size),bodyAngle);
            _loc12_ = BoxUtils.rotateVec(new b2Vec2(0,-param2.triggerRadius * param2.size),bodyAngle);
            _loc5_ = new b2Vec2(_loc3_ + _loc11_.x,_loc4_ + _loc11_.y);
            _loc6_ = new b2Vec2(_loc3_ + _loc12_.x,_loc4_ + _loc12_.y);
            _loc5_.x += Math.random() * 20 - 10;
            _loc5_.y += Math.random() * 20 - 10;
            _loc6_.x += Math.random() * 20 - 10;
            _loc6_.y += Math.random() * 20 - 10;
            _loc13_ = "shock";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc13_ = param2.pfx.getParticle();
            }
            GameState.particles.addParticles(_loc6_.x,_loc6_.y,1,_loc13_,(-_loc5_.x + _loc6_.x) * -0.1,(-_loc5_.y + _loc6_.y) * -0.1,0,0);
            GameState.particles.addParticles(_loc5_.x,_loc5_.y,1,_loc13_,0,0,2,2);
            if(Math.random() > 0.9)
            {
               GameState.particles.addParticles(_loc6_.x,_loc6_.y,1,"thundercloud",0,0,5,5);
            }
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
            _loc14_ = userData(_loc10_.GetUserData());
            _loc14_.trigger = new Electrified();
            _loc14_.triggered = true;
            _loc14_.triggerDuration = Math.random() * 30 + 30;
         }
      }
   }
}

