package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class ScareDroneHead extends Trigger
   {
      
      internal var offset:Sprite;
      
      internal var hammer:Sprite;
      
      internal var decals:Sprite;
      
      internal var busy:Boolean = false;
      
      public function ScareDroneHead()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         this.offset = new Sprite();
         this.hammer = O.getItem("spookyscarecrowhead").updateGraphic();
         this.offset.addChild(this.hammer);
         this.hammer.y = -1;
         this.hammer.x = 0;
         this.offset.alpha = 1;
         this.decals = ud.graphic.getChildByName("decals") as Sprite;
         ud.graphic.addChildAt(this.offset,ud.graphic.numChildren - 1);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:userData = null;
         var _loc5_:b2Body = null;
         super.trigger(param1,param2);
         if(this.offset.alpha == 1 && Math.random() > 0.9)
         {
            this.offset.alpha = 0;
         }
         if(param2.connected.length > 0 && Math.random() > 0.99)
         {
            this.offset.alpha = Math.random() > 0.5 ? 1 : 0;
            this.decals.alpha = 1;
            this.offset.scaleX = this.offset.scaleY = param2.size;
         }
         var _loc4_:Vector.<b2Body> = param2.connected;
         for each(_loc5_ in _loc4_)
         {
            _loc3_ = userData(_loc5_.GetUserData());
            _loc3_.health = 666;
            _loc3_.maxhealth = 666;
            _loc3_.resistAliveBreak = true;
            _loc3_.bleeding = [];
         }
      }
      
      override public function onUntrigger() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:int = 0;
         var _loc3_:b2Vec2 = null;
         super.onUntrigger();
         this.offset.alpha = 0;
         this.decals.alpha = 1;
         for each(_loc1_ in ud.connected)
         {
            _loc2_ = 0;
            while(_loc2_ < Math.random() * 6 + 2)
            {
               Body.Exsanguinate(_loc1_);
               _loc2_++;
            }
            _loc3_ = BoxUtils.randomPointOnBody(_loc1_);
            _loc3_.Multiply(Physics.scale);
            Body.Kill(_loc1_,_loc3_);
            userData(_loc1_.GetUserData()).health = 100;
         }
      }
   }
}

