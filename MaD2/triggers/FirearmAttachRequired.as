package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2WeldJoint;
   import Box2D.Dynamics.b2Body;
   import Gun.Firearm;
   
   public class FirearmAttachRequired extends Gun
   {
      
      internal var reloaded:Number = 1;
      
      internal var customs:Object;
      
      protected var attachStart:b2Vec2;
      
      protected var attachEnd:b2Vec2;
      
      protected var attachRange:Number;
      
      public function FirearmAttachRequired(param1:Firearm)
      {
         super(param1);
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         super.init(param1,param2);
         this.customs = ud.ParseTriggerCustom();
         this.attachStart = new b2Vec2(0,15 / Physics.scale);
         this.attachEnd = new b2Vec2(0,25 / Physics.scale);
         this.attachRange = 4;
         if(this.customs["attachStart"])
         {
            _loc3_ = this.customs["attachStart"];
            _loc4_ = this.customs["attachEnd"];
            if(GeneralUtils.isStringVector(_loc3_))
            {
               this.attachStart = GeneralUtils.toVec(_loc3_);
            }
            if(GeneralUtils.isStringVector(_loc4_))
            {
               this.attachEnd = GeneralUtils.toVec(_loc4_);
            }
         }
         if(param2.flipped)
         {
            this.attachStart.x *= -1;
            this.attachEnd.x *= -1;
         }
         this.attachRange = BoxUtils.vectorDist(this.attachStart,this.attachEnd) * ud.size;
         this.attachStart.Multiply(1 / Physics.scale);
         this.attachEnd.Multiply(1 / Physics.scale);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         if(param2.triggerState == 1)
         {
            super.trigger(param1,param2);
         }
         else
         {
            this.AttachLine();
         }
      }
      
      private function AttachLine() : void
      {
         updateTriggerHelpers();
         var _loc1_:b2Vec2 = BoxUtils.rotateVec(this.attachStart,bodyAngle);
         _loc1_.Multiply(ud.size);
         _loc1_.Add(bodyCenter);
         _loc1_.Multiply(Physics.scale);
         var _loc2_:b2Vec2 = BoxUtils.rotateVec(this.attachEnd,bodyAngle);
         _loc2_.Add(bodyCenter);
         _loc2_.Multiply(Physics.scale);
         var _loc3_:Array = GameState.cutter.CustomRaycast(_loc1_,this.attachRange,_loc2_,true,"equip");
         if(_loc3_[1])
         {
            GraphicUtils.efla(Main.instance.particlesBMD,_loc1_.x + camPos.x,_loc1_.y + camPos.y,b2Vec2(_loc3_[1]).x * Physics.scale + camPos.x,b2Vec2(_loc3_[1]).y * Physics.scale + camPos.y,4294967295);
         }
         var _loc4_:b2Body = b2Body(_loc3_[0]);
         if(!_loc4_)
         {
            return;
         }
         if(_loc4_ == body)
         {
            return;
         }
         if(_loc4_.IsStatic())
         {
            return;
         }
         if(!(userData(_loc4_.GetUserData()).trigger is Gun))
         {
            return;
         }
         _loc1_.Multiply(1 / Physics.scale);
         var _loc5_:b2WeldJoint = Joints.Weld("equip",body,_loc4_,_loc1_);
      }
      
      override public function OnJoint(param1:b2Body, param2:String) : Boolean
      {
         var _loc3_:userData = param1.GetUserData();
         if(Boolean(_loc3_.trigger) && _loc3_.trigger is Gun)
         {
            ud.triggerState = 1;
            ud.triggered = false;
         }
         return super.OnJoint(param1,param2);
      }
   }
}

