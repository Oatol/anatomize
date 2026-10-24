package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ProjectileChange extends MiscAttachment
   {
      
      private var origBullet:String;
      
      private var origSize:Number;
      
      private var customs:Object;
      
      public function ProjectileChange()
      {
         super();
         attachmentID = 1000005;
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
         if(isAttached(param1))
         {
            return false;
         }
         if(!attachedFirearm)
         {
            return false;
         }
         this.origBullet = attachedFirearm.bulletType;
         this.origSize = attachedFirearm.bulletSize;
         attachedFirearm.bulletType = this.customs["bullet"];
         var _loc3_:Number = Number(this.customs["size"]);
         if(_loc3_ > 20)
         {
            _loc3_ *= 0.01;
         }
         attachedFirearm.bulletSize = this.customs["size"] * 0.01;
         return true;
      }
      
      override public function OnDelete() : void
      {
         if(attachedFirearm)
         {
            attachedFirearm.bulletType = this.origBullet;
            attachedFirearm.bulletSize = this.origSize;
         }
         super.OnDelete();
      }
   }
}

