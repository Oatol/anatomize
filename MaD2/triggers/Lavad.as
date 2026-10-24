package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class Lavad extends Trigger
   {
      
      internal var dark:Boolean = false;
      
      public function Lavad()
      {
         super();
         temporary = true;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Array = null;
         var _loc4_:b2Body = null;
         var _loc5_:BitmapData = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:userData = null;
         var _loc8_:Sprite = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         super.trigger(param1,param2);
         if(Math.random() > 0.9)
         {
            BoxUtils.randomParticlesOnBody(param1,"lava",1);
            param2.temperature += 12;
            _loc3_ = Body.GetAround(param1,50,50);
            for each(_loc4_ in _loc3_)
            {
               _loc7_ = userData(_loc4_.GetUserData());
               _loc7_.temperature += 6;
               if(!_loc7_.resistScorching)
               {
                  if(_loc7_.temperature > 100)
                  {
                     if(!_loc7_.trigger || Boolean(_loc7_.trigger && !(_loc7_.trigger is Lavad)) && Boolean(!(_loc7_.trigger is Brimsword)))
                     {
                        _loc7_.ignition = 500;
                        _loc7_.trigger = new Lavad();
                        _loc7_.triggered = true;
                        _loc7_.triggerLock = true;
                     }
                  }
               }
            }
            if(param2.temperature > 400)
            {
               Body.Disintegrate(param1,"lava",40,1,1);
            }
            if(param2.alive)
            {
               Body.Damage(param1,12);
            }
            if(!param2.graphic)
            {
               return;
            }
            _loc5_ = BoxUtils.getEffectBMD(param1);
            _loc6_ = new b2Vec2();
            _loc6_.x -= Bitmap(param2.graphic.getChildByName("effects")).x;
            _loc6_.y -= Bitmap(param2.graphic.getChildByName("effects")).y;
            if(_loc5_)
            {
               if(!this.dark)
               {
                  _loc5_.fillRect(_loc5_.rect,4280947218);
                  this.dark = true;
               }
               _loc8_ = new Sprite();
               _loc8_.graphics.lineStyle(Math.random() * 2 + 2,16731392,Math.random() * 0.4 + 0.6);
               _loc9_ = Math.random() * (param2.width * 0.8) + param2.width * 0.1;
               _loc10_ = Math.random() * (param2.height * 0.8) + param2.height * 0.1;
               _loc11_ = Math.random() * (param2.width * 0.8) + param2.width * 0.1;
               _loc12_ = Math.random() * (param2.height * 0.8) + param2.height * 0.1;
               _loc8_.graphics.moveTo(_loc9_ + _loc6_.x,_loc10_ + _loc6_.y);
               _loc8_.graphics.lineTo(_loc11_ + _loc6_.x,_loc12_ + _loc6_.y);
               if(Math.random() > 0.6)
               {
                  _loc13_ = _loc11_ + Math.random() * (Math.random() * 100 - 50);
                  _loc14_ = _loc12_ + Math.random() * (Math.random() * 100 - 50);
                  _loc8_.graphics.lineTo(_loc13_,_loc14_);
               }
               _loc5_.draw(_loc8_);
            }
         }
      }
   }
}

