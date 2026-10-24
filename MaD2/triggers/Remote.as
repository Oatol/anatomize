package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Remote extends Trigger
   {
      
      internal var trigBod:b2Body;
      
      public function Remote()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:b2Vec2 = null;
         var _loc12_:userData = null;
         super.trigger(param1,param2);
         if(!param2.flipped)
         {
            _loc3_ = new b2Vec2(-35 * param2.size,0.5 * param2.size);
            _loc4_ = new b2Vec2(-45 * param2.size,0.5 * param2.size);
         }
         else
         {
            _loc3_ = new b2Vec2(35 * param2.size,0.5 * param2.size);
            _loc4_ = new b2Vec2(45 * param2.size,0.5 * param2.size);
         }
         var _loc5_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc6_:b2Vec2 = BoxUtils.rotateVec(_loc4_,bodyAngle);
         var _loc7_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc5_.x,pixelCenter.y + _loc5_.y);
         var _loc8_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc6_.x,pixelCenter.y + _loc6_.y);
         var _loc9_:Array = GameState.cutter.CustomRaycast(_loc7_,triggerForce * param2.size,_loc8_,false);
         var _loc10_:b2Body = _loc9_[0];
         var _loc11_:Boolean = false;
         if(_loc9_[1])
         {
            GraphicUtils.efla(Main.instance.particlesBMD,_loc7_.x + camPos.x,_loc7_.y + camPos.y,b2Vec2(_loc9_[1]).x * Physics.scale + camPos.x,b2Vec2(_loc9_[1]).y * Physics.scale + camPos.y,4294901760);
         }
         else
         {
            GraphicUtils.efla(Main.instance.particlesBMD,_loc7_.x + camPos.x,_loc7_.y + camPos.y,_loc8_.x + camPos.x,_loc8_.y + camPos.y,4294901760);
         }
         if(_loc10_)
         {
            if(Boolean(this.trigBod) && _loc10_ != this.trigBod)
            {
               userData(this.trigBod.GetUserData()).triggered = false;
            }
            this.trigBod = _loc10_;
            _loc12_ = userData(_loc10_.GetUserData());
            _loc12_.triggered = true;
            _loc11_ = true;
         }
         if(Boolean(this.trigBod) && !_loc11_)
         {
            userData(this.trigBod.GetUserData()).triggered = false;
            this.trigBod = null;
         }
      }
      
      override public function onUntrigger() : void
      {
         super.onUntrigger();
         if(this.trigBod)
         {
            userData(this.trigBod.GetUserData()).triggered = false;
         }
      }
   }
}

