package triggers
{
   import Box2D.Collision.b2ContactPoint;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2Joint;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   
   public class Trigger
   {
      
      public var overwrite:Boolean = true;
      
      public var temporary:Boolean = false;
      
      protected var body:b2Body;
      
      protected var ud:userData;
      
      protected var triggerForce:Number;
      
      protected var triggerState:Number;
      
      protected var triggerDuration:Number;
      
      protected var triggerPos:b2Vec2;
      
      protected var triggerRadius:Number;
      
      protected var bodyCenter:b2Vec2;
      
      protected var pixelCenter:b2Vec2;
      
      protected var bodyAngle:Number;
      
      protected var bodyVel:b2Vec2;
      
      protected var camPos:b2Vec2;
      
      public var untriggerFunc:Function;
      
      public var triggerFunc:Function;
      
      public function Trigger()
      {
         super();
      }
      
      public function reset() : void
      {
         if(!this.ud)
         {
            return;
         }
         if(Boolean(this.ud.graphic) && this.ud.trigger is Invis)
         {
            this.ud.graphic.alpha = 1;
         }
         this.ud.trigger = null;
         if(this.ud.hasBeenCut)
         {
            return;
         }
         if(this.ud.dead)
         {
            return;
         }
         this.ud.trigger = this.ud.originalTrigger;
         if(this.ud.originalTriggered != 0)
         {
            this.ud.triggered = this.ud.originalTriggered == 1;
            this.ud.originalTriggered = 0;
         }
      }
      
      public function init(param1:b2Body, param2:userData) : void
      {
         if(!this.body)
         {
            this.body = param1;
            if(this.body.GetUserData())
            {
               this.ud = this.body.GetUserData() as userData;
            }
         }
         if(!this.ud && Boolean(param2))
         {
            this.ud = param2;
         }
         if(Boolean(this.body) && Boolean(this.ud))
         {
            this.updateTriggerHelpers();
         }
      }
      
      public function OnLoadCustom() : void
      {
      }
      
      public function trigger(param1:b2Body, param2:userData) : void
      {
         if(!this.body || !this.ud)
         {
            this.init(param1,param2);
         }
         this.updateTriggerHelpers();
         if(this.ud.triggerSound)
         {
            sounds.play(this.ud.triggerSound,this.body,this.pixelCenter);
         }
      }
      
      protected function updateTriggerHelpers() : void
      {
         if(!this.ud)
         {
            return;
         }
         this.triggerForce = this.ud.triggerForce;
         this.triggerState = this.ud.triggerState;
         this.triggerDuration = this.ud.triggerDuration;
         if(this.ud.triggerPos)
         {
            this.triggerPos = this.ud.triggerPos.Copy();
         }
         this.triggerRadius = this.ud.triggerRadius;
         this.bodyCenter = this.body.GetWorldCenter().Copy();
         this.pixelCenter = new b2Vec2(this.bodyCenter.x * Physics.scale,this.bodyCenter.y * Physics.scale);
         this.bodyAngle = this.body.GetAngle();
         this.bodyVel = this.body.GetLinearVelocity().Copy();
         this.camPos = new b2Vec2(Main.instance.m_sprite.x,Main.instance.m_sprite.y);
      }
      
      public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
      }
      
      public function OnStick(param1:b2Body) : void
      {
         this.updateTriggerHelpers();
      }
      
      public function OnDelete() : void
      {
      }
      
      public function OnJointDelete(param1:b2Joint) : void
      {
      }
      
      public function OnJoint(param1:b2Body, param2:String) : Boolean
      {
         return true;
      }
      
      public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!this.ud)
         {
            return false;
         }
         if(this.ud.triggerCollide != 0 && this.ud.triggerCollide * this.ud.size > param4)
         {
            return false;
         }
         return true;
      }
      
      public function OnCut() : Boolean
      {
         return false;
      }
      
      public function OnCutDamage(param1:b2Vec2, param2:b2Vec2) : void
      {
      }
      
      public function onUntrigger() : void
      {
         if(Boolean(this.untriggerFunc))
         {
            this.untriggerFunc();
         }
      }
      
      public function onTrigger() : void
      {
         if(Boolean(this.triggerFunc))
         {
            this.triggerFunc();
         }
      }
      
      public function OnCollisionEnd(param1:b2Body, param2:b2ContactPoint) : void
      {
      }
      
      public function OnSaveCustom() : void
      {
      }
      
      public function OnLoadFinished() : void
      {
      }
   }
}

