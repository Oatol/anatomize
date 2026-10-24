package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PaintBucket extends Trigger
   {
      
      public function PaintBucket()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:b2Vec2 = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Vector.<Array> = null;
         var _loc10_:String = null;
         var _loc11_:userData = null;
         var _loc12_:b2Body = null;
         super.trigger(param1,param2);
         if(Math.random() > 0.8)
         {
            _loc3_ = bodyAngle * Vars.toDegrees;
            if(_loc3_ % 360 > 60 && _loc3_ % 360 < 300 || _loc3_ % 360 > -300 && _loc3_ % 360 < -60)
            {
               _loc4_ = BoxUtils.rotateVec(new b2Vec2(param2.size * 16,param2.size * -24),bodyAngle);
               _loc5_ = BoxUtils.rotateVec(new b2Vec2(param2.size * -16,param2.size * -24),bodyAngle);
               _loc6_ = (_loc5_.y - _loc4_.y) / (_loc5_.x - _loc4_.x);
               _loc7_ = _loc4_.x + Math.random() * (_loc5_.x - _loc4_.x);
               _loc8_ = _loc4_.y + _loc6_ * (_loc7_ - _loc4_.x);
               _loc9_ = param2.skin;
               _loc10_ = "529bf4";
               if(Boolean(_loc9_) && _loc9_.length > 0)
               {
                  _loc10_ = BoxUtils.getSkinColour(_loc9_,"529bf4").toString(16);
               }
               while(_loc10_.length < 6)
               {
                  _loc10_ = "0" + _loc10_;
               }
               _loc11_ = Properties.objTemp(_loc10_);
               _loc11_.trigger = new Paint();
               _loc11_.triggered = true;
               _loc11_.killOnContact = true;
               _loc11_.projectileName = "pnt";
               _loc12_ = Spawn.circle(pixelCenter.x + _loc7_,pixelCenter.y + _loc8_,0.1,_loc11_,[1,1,1]);
               _loc12_.ApplyForce(new b2Vec2(bodyVel.x * 0.01,bodyVel.y * 0.01),_loc12_.GetWorldCenter());
            }
         }
      }
   }
}

