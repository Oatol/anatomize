package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class CeilingFan extends Trigger
   {
      
      internal var rays:int = 5;
      
      internal var angle:Number = 0;
      
      public function CeilingFan()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Object = null;
         super.init(param1,param2);
         if(ud.triggerCustom)
         {
            _loc3_ = ud.ParseTriggerCustom();
            this.rays = _loc3_["rays"];
            this.angle = _loc3_["angle"];
         }
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:b2Vec2 = null;
         var _loc10_:b2Vec2 = null;
         var _loc11_:b2Vec2 = null;
         var _loc12_:b2Vec2 = null;
         var _loc13_:Array = null;
         var _loc14_:Number = NaN;
         var _loc15_:String = null;
         var _loc16_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:Number = bodyAngle + this.angle * Vars.toRadians;
         var _loc4_:Number = bodyCenter.x * Physics.scale;
         var _loc5_:Number = bodyCenter.y * Physics.scale;
         var _loc6_:int = 0;
         while(_loc6_ < this.rays)
         {
            _loc7_ = (-param2.triggerPos.x + param2.triggerPos.x / Math.floor(this.rays / 2) * _loc6_) * param2.size;
            _loc8_ = param2.triggerPos.y * param2.size;
            _loc9_ = BoxUtils.rotateVec(new b2Vec2(_loc7_,_loc8_),_loc3_);
            _loc10_ = BoxUtils.rotateVec(new b2Vec2(_loc7_,_loc8_ + 1),_loc3_);
            _loc11_ = new b2Vec2(_loc4_ + _loc9_.x,_loc5_ + _loc9_.y);
            _loc12_ = new b2Vec2(_loc4_ + _loc10_.x,_loc5_ + _loc10_.y);
            _loc13_ = GameState.cutter.CustomRaycast(_loc11_,param2.triggerRadius * param2.size,_loc12_,false);
            _loc14_ = _loc3_ + Math.PI * 0.5;
            if(Math.random() > 0.9)
            {
               _loc15_ = "air";
               if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
               {
                  _loc15_ = param2.pfx.getParticle();
               }
               GameState.particles.addParticles(_loc11_.x,_loc11_.y,1,_loc15_,Math.cos(_loc14_) * param2.size,Math.sin(_loc14_) * param2.size,2 * Math.cos(_loc14_),2 * Math.sin(_loc14_));
            }
            if(_loc13_[0])
            {
               _loc16_ = b2Body(_loc13_[0]);
               if(_loc16_ == param1)
               {
                  return;
               }
               _loc16_.WakeUp();
               _loc16_.ApplyForce(new b2Vec2(triggerForce * Math.cos(_loc14_) * param2.size,triggerForce * Math.sin(_loc14_) * param2.size),b2Vec2(_loc13_[1]));
            }
            _loc6_++;
         }
      }
   }
}

