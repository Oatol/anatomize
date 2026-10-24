package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class SpaghettiInRadius extends Trigger
   {
      
      private var arms:Vector.<b2Vec2>;
      
      private var anchors:Vector.<b2Vec2>;
      
      internal var worms:int = 10;
      
      public function SpaghettiInRadius()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         var _loc3_:Number = 60;
         this.arms = new Vector.<b2Vec2>();
         this.anchors = new Vector.<b2Vec2>();
         var _loc4_:int = 0;
         while(_loc4_ < this.worms)
         {
            this.arms.push(new b2Vec2(Math.random() * _loc3_ - _loc3_ * 0.5,Math.random() * _loc3_ - _loc3_ * 0.5));
            this.anchors.push(new b2Vec2(Math.random() * _loc3_ - _loc3_ * 0.5,Math.random() * _loc3_ - _loc3_ * 0.5));
            _loc4_++;
         }
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Array = null;
         var _loc4_:userData = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Body = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:int = 0;
         var _loc9_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(Math.random() < 0.9)
         {
            _loc3_ = Body.GetAround(body,ud.triggerRadius,ud.triggerRadius);
            for each(_loc6_ in _loc3_)
            {
               if(Math.random() >= 0.9)
               {
                  _loc4_ = userData(_loc6_.GetUserData());
                  if(!(!_loc4_ || _loc4_.dead || _loc4_.projectile || ud.connected.indexOf(_loc6_) != -1 || ud.ignored.indexOf(_loc6_) != -1))
                  {
                     _loc7_ = Body.Slap(_loc6_);
                     _loc8_ = int(Math.random() * this.worms);
                     if(ud.triggerState == 1)
                     {
                        _loc8_ = 1;
                     }
                     _loc7_.x += _loc6_.GetPosition().x * Physics.scale - pixelCenter.x;
                     _loc7_.y += _loc6_.GetPosition().y * Physics.scale - pixelCenter.y;
                     this.arms[_loc8_].x = _loc7_.x;
                     this.arms[_loc8_].y = _loc7_.y;
                     _loc9_ = new b2Vec2(_loc7_.x,_loc7_.y);
                     _loc9_.Multiply(ud.triggerForce * 0.2);
                     _loc6_.ApplyForce(_loc9_,_loc7_);
                  }
               }
            }
         }
         this.Effect();
      }
      
      internal function Effect() : *
      {
         var _loc4_:Number = NaN;
         var _loc8_:b2Vec2 = null;
         var _loc9_:b2Vec2 = null;
         var _loc10_:int = 0;
         var _loc1_:b2Vec2 = ud.triggerPos.Copy();
         _loc1_ = BoxUtils.rotateVec(_loc1_,bodyAngle);
         _loc1_.Add(new b2Vec2(pixelCenter.x + camPos.x,pixelCenter.y + camPos.y));
         var _loc2_:Sprite = new Sprite();
         var _loc3_:uint = BoxUtils.getSkinColour(ud.skin,"b69f4c");
         if(_loc3_ == 16711935)
         {
            _loc3_ = 11968332;
         }
         _loc4_ = 20;
         var _loc5_:Number = 20;
         var _loc6_:* = 0.95;
         var _loc7_:* = 0.95;
         for each(_loc8_ in this.arms)
         {
            _loc8_.x += Math.random() * (Math.random() * _loc4_ - _loc4_ * 0.5);
            _loc8_.y += Math.random() * (Math.random() * _loc4_ - _loc4_ * 0.5);
            if(BoxUtils.vectorDist(ud.triggerPos,_loc8_) > ud.triggerRadius * ud.triggerRadius * 0.5)
            {
               _loc8_.Multiply(_loc6_);
            }
         }
         for each(_loc9_ in this.anchors)
         {
            _loc9_.x += Math.random() * (Math.random() * _loc5_ - _loc5_ * 0.5);
            _loc9_.y += Math.random() * (Math.random() * _loc5_ - _loc5_ * 0.5);
            if(BoxUtils.vectorDist(ud.triggerPos,_loc9_) > ud.triggerRadius * ud.triggerRadius * 0.5)
            {
               _loc9_.Multiply(_loc7_);
            }
         }
         _loc2_.graphics.lineStyle(Math.max(1,5 * ud.size),_loc3_);
         _loc10_ = 0;
         while(_loc10_ < this.worms)
         {
            _loc2_.graphics.moveTo(GraphicUtils.camX(_loc1_.x),GraphicUtils.camY(_loc1_.y));
            _loc2_.graphics.curveTo(GraphicUtils.camX(_loc1_.x + this.anchors[_loc10_].x),GraphicUtils.camY(_loc1_.y + this.anchors[_loc10_].y),GraphicUtils.camX(_loc1_.x + this.arms[_loc10_].x),GraphicUtils.camY(_loc1_.y + this.arms[_loc10_].y));
            _loc10_++;
         }
         Main.instance.particlesBMD.draw(_loc2_);
      }
   }
}

