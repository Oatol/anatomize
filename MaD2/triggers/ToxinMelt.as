package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class ToxinMelt extends Trigger
   {
      
      public function ToxinMelt()
      {
         super();
         temporary = true;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:BitmapData = null;
         var _loc8_:Sprite = null;
         var _loc9_:b2Vec2 = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:int = 0;
         super.trigger(param1,param2);
         var _loc3_:Number = param2.width;
         var _loc4_:Number = param2.height;
         if(Math.random() > 0.9)
         {
            GameState.objects.addbullet("bane",(pixelCenter.x + (Math.random() * _loc3_ * 2 - _loc3_) * param2.size) / Physics.scale,(pixelCenter.y + (Math.random() * _loc4_ * 2 - _loc4_) * param2.size) / Physics.scale,0,1,1,bodyVel,50,param1);
         }
         if(param2.alive)
         {
            param2.triggerDuration -= TimeLord.speed;
            if(triggerDuration < 0)
            {
               param2.triggered = false;
               Body.Disintegrate(param1,"caustic",param2.health > 30 ? 30 : int(param2.health),triggerPos.x * 0.02 + 0.3,triggerPos.y * 0.02 + 0.3);
               _loc5_ = 0;
               while(_loc5_ < 10)
               {
                  GameState.objects.addbullet("bane",(pixelCenter.x + (Math.random() * _loc3_ - _loc3_ * 0.5) * param2.size) / Physics.scale,(pixelCenter.y + (Math.random() * _loc4_ - _loc4_ * 0.5) * param2.size) / Physics.scale,0,1,1,bodyVel,50,param1);
                  _loc5_++;
               }
            }
            else
            {
               if(param2.triggerDuration > param2.originalTriggerDuration - 2)
               {
                  return;
               }
               if(Math.random() > 0.7)
               {
                  _loc6_ = (120 - param2.triggerDuration) * 0.01;
                  param2.graphic.scaleX = 1 + (Math.random() * _loc6_ - _loc6_ * 0.5) * 0.3;
                  param2.graphic.scaleY = 1 + (Math.random() * _loc6_ - _loc6_ * 0.5) * 0.3;
                  if(Math.random() > 0.9)
                  {
                     _loc7_ = BoxUtils.getEffectBMD(param1);
                     if(_loc7_)
                     {
                        _loc8_ = new Sprite();
                        _loc8_.graphics.lineStyle(0,0,0);
                        _loc9_ = new b2Vec2();
                        _loc9_.x -= Bitmap(param2.graphic.getChildByName("effects")).x;
                        _loc9_.y -= Bitmap(param2.graphic.getChildByName("effects")).y;
                        _loc8_.graphics.beginFill(7185172,1);
                        _loc10_ = _loc9_.x + Math.random() * param2.width - param2.width * 0.5;
                        _loc11_ = _loc9_.y + Math.random() * param2.height - param2.height * 0.5;
                        _loc8_.graphics.drawCircle(_loc10_,_loc11_,Math.random() * 2 + 3);
                        _loc8_.graphics.beginFill(5407772,1);
                        _loc12_ = 0;
                        while(_loc12_ < 3)
                        {
                           _loc8_.graphics.drawCircle(_loc10_ + Math.random() * 4 - 2,_loc11_ + Math.random() * 4 - 2,Math.random() + 1);
                           _loc12_++;
                        }
                        _loc8_.graphics.endFill();
                        _loc7_.draw(_loc8_);
                     }
                  }
               }
            }
         }
      }
   }
}

