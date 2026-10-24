package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class SprayCan extends Trigger
   {
      
      public function SprayCan()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Vector.<Array> = null;
         var _loc5_:String = null;
         var _loc6_:userData = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:Number = NaN;
         var _loc9_:b2Vec2 = null;
         var _loc10_:b2Body = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(Math.random() > 0.5)
         {
            _loc3_ = bodyAngle * Vars.toDegrees;
            _loc4_ = param2.skin;
            _loc5_ = "529bf4";
            if(Boolean(_loc4_) && _loc4_.length > 0)
            {
               _loc5_ = BoxUtils.getSkinColour(_loc4_,"529bf4").toString(16);
            }
            while(_loc5_.length < 6)
            {
               _loc5_ = "0" + _loc5_;
            }
            _loc6_ = Properties.objTemp(_loc5_);
            _loc6_.trigger = new Paint();
            _loc6_.triggered = true;
            _loc6_.killOnContact = true;
            _loc6_.projectileName = "wat";
            _loc7_ = param2.triggerPos.Copy();
            if(param2.flipped)
            {
               _loc7_.x *= -1;
            }
            _loc7_.Multiply(param2.size);
            _loc8_ = bodyAngle;
            _loc9_ = BoxUtils.rotateVec(_loc7_,_loc8_);
            _loc10_ = Spawn.circle(pixelCenter.x + _loc9_.x,pixelCenter.y + _loc9_.y,2 * param2.size,_loc6_,[1,1,0]);
            _loc11_ = Math.random() * 4 - 2;
            _loc12_ = -param2.triggerForce;
            if(param2.flipped)
            {
               _loc12_ *= -1;
            }
            _loc13_ = new b2Vec2(_loc12_ * param2.size * Math.cos(_loc8_) + _loc11_,_loc12_ * param2.size * Math.sin(_loc8_) + _loc11_);
            _loc10_.SetLinearVelocity(_loc13_);
         }
      }
   }
}

