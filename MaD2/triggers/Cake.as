package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Cake extends Trigger
   {
      
      public function Cake()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc17_:b2Body = null;
         var _loc18_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = bodyCenter;
         var _loc4_:Number = Math.cos(bodyAngle + Math.PI * 0.5);
         var _loc5_:Number = Math.sin(bodyAngle + Math.PI * 0.5);
         var _loc6_:Number = _loc3_.x * Physics.scale;
         var _loc7_:Number = _loc3_.y * Physics.scale;
         var _loc8_:b2Vec2 = new b2Vec2(param2.triggerPos.x * param2.size,param2.triggerPos.y * param2.size);
         var _loc9_:b2Vec2 = new b2Vec2(param2.triggerPos.x * param2.size,param2.triggerPos.y * param2.size - 10);
         var _loc10_:b2Vec2 = BoxUtils.rotateVec(_loc8_,bodyAngle);
         var _loc11_:b2Vec2 = BoxUtils.rotateVec(_loc9_,bodyAngle);
         var _loc12_:b2Vec2 = new b2Vec2(_loc6_ + _loc10_.x,_loc7_ + _loc10_.y);
         var _loc13_:b2Vec2 = new b2Vec2(_loc6_ + _loc11_.x,_loc7_ + _loc11_.y);
         var _loc14_:String = "fire2";
         var _loc15_:String = "fire3";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc14_ = param2.pfx.getParticle();
            _loc15_ = param2.pfx.getParticle();
         }
         GameState.particles.addParticles(_loc12_.x,_loc12_.y,1,_loc14_,bodyVel.x * 0.1,bodyVel.y * 0.1 + 1,0.1,0.1);
         GameState.particles.addParticles(_loc12_.x,_loc12_.y,1,_loc15_,bodyVel.x * 0.1,bodyVel.y * 0.1,0.1,0.1);
         var _loc16_:Array = GameState.cutter.CustomRaycast(_loc12_,10 * param2.size,_loc13_,true);
         if(_loc16_[0])
         {
            _loc17_ = b2Body(_loc16_[0]);
            if(_loc17_.GetUserData().temperature < 0)
            {
               _loc17_.GetUserData().temperature = _loc17_.GetUserData().temperature + 3;
            }
            else
            {
               _loc17_.GetUserData().temperature = _loc17_.GetUserData().temperature + 1.8;
            }
         }
         if(triggerState == 1 && Math.random() > 0.95)
         {
            _loc18_ = GameState.objects.addbullet("firework",(pixelCenter.x + Math.random() * param2.triggerRadius - param2.triggerRadius * 0.5) / Physics.scale,(pixelCenter.y + Math.random() * param2.triggerRadius - param2.triggerRadius * 0.5) / Physics.scale,Math.random() * 360,1,1,new b2Vec2(0,0),1,param1);
            userData(_loc18_.GetUserData()).triggerForce = Math.random() * 100;
            userData(_loc18_.GetUserData()).triggerDuration = Math.random() * 100;
         }
      }
   }
}

