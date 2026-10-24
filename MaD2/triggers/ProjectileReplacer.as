package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ProjectileReplacer extends MiscAttachment
   {
      
      private var origBullet:String;
      
      private var origSize:Number;
      
      internal var projectile:String = "stapler";
      
      public function ProjectileReplacer()
      {
         super();
         hand1 = new b2Vec2(-4 / Physics.scale,-15 / Physics.scale);
         ray1 = new b2Vec2(-4 / Physics.scale,-16 / Physics.scale);
         rayRange = 6;
         attachmentID = 1000005;
      }
      
      override public function OnLoadCustom() : void
      {
         super.OnLoadCustom();
         this.projectile = ud.triggerCustom;
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(!_loc7_)
         {
            return true;
         }
         if(!_loc7_.projectile)
         {
            return true;
         }
         if(!_loc7_.projectileName)
         {
            return true;
         }
         _loc7_.dead = true;
         this.projectile = _loc7_.projectileName;
         ud.triggerCustom = this.projectile;
         this.Attach();
         return false;
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
         this.origBullet = attachedFirearm.bulletType;
         this.origSize = attachedFirearm.bulletSize;
         this.Attach();
         return true;
      }
      
      internal function Attach() : void
      {
         if(!attachedFirearm)
         {
            return;
         }
         attachedFirearm.bulletType = this.projectile;
         attachedFirearm.bulletSize = ud.triggerForce * 0.01;
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

