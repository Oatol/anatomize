package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ProjectilePistol extends MiscAttachment
   {
      
      private var origBullet:String;
      
      private var origSize:Number;
      
      public function ProjectilePistol()
      {
         super();
         hand1 = new b2Vec2(0,-2 / Physics.scale);
         ray1 = new b2Vec2(0,-3 / Physics.scale);
         rayRange = 4;
         attachmentID = 1000005;
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
         attachedFirearm.bulletType = "9mm";
         attachedFirearm.bulletSize = 0.2;
         return true;
      }
      
      override public function OnDelete() : void
      {
         if(gunBody)
         {
            attachedFirearm.bulletType = this.origBullet;
            attachedFirearm.bulletSize = this.origSize;
         }
         super.OnDelete();
      }
   }
}

