package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class EntropySword extends Trigger
   {
      
      internal var jetW:Number;
      
      internal var jetH:Number;
      
      internal var jetY:Number;
      
      public function EntropySword(param1:Number = 20, param2:Number = 144, param3:Number = 24)
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
         var _loc13_:Array = null;
         var _loc14_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:Number = bodyCenter.x * Physics.scale;
         var _loc4_:Number = bodyCenter.y * Physics.scale;
         var _loc7_:uint = 11475996;
         _loc7_ = BoxUtils.getSkinColour(param2.skin,"AF1C1C");
         if(_loc7_ == 16711935)
         {
            _loc7_ = 11475996;
         }
         _loc7_ = 4278190080 + _loc7_;
         var _loc8_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2((Math.random() * this.jetW - this.jetW * 0.5) * param2.size,-this.jetY * param2.size),bodyAngle);
         var _loc9_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(0,-this.jetH * param2.size),bodyAngle);
         _loc5_ = new b2Vec2(_loc3_ + _loc8_.x,_loc4_ + _loc8_.y);
         _loc6_ = new b2Vec2(_loc3_ + _loc9_.x,_loc4_ + _loc9_.y);
         var _loc10_:Number = (_loc6_.y - _loc5_.y) / (_loc6_.x - _loc5_.x);
         var _loc11_:Number = _loc5_.x + Math.random() * (_loc6_.x - _loc5_.x);
         var _loc12_:Number = _loc5_.y + _loc10_ * (_loc11_ - _loc5_.x);
         GameState.particles.addSimpleParticles(_loc11_,_loc12_,1,_loc7_,(-_loc5_.x + _loc6_.x) * 0.02,Math.random() * (-_loc5_.y + _loc6_.y) * 0.02,0,0);
         if(triggerDuration <= 0)
         {
            _loc5_.x += (Math.random() * 30 - 15) * param2.size;
            _loc5_.y += (Math.random() * 30 - 15) * param2.size;
            _loc6_.x += (Math.random() * 30 - 15) * param2.size;
            _loc6_.y += (Math.random() * 30 - 15) * param2.size;
            _loc13_ = GameState.cutter.CustomRaycast(_loc5_,100 * param2.size,_loc6_,false);
            _loc14_ = _loc13_[0];
            if((Boolean(_loc14_)) && !_loc14_.IsStatic())
            {
               GameState.cutter.ExcludeSingle(param1);
               GameState.madeby = "laser";
               GameState.cutter.Cut(1,_loc5_,_loc6_,100 * param2.size,0);
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

