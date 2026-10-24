package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class BeltAttachment extends MiscAttachment
   {
      
      private var origBullet:String;
      
      private var origSize:Number;
      
      private var origReload:Number;
      
      private var origSounds:Array;
      
      private var origVol:Array;
      
      private var origBullets:Number;
      
      private var customs:Object;
      
      public function BeltAttachment()
      {
         super();
         attachmentID = 1000004;
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         super.init(param1,param2);
         this.customs = param2.ParseTriggerCustom();
         hand1 = new b2Vec2();
         ray1 = new b2Vec2(0,1);
         if(this.customs["fromX"])
         {
            hand1.x = Number(this.customs["fromX"]);
            hand1.y = Number(this.customs["fromY"]);
            ray1.x = Number(this.customs["toX"]);
            ray1.y = Number(this.customs["toY"]);
         }
         if(this.customs["attachStart"])
         {
            _loc3_ = this.customs["attachStart"];
            _loc4_ = this.customs["attachEnd"];
            if(GeneralUtils.isStringVector(_loc3_))
            {
               hand1 = GeneralUtils.toVec(_loc3_);
            }
            if(GeneralUtils.isStringVector(_loc4_))
            {
               ray1 = GeneralUtils.toVec(_loc4_);
            }
         }
         if(param2.flipped)
         {
            hand1.x *= -1;
            ray1.x *= -1;
         }
         hand1.Multiply(1 / Physics.scale);
         ray1.Multiply(1 / Physics.scale);
         rayRange = BoxUtils.vectorDist(hand1,ray1);
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
         this.Attach(param1);
         return true;
      }
      
      internal function Attach(param1:b2Body) : void
      {
         var _loc5_:Number = NaN;
         this.origSounds = attachedFirearm.soundNames.slice();
         this.origVol = attachedFirearm.soundVolumes.slice();
         this.origBullets = attachedFirearm.bulletAmount;
         this.origSize = attachedFirearm.bulletSize;
         this.origReload = attachedFirearm.reloadTime;
         this.origBullet = attachedFirearm.bulletType;
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:String = "original";
         _loc5_ = 0;
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         if(this.customs["sounds"])
         {
            _loc2_ = this.customs["sounds"].split(",");
         }
         if(this.customs["volumes"])
         {
            _loc3_ = this.customs["volumes"].split(",");
         }
         if(this.customs["projectile"])
         {
            _loc4_ = this.customs["projectile"];
         }
         if(this.customs["amount"])
         {
            _loc6_ = Number(this.customs["amount"]);
         }
         if(this.customs["size"])
         {
            _loc5_ = Number(this.customs["size"]);
         }
         if(this.customs["rate"])
         {
            _loc7_ = Number(this.customs["rate"]);
         }
         if(_loc2_.length > 0)
         {
            attachedFirearm.clearSounds();
            attachedFirearm.attachSounds(_loc2_,_loc3_);
         }
         if(_loc4_ != "original")
         {
            attachedFirearm.bulletType = _loc4_;
         }
         var _loc8_:Number = ud.triggerForce * 0.01;
         attachedFirearm.reloadTime = this.origReload * (1 - _loc8_);
         if(attachedFirearm.reloadTime < 1)
         {
            attachedFirearm.reloadTime = 1;
         }
         if(_loc6_ != 0)
         {
            attachedFirearm.bulletAmount = _loc6_;
         }
         if(_loc5_ != 0)
         {
            _loc5_ = Number(this.customs["size"]);
            if(_loc5_ > 20)
            {
               _loc5_ *= 0.01;
            }
            attachedFirearm.bulletSize = _loc5_ * ud.size;
         }
      }
      
      override public function OnDelete() : void
      {
         if(attachedFirearm)
         {
            attachedFirearm.bulletType = this.origBullet;
            attachedFirearm.bulletSize = this.origSize;
            attachedFirearm.reloadTime = this.origReload;
            attachedFirearm.bulletAmount = this.origBullets;
            attachedFirearm.clearSounds();
            attachedFirearm.attachSounds(this.origSounds,this.origVol);
         }
         super.OnDelete();
      }
   }
}

