package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class WormStaff extends Trigger
   {
      
      private var arm:b2Vec2;
      
      private var arm2:b2Vec2;
      
      private var arm3:b2Vec2;
      
      private var worms:Vector.<b2Vec2>;
      
      private var anchor:b2Vec2;
      
      private var anchor2:b2Vec2;
      
      private var anchor3:b2Vec2;
      
      public function WormStaff()
      {
         super();
         this.arm = new b2Vec2(Math.random() * 60 - 40,Math.random() * 60 - 30);
         this.arm2 = new b2Vec2(Math.random() * 60 - 30,Math.random() * 60 - 30);
         this.arm3 = new b2Vec2(Math.random() * 60 - 20,Math.random() * 60 - 30);
         this.worms = new Vector.<b2Vec2>();
         this.worms.push(this.arm,this.arm2,this.arm3);
         this.anchor = new b2Vec2(Math.random() * 60 - 40,Math.random() * 60 - 30);
         this.anchor2 = new b2Vec2(Math.random() * 60 - 30,Math.random() * 60 - 30);
         this.anchor3 = new b2Vec2(Math.random() * 60 - 20,Math.random() * 60 - 30);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Array = null;
         var _loc4_:userData = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Body = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:int = 0;
         super.trigger(param1,param2);
         if(Math.random() > 0.9)
         {
            if((triggerState == 1 || triggerState == -1) && Math.random() > 0.95)
            {
               ud.dead = true;
            }
            _loc3_ = Body.GetAround(body,ud.triggerRadius,ud.triggerRadius);
            for each(_loc6_ in _loc3_)
            {
               if(Math.random() >= 0.9)
               {
                  _loc4_ = userData(_loc6_.GetUserData());
                  if(!(!_loc4_ || !_loc4_.alive))
                  {
                     _loc7_ = Body.Bite(_loc6_);
                     _loc8_ = int(Math.random() * 3);
                     if(ud.triggerState == 1)
                     {
                        _loc8_ = 1;
                     }
                     _loc7_.x += _loc6_.GetPosition().x * Physics.scale - pixelCenter.x;
                     _loc7_.y += _loc6_.GetPosition().y * Physics.scale - pixelCenter.y;
                     this.worms[_loc8_].x = _loc7_.x;
                     this.worms[_loc8_].y = _loc7_.y;
                  }
               }
            }
         }
         if(ud.triggerState != -1)
         {
            this.Effect();
         }
      }
      
      internal function Effect() : *
      {
         var _loc1_:b2Vec2 = ud.triggerPos.Copy();
         _loc1_ = BoxUtils.rotateVec(_loc1_,bodyAngle);
         _loc1_.Add(new b2Vec2(pixelCenter.x + camPos.x,pixelCenter.y + camPos.y));
         var _loc2_:Sprite = new Sprite();
         var _loc3_:uint = BoxUtils.getSkinColour(ud.skin,"8b4854");
         if(_loc3_ == 16711935)
         {
            _loc3_ = 9128020;
         }
         this.arm.x += Math.random() * 6 - 3.5;
         this.arm.y += Math.random() * 6 - 3;
         this.anchor.x += Math.random() * 6 - 3.5;
         this.anchor.y += Math.random() * 6 - 3;
         this.arm2.x += Math.random() * 6 - 2.5;
         this.arm2.y += Math.random() * 6 - 3;
         this.anchor2.x += Math.random() * 6 - 2.5;
         this.anchor2.y += Math.random() * 6 - 3;
         this.arm3.x += Math.random() * 6 - 3;
         this.arm3.y += Math.random() * 6 - 3.5;
         this.anchor3.x += Math.random() * 6 - 3;
         this.anchor3.y += Math.random() * 6 - 3.5;
         this.arm.x *= 0.98;
         this.arm.y *= 0.98;
         this.anchor.x *= 0.98;
         this.anchor.y *= 0.98;
         this.arm2.x *= 0.98;
         this.arm2.y *= 0.98;
         this.anchor2.x *= 0.98;
         this.anchor2.y *= 0.98;
         this.arm3.x *= 0.98;
         this.arm3.y *= 0.98;
         this.anchor3.x *= 0.98;
         this.anchor3.y *= 0.98;
         if(ud.triggerState != 1)
         {
            _loc2_.graphics.lineStyle(4,_loc3_);
            _loc2_.graphics.moveTo(GraphicUtils.camX(_loc1_.x),GraphicUtils.camY(_loc1_.y));
            _loc2_.graphics.curveTo(GraphicUtils.camX(_loc1_.x + this.anchor.x),GraphicUtils.camY(_loc1_.y + this.anchor.y),GraphicUtils.camX(_loc1_.x + this.arm.x),GraphicUtils.camY(_loc1_.y + this.arm.y));
         }
         _loc2_.graphics.lineStyle(5,_loc3_);
         _loc2_.graphics.moveTo(GraphicUtils.camX(_loc1_.x),GraphicUtils.camY(_loc1_.y));
         _loc2_.graphics.curveTo(GraphicUtils.camX(_loc1_.x + this.anchor2.x),GraphicUtils.camY(_loc1_.y + this.anchor2.y),GraphicUtils.camX(_loc1_.x + this.arm2.x),GraphicUtils.camY(_loc1_.y + this.arm2.y));
         if(ud.triggerState != 1)
         {
            _loc2_.graphics.lineStyle(6,_loc3_);
            _loc2_.graphics.moveTo(GraphicUtils.camX(_loc1_.x),GraphicUtils.camY(_loc1_.y));
            _loc2_.graphics.curveTo(GraphicUtils.camX(_loc1_.x + this.anchor3.x),GraphicUtils.camY(_loc1_.y + this.anchor3.y),GraphicUtils.camX(_loc1_.x + this.arm3.x),GraphicUtils.camY(_loc1_.y + this.arm3.y));
         }
         Main.instance.particlesBMD.draw(_loc2_);
      }
   }
}

