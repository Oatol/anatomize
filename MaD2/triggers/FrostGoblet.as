package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class FrostGoblet extends Trigger
   {
      
      internal var jetW:Number;
      
      internal var jetH:Number;
      
      internal var jetY:Number;
      
      public function FrostGoblet(param1:Number = 10, param2:Number = 144, param3:Number = -10)
      {
         super();
         this.jetW = param1;
         this.jetH = param2;
         this.jetY = param3;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Vec2 = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Array = null;
         var _loc15_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:Number = bodyCenter.x * Physics.scale;
         var _loc4_:Number = bodyCenter.y * Physics.scale;
         var _loc7_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2((Math.random() * this.jetW - this.jetW * 0.5) * param2.size,-this.jetY * param2.size),bodyAngle);
         var _loc8_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(0,-this.jetH * param2.size),bodyAngle);
         _loc5_ = new b2Vec2(_loc3_ + _loc7_.x,_loc4_ + _loc7_.y);
         _loc6_ = new b2Vec2(_loc3_ + _loc8_.x,_loc4_ + _loc8_.y);
         var _loc9_:String = "frostfire";
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc9_ = param2.pfx.getParticle();
         }
         var _loc10_:int = 0;
         while(_loc10_ < 2)
         {
            _loc11_ = (_loc6_.y - _loc5_.y) / (_loc6_.x - _loc5_.x);
            _loc12_ = _loc5_.x + Math.random() * (_loc6_.x - _loc5_.x);
            _loc13_ = _loc5_.y + _loc11_ * (_loc12_ - _loc5_.x);
            GameState.particles.addParticles(_loc12_,_loc13_,1,_loc9_,(-_loc5_.x + _loc6_.x) * -0.02,(-_loc5_.y + _loc6_.y) * -0.02,0,0);
            _loc10_++;
         }
         if(triggerDuration <= 0)
         {
            _loc14_ = GameState.cutter.CustomRaycast(_loc5_,100 * param2.size,_loc6_,false);
            _loc15_ = _loc14_[0];
            if((Boolean(_loc15_)) && !_loc15_.IsStatic())
            {
               if(_loc15_ == param1)
               {
                  return;
               }
               Body.Frostfire(_loc15_);
               param2.triggerDuration = 4;
            }
         }
         else
         {
            --param2.triggerDuration;
         }
      }
   }
}

