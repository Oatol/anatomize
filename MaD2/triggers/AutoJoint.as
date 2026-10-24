package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class AutoJoint extends Trigger
   {
      
      protected var attachedBody:b2Body;
      
      protected var attachedJoint:b2Joint;
      
      protected var rayRange:Number = 4;
      
      protected var walls:Boolean = false;
      
      protected var drawLine:Boolean = false;
      
      protected var destroy:Boolean = false;
      
      protected var lineThickness:* = 4;
      
      internal var light:Sprite;
      
      protected var customs:Object;
      
      internal var onlyFirearms:Boolean = false;
      
      public function AutoJoint()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         this.light = new Sprite();
         this.customs = ud.ParseTriggerCustom();
         if(this.customs["line"])
         {
            this.drawLine = true;
         }
         if(this.customs["onlyFirearms"])
         {
            this.onlyFirearms = true;
         }
         if(this.customs["lineThickness"])
         {
            this.lineThickness = this.customs["lineThickness"];
         }
         if(this.customs["destroy"])
         {
            this.destroy = true;
         }
         ud.ignored.push(body);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:b2Vec2 = null;
         super.trigger(param1,param2);
         this.light.graphics.clear();
         if(!this.attachedBody || userData(this.attachedBody.GetUserData()).dead || !this.attachedJoint || jointUserData(this.attachedJoint.GetUserData()).dead)
         {
            this.attachedBody = null;
            this.attachedJoint = null;
            var _loc5_:Number = bodyAngle;
            if(Boolean(this.customs) && Boolean(this.customs["angle"]))
            {
               _loc5_ += Number(this.customs["angle"]);
            }
            if(ud.flipped)
            {
               _loc3_ = BoxUtils.rotateVec(new b2Vec2(-triggerPos.x * ud.size,triggerPos.y * ud.size),_loc5_);
               _loc4_ = BoxUtils.rotateVec(new b2Vec2(-(triggerPos.x * 1.1) * ud.size,triggerPos.y * 1.1 * ud.size),_loc5_);
            }
            else
            {
               _loc3_ = BoxUtils.rotateVec(new b2Vec2(triggerPos.x * ud.size,triggerPos.y * ud.size),_loc5_);
               _loc4_ = BoxUtils.rotateVec(new b2Vec2(triggerPos.x * 1.1 * ud.size,triggerPos.y * 1.1 * ud.size),_loc5_);
            }
            _loc3_.Add(pixelCenter);
            _loc4_.Add(pixelCenter);
            if(Boolean(ud.ignored) && ud.ignored.length > 0)
            {
               GameState.cutter.Exclude(ud.ignored);
            }
            if(Boolean(ud.connected) && ud.connected.length > 0)
            {
               GameState.cutter.Include(ud.connected);
            }
            var _loc6_:Array = GameState.cutter.CustomRaycast(_loc3_,this.rayRange * ud.size,_loc4_,true);
            var _loc7_:Vector.<Array> = ud.skin;
            var _loc8_:uint = 16777215;
            if(ud.triggerColour)
            {
               _loc8_ = uint("0x" + ud.triggerColour);
            }
            if(Boolean(_loc7_) && _loc7_.length > 0)
            {
               _loc8_ = BoxUtils.getSkinColour(_loc7_,ud.triggerColour);
            }
            if(this.drawLine)
            {
               this.light.graphics.lineStyle(this.lineThickness * ud.size * GraphicUtils.cam.scaleX,_loc8_,Math.random() * 0.25 + 0.5);
               this.light.graphics.moveTo(GraphicUtils.camX(_loc3_.x),GraphicUtils.camY(_loc3_.y));
               this.light.graphics.lineTo(GraphicUtils.camX(_loc4_.x),GraphicUtils.camY(_loc4_.y));
               Main.instance.particlesBMD.draw(this.light);
            }
            var _loc9_:b2Body = b2Body(_loc6_[0]);
            if(!_loc9_)
            {
               return;
            }
            if(_loc9_ == body)
            {
               return;
            }
            if(!this.walls && _loc9_.IsStatic())
            {
               return;
            }
            var _loc10_:userData = _loc9_.GetUserData();
            if(_loc10_.projectile)
            {
               return;
            }
            if(this.onlyFirearms)
            {
               if(!_loc10_.trigger || !(_loc10_.trigger is Gun))
               {
                  return;
               }
            }
            _loc3_.Multiply(1 / Physics.scale);
            _loc4_.Multiply(1 / Physics.scale);
            if(this.CreateJoint(body,_loc9_,_loc3_,b2Vec2(_loc6_[1])))
            {
               this.attachedBody = _loc9_;
               if(Boolean(this.attachedJoint) && Boolean(this.customs) && Boolean(this.customs["temporary"]))
               {
                  ud.triggered = false;
               }
            }
            return;
         }
         if(Boolean(this.attachedJoint) && Boolean(this.customs) && Boolean(this.customs["temporary"]))
         {
            Joints.DestroyJoint(this.attachedJoint);
            this.attachedBody = null;
            this.attachedJoint = null;
            ud.triggered = false;
         }
      }
      
      protected function CreateJoint(param1:b2Body, param2:b2Body, param3:b2Vec2, param4:b2Vec2) : Boolean
      {
         this.attachedJoint = Joints.Weld("equip",param1,param2,param3);
         if(this.attachedJoint)
         {
            jointUserData(this.attachedJoint.GetUserData()).cuttable = false;
            return true;
         }
         return false;
      }
   }
}

