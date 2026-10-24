package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class LinkLinkedToRay extends Trigger
   {
      
      public function LinkLinkedToRay()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         if(!param2.triggerDuration)
         {
            param2.triggerDuration = 20;
         }
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Vec2 = null;
         var _loc10_:b2Vec2 = null;
         var _loc15_:b2Body = null;
         var _loc16_:userData = null;
         var _loc17_:b2Body = null;
         var _loc18_:userData = null;
         var _loc19_:Vector.<MyLittleParticle> = null;
         var _loc20_:MyLittleParticle = null;
         super.trigger(param1,param2);
         var _loc3_:Number = bodyCenter.x * Physics.scale;
         var _loc4_:Number = bodyCenter.y * Physics.scale;
         var _loc7_:Number = 100;
         if(param2.triggerForce)
         {
            _loc7_ = param2.triggerForce;
         }
         var _loc8_:Number = bodyAngle;
         if(param2.triggerCustom)
         {
            _loc8_ += Number(param2.triggerCustom);
         }
         if(param2.flipped)
         {
            _loc5_ = BoxUtils.rotateVec(new b2Vec2(-triggerPos.x * param2.size,triggerPos.y * param2.size),_loc8_);
            _loc6_ = BoxUtils.rotateVec(new b2Vec2(-(triggerPos.x * 1.1) * param2.size,triggerPos.y * 1.1 * param2.size),_loc8_);
         }
         else
         {
            _loc5_ = BoxUtils.rotateVec(new b2Vec2(triggerPos.x * param2.size,triggerPos.y * param2.size),_loc8_);
            _loc6_ = BoxUtils.rotateVec(new b2Vec2(triggerPos.x * 1.1 * param2.size,triggerPos.y * 1.1 * param2.size),_loc8_);
         }
         var _loc9_:b2Vec2 = new b2Vec2(_loc3_ + _loc5_.x,_loc4_ + _loc5_.y);
         _loc10_ = new b2Vec2(_loc3_ + _loc6_.x,_loc4_ + _loc6_.y);
         var _loc11_:Sprite = new Sprite();
         var _loc12_:Vector.<Array> = param2.skin;
         var _loc13_:uint = uint("0x" + param2.triggerColour);
         if(Boolean(_loc12_) && _loc12_.length > 0)
         {
            _loc13_ = BoxUtils.getSkinColour(_loc12_,param2.triggerColour);
         }
         var _loc14_:Array = GameState.cutter.CustomRaycast(_loc9_,_loc7_ * param2.size,_loc10_,true);
         _loc11_.graphics.lineStyle(4 * param2.size * GraphicUtils.cam.scaleX,_loc13_,Math.random() * 0.25 + 0.5);
         _loc11_.graphics.moveTo(GraphicUtils.camX(_loc9_.x) + camPos.x,GraphicUtils.camY(_loc9_.y) + camPos.y);
         _loc10_.x = _loc14_[1].x * Physics.scale;
         _loc10_.y = _loc14_[1].y * Physics.scale;
         if(triggerDuration <= 0)
         {
            _loc15_ = _loc14_[0];
            if((Boolean(_loc15_)) && !_loc15_.IsStatic())
            {
               _loc16_ = _loc15_.GetUserData();
               for each(_loc17_ in param2.connected)
               {
                  _loc18_ = userData(_loc17_.GetUserData());
                  _loc18_.connect(_loc15_);
                  if(param2.triggerState == 1)
                  {
                     _loc16_.connect(_loc17_);
                  }
                  _loc19_ = BoxUtils.randomSlopeParticles("laser",BoxUtils.pixelPosition(_loc17_),BoxUtils.pixelPosition(_loc15_));
                  for each(_loc20_ in _loc19_)
                  {
                     _loc20_.colour = 4278190080 + _loc13_;
                     _loc20_.health = 50;
                     _loc20_.friction = 0.9;
                     _loc20_.wanderX = 0;
                     _loc20_.wanderY = 0;
                  }
               }
               param2.triggerDuration = 10;
            }
         }
         else
         {
            param2.triggerDuration -= TimeLord.speed;
         }
         _loc11_.graphics.lineTo(GraphicUtils.camX(_loc10_.x) + camPos.x,GraphicUtils.camY(_loc10_.y) + camPos.y);
         Main.instance.particlesBMD.draw(_loc11_);
      }
   }
}

