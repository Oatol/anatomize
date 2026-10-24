package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class LaserAttachment extends MiscAttachment
   {
      
      private var origSpread:int;
      
      public function LaserAttachment()
      {
         super();
         hand1 = new b2Vec2(0,-15 / Physics.scale);
         ray1 = new b2Vec2(0,-25 / Physics.scale);
         rayRange = 4;
         equipRay = false;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         var _loc3_:int = 1;
         if(param1.GetUserData().flipped)
         {
            _loc3_ = -1;
         }
         var _loc4_:Number = Math.cos(bodyAngle) * _loc3_;
         var _loc5_:Number = Math.sin(bodyAngle) * _loc3_;
         var _loc6_:b2Vec2 = new b2Vec2(pixelCenter.x - 20 * _loc4_ * param2.size,pixelCenter.y - 20 * _loc5_ * param2.size);
         var _loc7_:b2Vec2 = new b2Vec2(pixelCenter.x - 25 * _loc4_ * param2.size,pixelCenter.y - 25 * _loc5_ * param2.size);
         var _loc8_:Array = GameState.cutter.CustomRaycast(_loc6_,triggerForce * param2.size,_loc7_,false);
         var _loc9_:Sprite = new Sprite();
         var _loc10_:uint = 16711680;
         var _loc11_:Vector.<Array> = param2.skin;
         if((Boolean(_loc11_)) && _loc11_.length > 0)
         {
            _loc10_ = BoxUtils.getSkinColour(_loc11_,"94002d");
         }
         _loc9_.graphics.lineStyle(1,_loc10_,0.5);
         _loc9_.graphics.beginFill(_loc10_,0.5);
         _loc9_.graphics.moveTo(GraphicUtils.camX(_loc6_.x) + camPos.x,GraphicUtils.camY(_loc6_.y) + camPos.y);
         _loc9_.graphics.lineTo(GraphicUtils.camX(_loc8_[1].x * Physics.scale) + camPos.x,GraphicUtils.camY(_loc8_[1].y * Physics.scale) + camPos.y);
         _loc9_.graphics.drawCircle(GraphicUtils.camX(_loc8_[1].x * Physics.scale) + camPos.x,GraphicUtils.camY(_loc8_[1].y * Physics.scale) + camPos.y,3 * Main.instance.cam.scaleX);
         Main.instance.particlesBMD.draw(_loc9_);
      }
      
      override public function OnJoint(param1:b2Body, param2:String) : Boolean
      {
         if(param2 != "weldjoint" && param2 != "equip")
         {
            return true;
         }
         if(!super.OnJoint(param1,param2))
         {
            return false;
         }
         if(!(userData(param1.GetUserData()).trigger is Gun))
         {
            return true;
         }
         if(!attachedFirearm)
         {
            return false;
         }
         this.origSpread = attachedFirearm.scatter;
         attachedFirearm.scatter *= 0.5;
         return true;
      }
      
      override public function OnDelete() : void
      {
         super.OnDelete();
         if(gunBody)
         {
            attachedFirearm.scatter = this.origSpread;
         }
      }
   }
}

