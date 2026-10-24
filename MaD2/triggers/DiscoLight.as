package triggers
{
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class DiscoLight extends Trigger
   {
      
      internal var lights:Vector.<Sprite>;
      
      public function DiscoLight()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         var _loc6_:Vector.<Array> = null;
         var _loc7_:Sprite = null;
         super.init(param1,param2);
         this.lights = new Vector.<Sprite>();
         var _loc3_:Array = param2.triggerCustom.split(",");
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = new Vector.<Array>();
            _loc6_.push(["378711",_loc3_[_loc5_]]);
            _loc7_ = O.getItem("softglow").updateGraphic(_loc6_);
            _loc7_.name = "light" + _loc5_;
            this.lights.push(_loc7_);
            ud.graphic.addChild(_loc7_);
            _loc7_.visible = false;
            _loc5_++;
         }
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Sprite = null;
         super.trigger(param1,param2);
         param2.triggerDuration -= TimeLord.speed;
         if(param2.triggerDuration <= 0)
         {
            for each(_loc3_ in this.lights)
            {
               _loc3_.visible = false;
            }
            _loc3_ = this.lights[int(Math.random() * this.lights.length)];
            _loc3_.visible = true;
            _loc3_.scaleX = _loc3_.scaleY = param2.size * param2.triggerRadius * 0.01;
            _loc3_.x = param2.triggerPos.x * param2.size * (param2.flipped ? -1 : 1);
            _loc3_.y = param2.triggerPos.y * param2.size;
            param2.triggerDuration = param2.originalTriggerDuration;
         }
      }
      
      override public function onUntrigger() : void
      {
         var _loc1_:Sprite = null;
         super.onUntrigger();
         for each(_loc1_ in this.lights)
         {
            _loc1_.visible = false;
         }
      }
   }
}

