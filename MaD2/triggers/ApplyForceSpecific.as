package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class ApplyForceSpecific extends Trigger
   {
      
      internal var customs:Object;
      
      internal var specific:Array = [];
      
      internal var force:b2Vec2 = new b2Vec2(100,100);
      
      internal var pos:b2Vec2 = new b2Vec2(0,0);
      
      public function ApplyForceSpecific()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         param2.triggerForceAllowNegative = true;
         this.customs = ud.ParseTriggerCustom();
         if(!this.customs["items"])
         {
            ud.triggered = false;
            ud.triggerLock = true;
            return;
         }
         this.specific = this.customs["items"].split(",");
         if(this.customs["force"])
         {
            this.force.x = Number(this.customs["force"].split(",")[0]);
            this.force.y = Number(this.customs["force"].split(",")[1]);
         }
         if(this.customs["pos"])
         {
            this.pos.x = Number(this.customs["pos"].split(",")[0]);
            this.pos.y = Number(this.customs["pos"].split(",")[1]);
         }
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc8_:b2Body = null;
         var _loc10_:userData = null;
         super.trigger(param1,param2);
         var _loc3_:b2Vec2 = param2.triggerPos.Copy();
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc5_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc4_.x * param2.size,pixelCenter.y + _loc4_.y * param2.size);
         var _loc6_:Array = Body.GetAroundPoint(_loc5_,param2.triggerRadius * param2.size,param2.triggerRadius * param2.size,false);
         var _loc7_:Vector.<b2Body> = new Vector.<b2Body>();
         for each(_loc8_ in _loc6_)
         {
            _loc10_ = userData(_loc8_.GetUserData());
            if(this.specific.indexOf(_loc10_.name) != -1)
            {
               _loc7_.push(_loc8_);
            }
         }
         if(param2.connected.length > 0)
         {
            _loc7_ = param2.connected.slice();
         }
         var _loc9_:b2Vec2 = this.force.Copy();
         if(this.customs["randomForce"])
         {
            _loc9_.x = Math.random() * this.force.x - this.force.x * 0.5;
            _loc9_.y = Math.random() * this.force.y - this.force.y * 0.5;
         }
         _loc9_.Multiply(param2.triggerForce);
         for each(_loc8_ in _loc7_)
         {
            _loc10_ = userData(_loc8_.GetUserData());
            if(Math.abs(_loc8_.GetAngle() % Vars.PI * 2) <= 1)
            {
               _loc8_.ApplyForce(_loc9_,this.pos);
            }
         }
      }
   }
}

