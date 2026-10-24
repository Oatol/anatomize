package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class DoubleLightsaber extends Trigger
   {
      
      public function DoubleLightsaber()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         var _loc17_:String = null;
         var _loc18_:Vector.<MyLittleParticle> = null;
         var _loc19_:MyLittleParticle = null;
         var _loc20_:Array = null;
         var _loc21_:Array = null;
         var _loc22_:b2Body = null;
         var _loc23_:b2Body = null;
         var _loc24_:Vector.<b2Body> = null;
         super.trigger(param1,param2);
         var _loc3_:Number = bodyCenter.x * Physics.scale;
         var _loc4_:Number = bodyCenter.y * Physics.scale;
         var _loc9_:Number = 100;
         if(param2.triggerForce)
         {
            _loc9_ = param2.triggerForce;
         }
         if(param2.flipped)
         {
            _loc5_ = BoxUtils.rotateVec(new b2Vec2(-38 * param2.size,0 * param2.size),bodyAngle);
            _loc6_ = BoxUtils.rotateVec(new b2Vec2((-38 - _loc9_) * param2.size,0 * param2.size),bodyAngle);
            _loc7_ = BoxUtils.rotateVec(new b2Vec2(38 * param2.size,0 * param2.size),bodyAngle);
            _loc8_ = BoxUtils.rotateVec(new b2Vec2((38 + _loc9_) * param2.size,0 * param2.size),bodyAngle);
         }
         else
         {
            _loc5_ = BoxUtils.rotateVec(new b2Vec2(38 * param2.size,0 * param2.size),bodyAngle);
            _loc6_ = BoxUtils.rotateVec(new b2Vec2((38 + _loc9_) * param2.size,0 * param2.size),bodyAngle);
            _loc7_ = BoxUtils.rotateVec(new b2Vec2(-38 * param2.size,0 * param2.size),bodyAngle);
            _loc8_ = BoxUtils.rotateVec(new b2Vec2((-38 - _loc9_) * param2.size,0 * param2.size),bodyAngle);
         }
         var _loc10_:b2Vec2 = new b2Vec2(_loc3_ + _loc5_.x,_loc4_ + _loc5_.y);
         var _loc11_:b2Vec2 = new b2Vec2(_loc3_ + _loc6_.x,_loc4_ + _loc6_.y);
         var _loc12_:b2Vec2 = new b2Vec2(_loc3_ + _loc7_.x,_loc4_ + _loc7_.y);
         var _loc13_:b2Vec2 = new b2Vec2(_loc3_ + _loc8_.x,_loc4_ + _loc8_.y);
         var _loc14_:Sprite = new Sprite();
         var _loc15_:Vector.<Array> = param2.skin;
         var _loc16_:uint = 16711680;
         if(Boolean(_loc15_) && _loc15_.length > 0)
         {
            _loc16_ = BoxUtils.getSkinColour(_loc15_,"94002d");
         }
         _loc14_.graphics.lineStyle(4 * param2.size * GraphicUtils.cam.scaleX,_loc16_,Math.random() * 0.25 + 0.5);
         _loc14_.graphics.moveTo(GraphicUtils.camX(_loc10_.x) + camPos.x,GraphicUtils.camY(_loc10_.y) + camPos.y);
         _loc14_.graphics.lineTo(GraphicUtils.camX(_loc11_.x) + camPos.x,GraphicUtils.camY(_loc11_.y) + camPos.y);
         _loc14_.graphics.lineStyle(4 * param2.size * GraphicUtils.cam.scaleX,_loc16_,Math.random() * 0.25 + 0.5);
         _loc14_.graphics.moveTo(GraphicUtils.camX(_loc12_.x) + camPos.x,GraphicUtils.camY(_loc12_.y) + camPos.y);
         _loc14_.graphics.lineTo(GraphicUtils.camX(_loc13_.x) + camPos.x,GraphicUtils.camY(_loc13_.y) + camPos.y);
         if(Math.random() > 0.9)
         {
            _loc17_ = "laser";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc17_ = param2.pfx.getParticle();
            }
            _loc18_ = BoxUtils.randomSlopeParticles(_loc17_,_loc10_,_loc11_,Math.random() * 5 + 5);
            if((Boolean(_loc18_)) && _loc18_.length > 0)
            {
               for each(_loc19_ in _loc18_)
               {
                  _loc19_.colour = 4278190080 + _loc16_;
                  _loc19_.health *= Math.random() * 2;
                  _loc19_.vx = bodyVel.x * Math.random();
                  _loc19_.vy = bodyVel.y * Math.random();
               }
            }
         }
         if(Math.random() > 0.9)
         {
            _loc17_ = "laser";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc17_ = param2.pfx.getParticle();
            }
            _loc18_ = BoxUtils.randomSlopeParticles(_loc17_,_loc12_,_loc13_,Math.random() * 5 + 5);
            if((Boolean(_loc18_)) && _loc18_.length > 0)
            {
               for each(_loc19_ in _loc18_)
               {
                  _loc19_.colour = 4278190080 + _loc16_;
                  _loc19_.health *= Math.random() * 2;
                  _loc19_.vx = bodyVel.x * Math.random();
                  _loc19_.vy = bodyVel.y * Math.random();
               }
            }
         }
         Main.instance.particlesBMD.draw(_loc14_);
         if(triggerDuration <= 0)
         {
            _loc20_ = GameState.cutter.CustomRaycast(_loc10_,_loc9_ * param2.size,_loc11_,false);
            _loc21_ = GameState.cutter.CustomRaycast(_loc12_,_loc9_ * param2.size,_loc13_,false);
            _loc22_ = _loc20_[0];
            _loc23_ = _loc21_[0];
            _loc24_ = param2.ignored.slice();
            _loc24_.push(param1);
            if(Boolean(_loc22_) && !_loc22_.IsStatic())
            {
               GameState.cutter.Exclude(_loc24_);
               GameState.madeby = "lightsaber";
               GameState.cutter.Cut(1,_loc10_,_loc11_,_loc9_ * param2.size,0);
               param2.triggerDuration = 4;
            }
            if(Boolean(_loc23_) && !_loc23_.IsStatic())
            {
               GameState.cutter.Exclude(_loc24_);
               GameState.madeby = "lightsaber";
               GameState.cutter.Cut(1,_loc12_,_loc13_,_loc9_ * param2.size,0);
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

