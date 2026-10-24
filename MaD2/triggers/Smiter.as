package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Smiter extends Rocket
   {
      
      public function Smiter()
      {
         super("shock",0);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = triggerPos;
         var _loc4_:b2Vec2 = param1.GetPosition();
         var _loc5_:Number = _loc3_.x - _loc4_.x;
         var _loc6_:Number = _loc3_.y - _loc4_.y;
         var _loc7_:b2Vec2 = param1.GetLinearVelocity();
         _loc7_.Multiply(2);
         if(_loc7_.Length() > 10)
         {
            this.OnTrigger();
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         ud.triggerLock = false;
         ud.triggered = false;
         ud.triggerLock = true;
         return true;
      }
      
      public function OnTrigger() : void
      {
         var _loc5_:userData = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:String = null;
         var _loc1_:b2Vec2 = pixelCenter;
         var _loc2_:Number = ud.triggerRadius * ud.size;
         var _loc3_:Array = Body.GetAroundPoint(_loc1_,_loc2_,_loc2_,false);
         var _loc4_:b2Body = _loc3_[Math.random() * _loc3_.length >> 0];
         if((Boolean(_loc4_)) && _loc4_ != body)
         {
            _loc5_ = userData(_loc4_.GetUserData());
            _loc5_.trigger = new Electrified();
            _loc5_.triggered = true;
            _loc5_.triggerDuration = 16;
            Body.Damage(_loc4_,Math.random() * 24 + 12,new b2Vec2(),new b2Vec2(),new b2Vec2(),false);
            _loc6_ = GeneralUtils.pointOnCircle(_loc1_.x,_loc1_.y,20 * ud.size,Math.random() * 360);
            _loc7_ = _loc4_.GetWorldCenter().Copy();
            _loc7_.Multiply(Physics.scale);
            _loc8_ = (_loc7_.y - _loc1_.y) / (_loc7_.x - _loc1_.x);
            _loc9_ = 2;
            _loc10_ = 0;
            while(_loc10_ < 10 * _loc9_)
            {
               _loc11_ = _loc6_.x + _loc10_ / (10 * _loc9_) * (_loc7_.x - _loc6_.x);
               _loc12_ = _loc6_.y + _loc8_ * (_loc11_ - _loc6_.x);
               _loc13_ = "shock";
               if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
               {
                  _loc13_ = ud.pfx.getParticle();
               }
               GameState.particles.addParticles(_loc11_,_loc12_,1,_loc13_,(-_loc6_.x + _loc11_) * 0.05,(-_loc6_.y + _loc12_) * 0.05,2 * _loc9_,2 * _loc9_);
               _loc10_++;
            }
         }
      }
   }
}

