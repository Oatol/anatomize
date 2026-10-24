package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Graphics;
   import flash.display.Sprite;
   
   public class GrowingTomato extends Egg
   {
      
      public function GrowingTomato(param1:Array, param2:int = 20, param3:Number = 50)
      {
         super(param1,param2,param3);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param1.IsStatic())
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if((Boolean(_loc7_)) && Boolean(_loc7_.graphic))
         {
            this.Effect(_loc7_.graphic);
         }
         ud.triggered = true;
         return true;
      }
      
      internal function Effect(param1:Sprite) : *
      {
         var _loc2_:b2Vec2 = null;
         var _loc3_:b2Vec2 = null;
         var _loc4_:b2Vec2 = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:uint = 0;
         _loc2_ = new b2Vec2();
         _loc3_ = new b2Vec2();
         _loc4_ = new b2Vec2();
         _loc5_ = new b2Vec2();
         _loc6_ = new b2Vec2();
         _loc7_ = new b2Vec2();
         _loc8_ = BoxUtils.getSkinColour(ud.skin,"4e9340");
         if(_loc8_ == 16711935)
         {
            _loc8_ = 5149504;
         }
         _loc2_.x = Math.random() * 40 - 20;
         _loc2_.y = Math.random() * 40 - 20;
         _loc5_.x = Math.random() * 40 - 20;
         _loc5_.y = Math.random() * 40 - 20;
         _loc3_.x = _loc2_.x + Math.random() * 40 - 20;
         _loc3_.y = _loc2_.y + Math.random() * 40 - 20;
         _loc6_.x = _loc2_.x + Math.random() * 40 - 20;
         _loc6_.y = _loc2_.y + Math.random() * 40 - 20;
         _loc4_.x = _loc3_.x + Math.random() * 40 - 20;
         _loc4_.y = _loc3_.y + Math.random() * 40 - 20;
         _loc7_.x = _loc3_.x + Math.random() * 40 - 20;
         _loc7_.y = _loc3_.y + Math.random() * 40 - 20;
         var _loc9_:b2Vec2 = new b2Vec2();
         var _loc10_:Graphics = Sprite(param1.getChildByName("decals")).graphics;
         _loc10_.lineStyle(4,_loc8_);
         _loc10_.moveTo(_loc9_.x,_loc9_.y);
         _loc10_.curveTo(_loc9_.x + _loc5_.x,_loc9_.y + _loc5_.y,_loc9_.x + _loc2_.x,_loc9_.y + _loc2_.y);
         _loc10_.lineStyle(3,_loc8_);
         _loc10_.curveTo(_loc9_.x + _loc6_.x,_loc9_.y + _loc6_.y,_loc9_.x + _loc3_.x,_loc9_.y + _loc3_.y);
         _loc10_.lineStyle(2,_loc8_);
         _loc10_.curveTo(_loc9_.x + _loc7_.x,_loc9_.y + _loc7_.y,_loc9_.x + _loc4_.x,_loc9_.y + _loc4_.y);
      }
   }
}

