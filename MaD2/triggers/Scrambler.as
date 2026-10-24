package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class Scrambler extends Trigger
   {
      
      public function Scrambler()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc5_:b2Body = null;
         var _loc7_:b2Body = null;
         var _loc8_:Number = NaN;
         var _loc9_:b2Vec2 = null;
         var _loc10_:b2Vec2 = null;
         var _loc11_:uint = 0;
         var _loc12_:Vector.<b2Body> = null;
         var _loc13_:Sprite = null;
         super.trigger(param1,param2);
         var _loc3_:Array = Body.GetAround(param1,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         var _loc4_:int = 0;
         var _loc6_:Number = 9000;
         for each(_loc7_ in _loc3_)
         {
            if(param2.connected.indexOf(_loc7_) == -1)
            {
               if(userData(_loc7_.GetUserData()).connected.length != 0)
               {
                  _loc8_ = BoxUtils.vectorDist(bodyCenter,_loc7_.GetWorldCenter().Copy());
                  if(_loc8_ < _loc6_)
                  {
                     _loc5_ = _loc7_;
                     _loc6_ = _loc8_;
                  }
                  _loc4_++;
               }
            }
         }
         if(_loc4_ > 0)
         {
            _loc9_ = bodyCenter;
            _loc10_ = _loc5_.GetWorldCenter().Copy();
            _loc11_ = BoxUtils.getSkinColour(param2.skin,"9F2727");
            if(_loc11_ == 16711935)
            {
               _loc11_ = 10430247;
            }
            if(Math.random() > 0.9)
            {
               _loc13_ = new Sprite();
               _loc13_.graphics.lineStyle(Math.random() * Math.random() * 4 + 1,_loc11_,Math.random());
               _loc13_.graphics.moveTo(GraphicUtils.camX(_loc9_.x * Physics.scale) + camPos.x,GraphicUtils.camY(_loc9_.y * Physics.scale) + camPos.y);
               _loc13_.graphics.lineTo(GraphicUtils.camX(_loc10_.x * Physics.scale) + camPos.x,GraphicUtils.camY(_loc10_.y * Physics.scale) + camPos.y);
               Main.instance.particlesBMD.draw(_loc13_);
            }
            _loc12_ = userData(_loc5_.GetUserData()).connected;
            if(_loc12_.length > 0)
            {
               userData(_loc5_.GetUserData()).triggered = false;
               for each(_loc7_ in _loc12_)
               {
                  userData(_loc7_.GetUserData()).triggered = false;
                  _loc9_ = bodyCenter;
                  _loc10_ = _loc7_.GetWorldCenter().Copy();
                  if(Math.random() > 0.9)
                  {
                     _loc13_ = new Sprite();
                     _loc13_.graphics.lineStyle(Math.random() * Math.random() * 4 + 1,_loc11_,Math.random());
                     _loc13_.graphics.moveTo(GraphicUtils.camX(_loc9_.x * Physics.scale) + camPos.x,GraphicUtils.camY(_loc9_.y * Physics.scale) + camPos.y);
                     _loc13_.graphics.lineTo(GraphicUtils.camX(_loc10_.x * Physics.scale) + camPos.x,GraphicUtils.camY(_loc10_.y * Physics.scale) + camPos.y);
                     Main.instance.particlesBMD.draw(_loc13_);
                  }
               }
            }
         }
      }
   }
}

