package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class Napalmed extends Trigger
   {
      
      public function Napalmed()
      {
         super();
         temporary = true;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:BitmapData = null;
         var _loc4_:Sprite = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:int = 0;
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration <= 0)
         {
            param2.trigger.reset();
            return;
         }
         if(Math.random() > 0.95)
         {
            if(TimeLord.speed == 1 || Math.random() * TimeLord.speed < TimeLord.speed * 0.25)
            {
               Body.Damage(param1,20,pixelCenter,new b2Vec2(bodyVel.x * 0.01,bodyVel.y * 0.01),new b2Vec2(2,2),false);
               if(param2.temperature < 300)
               {
                  param2.temperature += 10;
               }
               if(!param2.alive && param2.temperature > 200)
               {
                  Main.instance.brittleArray.push(param1);
               }
               _loc3_ = BoxUtils.getEffectBMD(param1);
               if(_loc3_)
               {
                  _loc4_ = new Sprite();
                  _loc4_.graphics.lineStyle(0,0,0);
                  _loc5_ = new b2Vec2();
                  _loc5_.Multiply(Physics.scale);
                  _loc5_.x -= Bitmap(param2.graphic.getChildByName("effects")).x;
                  _loc5_.y -= Bitmap(param2.graphic.getChildByName("effects")).y;
                  _loc6_ = 0;
                  while(_loc6_ < 4)
                  {
                     if(!param2.alive || Math.random() > 0.3)
                     {
                        _loc4_.graphics.beginFill(2236962,Math.random());
                     }
                     else
                     {
                        _loc4_.graphics.beginFill(param2.bloodColour,Math.random());
                     }
                     _loc4_.graphics.drawCircle(_loc5_.x + Math.random() * param2.width - param2.width * 0.5,_loc5_.y + Math.random() * param2.height - param2.height * 0.5,Math.random() * 10 + 1);
                     _loc4_.graphics.endFill();
                     _loc6_++;
                  }
                  _loc3_.draw(_loc4_);
               }
            }
         }
      }
   }
}

