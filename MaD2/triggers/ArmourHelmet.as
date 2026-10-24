package triggers
{
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class ArmourHelmet extends Armour
   {
      
      private var headSprite:Sprite;
      
      public var hideHead:Boolean = false;
      
      public function ArmourHelmet(param1:b2Body, param2:Number, param3:Number = 0.1, param4:Number = 0.5, param5:Number = 100)
      {
         super(param1,param2,param3,param4,param5);
         userData(param1.GetUserData()).resistConcuss = true;
         attachTarget = "doll_head";
      }
      
      override protected function Attach(param1:b2Body) : Boolean
      {
         if(!super.Attach(param1))
         {
            return false;
         }
         if(this.hideHead)
         {
            this.headSprite = userData(param1.GetUserData()).graphic;
            if(this.headSprite)
            {
               this.headSprite.alpha = 0;
            }
         }
         return true;
      }
      
      override public function OnJoint(param1:b2Body, param2:String) : Boolean
      {
         if(!super.OnJoint(param1,param2))
         {
            return false;
         }
         if(param2 == "armour" && this.hideHead)
         {
            this.headSprite = userData(param1.GetUserData()).graphic;
            if(this.headSprite)
            {
               this.headSprite.alpha = 0;
            }
         }
         return true;
      }
      
      override public function OnJointDelete(param1:b2Joint) : void
      {
         super.OnJointDelete(param1);
         if(!isAttached(body))
         {
            if(this.headSprite)
            {
               this.headSprite.alpha = 1;
            }
         }
      }
      
      override public function OnDelete() : void
      {
         super.OnDelete();
         if(this.headSprite)
         {
            this.headSprite.alpha = 1;
         }
      }
   }
}

