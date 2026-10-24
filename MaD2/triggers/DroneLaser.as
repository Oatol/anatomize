package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class DroneLaser extends Drone
   {
      
      public function DroneLaser()
      {
         super();
      }
      
      override protected function seek() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:userData = null;
         super.seek();
         var _loc3_:int = 0;
         while(_loc3_ < seekbodies.length)
         {
            _loc1_ = b2Body(seekbodies[_loc3_]);
            if(Math.random() > 0.8)
            {
               followBody(_loc1_);
               break;
            }
            _loc3_++;
         }
      }
      
      override protected function follow() : void
      {
         var _loc1_:b2Vec2 = null;
         var _loc2_:b2Vec2 = null;
         var _loc3_:Vector.<Array> = null;
         var _loc4_:uint = 0;
         var _loc5_:Sprite = null;
         super.follow();
         if(targetBody)
         {
            _loc1_ = bodyCenter;
            _loc2_ = targetBody.GetWorldCenter().Copy();
            _loc3_ = ud.skin;
            _loc4_ = 10031377;
            if(Boolean(_loc3_) && _loc3_.length > 0)
            {
               _loc4_ = BoxUtils.getSkinColour(_loc3_,"991111");
            }
            _loc5_ = new Sprite();
            _loc5_.graphics.lineStyle(2,_loc4_,Math.random());
            _loc5_.graphics.drawCircle(GraphicUtils.camX(pixelCenter.x) + camPos.x,GraphicUtils.camY(pixelCenter.y) + camPos.y,Math.random() * 10 * Main.instance.cam.scaleX);
            Main.instance.particlesBMD.draw(_loc5_);
         }
      }
      
      override protected function destroy() : Boolean
      {
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Vector.<MyLittleParticle> = null;
         var _loc15_:MyLittleParticle = null;
         if(!super.destroy())
         {
            return false;
         }
         var _loc1_:b2Vec2 = pixelCenter;
         var _loc2_:b2Vec2 = targetBody.GetWorldCenter().Copy();
         _loc2_.Multiply(Physics.scale);
         var _loc3_:Vector.<Array> = ud.skin;
         var _loc4_:uint = 4288221457;
         if(Boolean(_loc3_) && _loc3_.length > 0)
         {
            _loc4_ = 4278190080 + BoxUtils.getSkinColour(_loc3_,"991111");
         }
         var _loc5_:Number = _loc1_.x;
         var _loc6_:Number = _loc1_.y;
         var _loc7_:Number = _loc2_.x;
         var _loc8_:Number = _loc2_.y;
         var _loc9_:Number = (_loc8_ - _loc6_) / (_loc7_ - _loc5_);
         var _loc10_:String = "laser";
         if(Boolean(ud.pfx) && ud.pfx.replaceDefault)
         {
            _loc10_ = ud.pfx.getParticle();
         }
         var _loc11_:* = 50;
         while(_loc11_ > 0)
         {
            _loc12_ = _loc5_ + _loc11_ / 50 * (_loc7_ - _loc5_);
            _loc13_ = _loc6_ + _loc9_ * (_loc12_ - _loc5_);
            _loc14_ = GameState.particles.addParticles(_loc12_,_loc13_,1,_loc10_,(-_loc5_ + _loc12_) * 0.5,(-_loc6_ + _loc13_) * 0.5,0,0);
            if((Boolean(_loc14_)) && _loc14_.length > 0)
            {
               for each(_loc15_ in _loc14_)
               {
                  _loc15_.colour = _loc4_;
               }
            }
            _loc11_--;
         }
         GameState.madeby = "drone";
         GameState.cutter.ExcludeSingle(body);
         GameState.cutter.Cut(1,pixelCenter,_loc2_,ud.triggerRadius + 10,0.01);
         beginSeek();
         return true;
      }
   }
}

