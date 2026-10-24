package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import caurina.transitions.Tweener;
   import flash.display.Sprite;
   
   public class SpawnItemsSlowly extends Trigger
   {
      
      private var items:Array;
      
      private var posX:Number = 0;
      
      private var posY:Number = 0;
      
      private var forceX:Number = 0;
      
      private var forceY:Number = 0;
      
      internal var b:b2Body;
      
      public function SpawnItemsSlowly()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         var _loc3_:Object = ud.ParseTriggerCustom();
         if(_loc3_["posX"])
         {
            this.posX = _loc3_["posX"];
         }
         if(_loc3_["posY"])
         {
            this.posY = _loc3_["posX"];
         }
         if(_loc3_["forceX"])
         {
            this.forceX = _loc3_["forceX"];
         }
         if(_loc3_["forceY"])
         {
            this.forceY = _loc3_["forceY"];
         }
      }
      
      override public function onTrigger() : void
      {
         var _loc1_:b2Vec2 = null;
         var _loc2_:b2Body = null;
         super.onTrigger();
         if(!ud.connected || ud.connected.length == 0)
         {
            ud.triggered = false;
            return;
         }
         _loc1_ = body.GetPosition().Copy();
         _loc1_.Multiply(Physics.scale);
         _loc1_.x += this.posX;
         _loc1_.y += this.posY;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         do
         {
            _loc3_ = Math.random() * ud.connected.length >> 0;
            _loc2_ = ud.connected[_loc3_];
            if(++_loc4_ > 100)
            {
               break;
            }
         }
         while(!_loc2_);
         if(!_loc2_)
         {
            ud.triggered = false;
            return;
         }
         this.b = Body.Clone(_loc2_,_loc1_);
         if(!this.b || !userData(this.b.GetUserData()).graphic)
         {
            ud.triggered = false;
            return;
         }
         var _loc5_:Sprite = userData(this.b.GetUserData()).graphic;
         _loc5_.scaleY = 0.01;
         Tweener.addTween(_loc5_,{
            "scaleY":1,
            "time":ud.originalTriggerDuration / 60
         });
         userData(this.b.GetUserData()).locked = true;
         ud.triggerLock = true;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc8_:b2Body = null;
         super.trigger(param1,param2);
         if(!this.b)
         {
            return;
         }
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration > 0)
         {
            return;
         }
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = param1.GetAngularVelocity();
         if(this.forceX)
         {
            _loc3_ = this.forceX;
         }
         if(this.forceY)
         {
            _loc4_ = this.forceX;
         }
         this.b.SetAngularVelocity(_loc5_);
         this.b.SetLinearVelocity(bodyVel);
         this.b.ApplyForce(new b2Vec2(_loc3_,_loc4_),this.b.GetWorldCenter());
         userData(this.b.GetUserData()).locked = false;
         this.b = null;
         param2.triggerLock = false;
         param2.triggered = false;
         param2.triggerDuration = param2.originalTriggerDuration;
         var _loc6_:Array = Joints.GetJoints(param1);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_.length)
         {
            _loc8_ = Joints.Other(_loc6_[_loc7_],param1);
            if(_loc8_)
            {
               userData(_loc8_.GetUserData()).triggered = true;
            }
            _loc7_++;
         }
      }
   }
}

