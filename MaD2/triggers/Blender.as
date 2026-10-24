package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Blender extends Trigger
   {
      
      public function Blender()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc8_:b2Vec2 = null;
         var _loc9_:b2Vec2 = null;
         var _loc10_:b2Vec2 = null;
         var _loc11_:b2Vec2 = null;
         var _loc12_:b2Vec2 = null;
         var _loc13_:b2Vec2 = null;
         var _loc14_:Array = null;
         var _loc15_:b2Vec2 = null;
         var _loc16_:String = null;
         var _loc17_:Number = NaN;
         var _loc18_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:Number = Math.cos(bodyAngle + Math.PI * 0.5);
         var _loc4_:Number = Math.sin(bodyAngle + Math.PI * 0.5);
         var _loc5_:Number = bodyCenter.x * Physics.scale;
         var _loc6_:Number = bodyCenter.y * Physics.scale;
         var _loc7_:int = 1;
         while(_loc7_ < 5)
         {
            _loc8_ = new b2Vec2(-25 * param2.size + _loc7_ * 10 * param2.size,-35 * param2.size);
            _loc9_ = new b2Vec2(-25 * param2.size + _loc7_ * 10 * param2.size,-40 * param2.size);
            _loc10_ = BoxUtils.rotateVec(_loc8_,bodyAngle);
            _loc11_ = BoxUtils.rotateVec(_loc9_,bodyAngle);
            _loc12_ = new b2Vec2(_loc5_ + _loc10_.x,_loc6_ + _loc10_.y);
            _loc13_ = new b2Vec2(_loc5_ + _loc11_.x,_loc6_ + _loc11_.y);
            _loc14_ = GameState.cutter.CustomRaycast(_loc12_,20 * param2.size,_loc13_,true);
            if(Math.random() > 0.98)
            {
               _loc15_ = BoxUtils.rotateVec(new b2Vec2(0,-30 * param2.size),bodyAngle);
               _loc16_ = "shock";
               if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
               {
                  _loc16_ = param2.pfx.getParticle();
               }
               _loc17_ = bodyAngle + Vars.PI * 0.5;
               GameState.particles.addParticles(_loc12_.x,_loc12_.y,1,_loc16_,-2 * Math.cos(_loc17_),-2 * Math.sin(_loc17_),2 * Math.cos(_loc17_),2 * Math.sin(_loc17_));
            }
            if(_loc14_[0])
            {
               _loc18_ = b2Body(_loc14_[0]);
               if(_loc18_ == param1)
               {
                  return;
               }
               if(Math.random() > 0.9)
               {
                  Body.brittle(_loc18_);
               }
               else if(Boolean(_loc18_.GetUserData().alive) && Math.random() > 0.98)
               {
                  Body.Disintegrate(_loc18_,"blood",param1.GetUserData().maxhealth * 5,2,2);
               }
            }
            _loc7_++;
         }
      }
   }
}

