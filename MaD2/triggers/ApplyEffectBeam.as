package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ApplyEffectBeam extends AutoJoint
   {
      
      internal var effects:Array = [];
      
      public function ApplyEffectBeam()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         walls = false;
         drawLine = true;
         ud.drawRadius = false;
         this.effects = customs["effects"].split(",");
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         if(ud.triggerState == 1)
         {
            this.SlingJoint();
            return;
         }
         if(ud.triggerState == 0)
         {
            rayRange = 1000;
            if(ud.triggerRadius)
            {
               rayRange = ud.triggerRadius;
            }
            super.trigger(param1,param2);
         }
      }
      
      private function SlingJoint() : void
      {
         var _loc1_:String = null;
         if(!attachedJoint || jointUserData(attachedJoint.GetUserData()).dead)
         {
            this.ResetJoint();
            return;
         }
         ud.triggerDuration -= TimeLord.speed;
         for each(_loc1_ in this.effects)
         {
            Body.ApplyEffect(attachedBody,_loc1_,BoxUtils.pixelPos(attachedJoint.GetAnchor2()),body);
         }
         if(ud.triggerDuration > 0)
         {
            return;
         }
         if(destroy)
         {
            ud.dead = true;
            return;
         }
         this.ResetJoint();
      }
      
      override protected function CreateJoint(param1:b2Body, param2:b2Body, param3:b2Vec2, param4:b2Vec2) : Boolean
      {
         if(param1 == param2)
         {
            return false;
         }
         var _loc5_:String = "FFFFFF";
         if(ud.triggerColour)
         {
            _loc5_ = ud.triggerColour;
         }
         var _loc6_:Vector.<Array> = ud.skin;
         if((Boolean(_loc6_)) && _loc6_.length > 0)
         {
            _loc5_ = BoxUtils.getSkinColour(_loc6_,_loc5_).toString(16);
         }
         attachedJoint = Joints.Distance("grapplejoint",param1,param2,param3,param4,0.1,1,true,10000000);
         if(attachedJoint)
         {
            jointUserData(attachedJoint.GetUserData()).lineColour = uint("0x" + _loc5_);
            jointUserData(attachedJoint.GetUserData()).lineWidth = super.lineThickness;
            jointUserData(attachedJoint.GetUserData()).lineAlpha = Math.random() * 0.2 + 0.4;
            ud.triggerState = 1;
            return true;
         }
         return false;
      }
      
      override public function onUntrigger() : void
      {
         super.onUntrigger();
         this.ResetJoint();
      }
      
      override public function onTrigger() : void
      {
         super.onTrigger();
         if(ud.triggerState == 2)
         {
            ud.triggerState = 0;
         }
      }
      
      private function ResetJoint() : void
      {
         if(attachedJoint)
         {
            jointUserData(attachedJoint.GetUserData()).dead = true;
            attachedJoint = null;
         }
         ud.triggerState = 0;
         if(ud.originalTriggerDuration <= 0)
         {
            ud.triggerDuration = 30;
            ud.originalTriggerDuration = -1;
            ud.triggerState = 2;
            ud._triggered = false;
         }
         else
         {
            ud.triggerDuration = ud.originalTriggerDuration;
         }
      }
   }
}

