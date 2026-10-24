package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class JetGoblet extends Trigger
   {
      
      internal var jetW:Number;
      
      internal var jetH:Number;
      
      internal var jetY:Number;
      
      public function JetGoblet(param1:Number = 20, param2:Number = 144, param3:Number = 24)
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
         var _loc8_:b2Vec2 = null;
         var _loc9_:b2Vec2 = null;
         var _loc10_:String = null;
         var _loc11_:Array = null;
         var _loc12_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:Number = bodyCenter.x * Physics.scale;
         var _loc4_:Number = bodyCenter.y * Physics.scale;
         var _loc7_:int = 0;
         while(_loc7_ < 2)
         {
            _loc8_ = BoxUtils.rotateVec(new b2Vec2((Math.random() * this.jetW - this.jetW * 0.5) * param2.size,-this.jetY * param2.size),bodyAngle);
            _loc9_ = BoxUtils.rotateVec(new b2Vec2(0,-this.jetH * param2.size),bodyAngle);
            _loc5_ = new b2Vec2(_loc3_ + _loc8_.x,_loc4_ + _loc8_.y);
            _loc6_ = new b2Vec2(_loc3_ + _loc9_.x,_loc4_ + _loc9_.y);
            _loc10_ = "poof";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc10_ = param2.pfx.getParticle();
            }
            GameState.particles.addParticles(_loc5_.x,_loc5_.y,1,_loc10_,(-_loc5_.x + _loc6_.x) * 0.1,(-_loc5_.y + _loc6_.y) * 0.06,0,0);
            _loc7_++;
         }
         if(triggerDuration <= 0)
         {
            _loc11_ = GameState.cutter.CustomRaycast(_loc5_,100 * param2.size,_loc6_,false);
            _loc12_ = _loc11_[0];
            if((Boolean(_loc12_)) && !_loc12_.IsStatic())
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

