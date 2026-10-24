package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PourSpawnProjectile extends Trigger
   {
      
      private var angle:Number;
      
      private var chance:Number;
      
      private var start:b2Vec2;
      
      private var end:b2Vec2;
      
      private var items:Array;
      
      public function PourSpawnProjectile()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Object = null;
         _loc3_ = param2.ParseTriggerCustom();
         this.start = new b2Vec2(-10,0);
         this.end = new b2Vec2(10,0);
         this.chance = 0.25;
         this.items = _loc3_["items"].split(",");
         if(_loc3_["chance"])
         {
            this.chance = Number(_loc3_["chance"]);
         }
         if(_loc3_["angle"])
         {
            this.angle = Number(_loc3_["angle"]);
         }
         if(_loc3_["start"])
         {
            this.start.x = Number(_loc3_["start"].split(",")[0]);
            this.start.y = Number(_loc3_["start"].split(",")[1]);
         }
         if(_loc3_["end"])
         {
            this.end.x = Number(_loc3_["end"].split(",")[0]);
            this.end.y = Number(_loc3_["end"].split(",")[1]);
         }
         super.init(param1,param2);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:b2Vec2 = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:String = null;
         super.trigger(param1,param2);
         if(Math.random() > 1 - this.chance)
         {
            _loc3_ = bodyAngle * Vars.toDegrees;
            if(_loc3_ % 360 > this.angle && _loc3_ % 360 < 360 - this.angle || _loc3_ % 360 > -360 + this.angle && _loc3_ % 360 < -this.angle)
            {
               _loc4_ = BoxUtils.rotateVec(new b2Vec2(param2.size * this.start.x / Physics.scale,param2.size * this.start.y / Physics.scale),bodyAngle);
               _loc5_ = BoxUtils.rotateVec(new b2Vec2(param2.size * this.end.x / Physics.scale,param2.size * this.end.y / Physics.scale),bodyAngle);
               _loc6_ = (_loc5_.y - _loc4_.y) / (_loc5_.x - _loc4_.x);
               _loc7_ = _loc4_.x + Math.random() * (_loc5_.x - _loc4_.x);
               _loc8_ = _loc4_.y + _loc6_ * (_loc7_ - _loc4_.x);
               _loc9_ = this.items[this.items.length * Math.random() >> 0];
               GameState.objects.addbullet(_loc9_,bodyCenter.x + _loc7_,bodyCenter.y + _loc8_,0,1,0.1,bodyVel.Copy(),0,param1);
            }
         }
      }
   }
}

