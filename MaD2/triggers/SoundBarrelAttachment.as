package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class SoundBarrelAttachment extends BarrelAttachment
   {
      
      private var origVol:Array;
      
      private var origSounds:Array;
      
      private var origBullet:String;
      
      private var origBullets:Number;
      
      private var origSize:Number;
      
      private var origForce:Number;
      
      internal var customs:Object;
      
      public function SoundBarrelAttachment()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         rayFrom = new b2Vec2(24 / Physics.scale,0);
         rayTo = new b2Vec2(32 / Physics.scale,0);
         rayRange = 6;
         barrelX = 40;
         this.customs = param2.ParseTriggerCustom();
         var _loc3_:String = this.customs["barrelOffset"];
         var _loc4_:String = this.customs["attachOffset"];
         var _loc5_:String = this.customs["attachStart"];
         var _loc6_:String = this.customs["attachEnd"];
         if(GeneralUtils.isStringVector(_loc3_))
         {
            barrelX = GeneralUtils.toVec(_loc3_).x;
            barrelY = GeneralUtils.toVec(_loc3_).y;
         }
         else if(_loc3_)
         {
            barrelX = Number(_loc3_);
         }
         if(GeneralUtils.isStringVector(_loc4_))
         {
            attachX = GeneralUtils.toVec(_loc4_).x;
            attachY = GeneralUtils.toVec(_loc4_).y;
         }
         else if(_loc4_)
         {
            attachX = Number(_loc4_);
         }
         if(!GeneralUtils.isStringVector(_loc5_))
         {
            return;
         }
         if(!GeneralUtils.isStringVector(_loc6_))
         {
            return;
         }
         rayFrom = GeneralUtils.toVec(_loc5_);
         rayTo = GeneralUtils.toVec(_loc6_);
         rayRange = Math.sqrt(BoxUtils.vectorDist(rayFrom,rayTo));
         rayFrom.Multiply(1 / Physics.scale);
         rayTo.Multiply(1 / Physics.scale);
      }
      
      override protected function Attach(param1:b2Body) : void
      {
         super.Attach(param1);
         this.origSounds = attachedFirearm.soundNames.slice();
         this.origVol = attachedFirearm.soundVolumes.slice();
         this.origBullets = attachedFirearm.bulletAmount;
         this.origBullet = attachedFirearm.bulletType;
         this.origSize = attachedFirearm.bulletSize;
         this.origForce = attachedFirearm.shootForce;
         var _loc2_:Array = ["thumper_shoot"];
         var _loc3_:Array = [0.75];
         var _loc4_:String = "original";
         var _loc5_:Number = 0;
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
         if(this.customs["force"])
         {
            _loc7_ = Number(this.customs["force"]);
         }
         attachedFirearm.clearSounds();
         attachedFirearm.attachSounds(_loc2_,_loc3_);
         if(_loc4_ != "original")
         {
            this.origBullet = attachedFirearm.bulletType;
            attachedFirearm.bulletType = _loc4_;
         }
         if(_loc6_ != 0)
         {
            attachedFirearm.bulletAmount = _loc6_;
         }
         if(_loc5_ != 0)
         {
            attachedFirearm.bulletSize = _loc5_;
         }
         if(_loc7_ != 0)
         {
            attachedFirearm.shootForce = _loc7_;
         }
      }
      
      override protected function Detach() : void
      {
         if(!attachedBody || !(userData(attachedBody.GetUserData()).trigger is Gun))
         {
            return;
         }
         super.Detach();
         if(attachedBody)
         {
            attachedFirearm.clearSounds();
            attachedFirearm.attachSounds(this.origSounds,this.origVol);
            attachedFirearm.bulletType = this.origBullet;
            attachedFirearm.bulletAmount = this.origBullets;
            attachedFirearm.bulletSize = this.origSize;
            attachedFirearm.shootForce = this.origForce;
         }
      }
   }
}

