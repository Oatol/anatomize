package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class Lightsaber extends Trigger
   {
      
      public function Lightsaber()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Vec2 = null;
         var _loc13_:String = null;
         var _loc14_:Vector.<MyLittleParticle> = null;
         var _loc15_:MyLittleParticle = null;
         var _loc16_:Array = null;
         var _loc17_:b2Body = null;
         var _loc18_:Vector.<b2Body> = null;
         super.trigger(param1,param2);
         var _loc3_:Number = bodyCenter.x * Physics.scale;
         var _loc4_:Number = bodyCenter.y * Physics.scale;
         var _loc7_:Number = 100;
         if(param2.triggerForce)
         {
            _loc7_ = param2.triggerForce;
         }
         if(param2.flipped)
         {
            _loc5_ = BoxUtils.rotateVec(new b2Vec2(-20 * param2.size,0 * param2.size),bodyAngle);
            _loc6_ = BoxUtils.rotateVec(new b2Vec2(-(20 + _loc7_) * param2.size,0 * param2.size),bodyAngle);
         }
         else
         {
            _loc5_ = BoxUtils.rotateVec(new b2Vec2(20 * param2.size,0 * param2.size),bodyAngle);
            _loc6_ = BoxUtils.rotateVec(new b2Vec2((20 + _loc7_) * param2.size,0 * param2.size),bodyAngle);
         }
         var _loc8_:b2Vec2 = new b2Vec2(_loc3_ + _loc5_.x,_loc4_ + _loc5_.y);
         var _loc9_:b2Vec2 = new b2Vec2(_loc3_ + _loc6_.x,_loc4_ + _loc6_.y);
         var _loc10_:Sprite = new Sprite();
         var _loc11_:Vector.<Array> = param2.skin;
         var _loc12_:uint = 16711680;
         if(Boolean(_loc11_) && _loc11_.length > 0)
         {
            _loc12_ = BoxUtils.getSkinColour(_loc11_,"94002d");
         }
         _loc10_.graphics.lineStyle(4 * param2.size * GraphicUtils.cam.scaleX,_loc12_,Math.random() * 0.25 + 0.5);
         _loc10_.graphics.moveTo(GraphicUtils.camX(_loc8_.x) + camPos.x,GraphicUtils.camY(_loc8_.y) + camPos.y);
         _loc10_.graphics.lineTo(GraphicUtils.camX(_loc9_.x) + camPos.x,GraphicUtils.camY(_loc9_.y) + camPos.y);
         if(Math.random() > 0.8)
         {
            _loc13_ = "laser";
            if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
            {
               _loc13_ = param2.pfx.getParticle();
            }
            _loc14_ = BoxUtils.randomSlopeParticles(_loc13_,_loc8_,_loc9_,Math.random() * 5 + 5);
            if((Boolean(_loc14_)) && _loc14_.length > 0)
            {
               for each(_loc15_ in _loc14_)
               {
                  _loc15_.colour = 4278190080 + _loc12_;
                  _loc15_.health *= Math.random() * 2;
                  _loc15_.vx = bodyVel.x * Math.random();
                  _loc15_.vy = bodyVel.y * Math.random();
               }
            }
         }
         Main.instance.particlesBMD.draw(_loc10_);
         if(triggerDuration <= 0)
         {
            _loc16_ = GameState.cutter.CustomRaycast(_loc8_,_loc7_ * param2.size,_loc9_,false);
            _loc17_ = _loc16_[0];
            if((Boolean(_loc17_)) && !_loc17_.IsStatic())
            {
               _loc18_ = param2.ignored.slice();
               _loc18_.push(param1);
               GameState.cutter.Exclude(_loc18_);
               GameState.madeby = "lightsaber";
               GameState.cutter.Cut(1,_loc8_,_loc9_,_loc7_ * param2.size,0);
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

