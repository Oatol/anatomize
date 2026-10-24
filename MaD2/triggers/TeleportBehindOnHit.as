package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class TeleportBehindOnHit extends Trigger
   {
      
      internal var target:b2Body;
      
      internal var cam:Sprite;
      
      public function TeleportBehindOnHit()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(!this.target || userData(this.target.GetUserData()).dead)
         {
            this.target = null;
            ud.triggerState = 0;
            ud.triggered = false;
            return;
         }
         ud.triggerDuration -= TimeLord.speed;
         if(ud.triggerDuration <= 0)
         {
            ud.triggerDuration = ud.originalTriggerDuration;
            if(ud.triggerState == 1)
            {
               this.Effect();
               return;
            }
         }
         var _loc3_:* = (-bodyCenter.x + this.target.GetWorldCenter().x) * ud.triggerForce * 2 * body.GetMass();
         var _loc4_:* = (-bodyCenter.y + this.target.GetWorldCenter().y) * ud.triggerForce * 2 * body.GetMass();
         body.ApplyForce(new b2Vec2(_loc3_,_loc4_),bodyCenter);
         body.ApplyTorque(Math.random() * ud.triggerForce * 100 - ud.triggerForce * 50);
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         this.cam = GraphicUtils.cam;
         ud.triggerDuration = 0;
      }
      
      public function Effect() : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:b2Vec2 = null;
         if(Main.instance.m_mouseJoint)
         {
            if(body == Main.instance.m_mouseJoint.GetBody1() || body == Main.instance.m_mouseJoint.GetBody2())
            {
               Main.instance.stopDragging(false);
            }
         }
         var _loc1_:* = (bodyCenter.x - this.target.GetWorldCenter().x) * ud.triggerForce / 50;
         var _loc2_:* = (bodyCenter.y - this.target.GetWorldCenter().y) * ud.triggerForce / 50;
         _loc3_ = new b2Vec2(bodyCenter.x - _loc1_,bodyCenter.y - _loc2_);
         _loc3_.Multiply(Physics.scale);
         _loc4_ = new b2Vec2();
         _loc4_.x = (-this.cam.x + GameState.width * 0.5) / this.cam.scaleX;
         _loc4_.y = (-this.cam.y + GameState.height * 0.5) / this.cam.scaleY;
         if(_loc3_.x > _loc4_.x + GameState.width * 0.5 - 50)
         {
            _loc3_.x = _loc4_.x + GameState.width * 0.5 - 50;
         }
         if(_loc3_.x < _loc4_.x - GameState.width * 0.5 - 50)
         {
            _loc3_.x = _loc4_.x - GameState.width * 0.5 + 50;
         }
         if(_loc3_.y > _loc4_.y + GameState.height * 0.5 - 50)
         {
            _loc3_.y = _loc4_.y + GameState.height * 0.5 - 50;
         }
         if(_loc3_.x < _loc4_.y - GameState.height * 0.5 - 50)
         {
            _loc3_.y = _loc4_.y - GameState.height * 0.5 + 50;
         }
         var _loc5_:int = 0;
         while(_loc5_ < 8)
         {
            GameState.particles.addParticles(_loc3_.x,_loc3_.y,1,"moss",0,0,4,4);
            _loc5_++;
         }
         _loc3_.Multiply(1 / Physics.scale);
         body.SetXForm(_loc3_,Math.random() * 6);
         ud.triggerState = 0;
      }
      
      override public function OnSharp(param1:b2Body, param2:Number = 0) : void
      {
         super.OnSharp(param1);
         if(param1.IsStatic())
         {
            return;
         }
         if(ud.connected.indexOf(param1) != -1)
         {
            return;
         }
         ud.triggered = true;
         ud.triggerState = 1;
         this.target = param1;
      }
   }
}

