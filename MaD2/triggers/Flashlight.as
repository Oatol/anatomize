package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Flashlight extends Trigger
   {
      
      public function Flashlight()
      {
         super();
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:b2Vec2 = null;
         var _loc11_:b2Body = null;
         super.trigger(param1,param2);
         if(param2.flipped)
         {
            _loc3_ = new b2Vec2(-30 * param2.size,0);
            _loc4_ = new b2Vec2(-330 * param2.size,0);
         }
         else
         {
            _loc3_ = new b2Vec2(30 * param2.size,0);
            _loc4_ = new b2Vec2(330 * param2.size,0);
         }
         var _loc5_:b2Vec2 = BoxUtils.rotateVec(_loc3_,bodyAngle);
         var _loc6_:b2Vec2 = BoxUtils.rotateVec(_loc4_,bodyAngle);
         var _loc7_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc5_.x,pixelCenter.y + _loc5_.y);
         var _loc8_:b2Vec2 = new b2Vec2(pixelCenter.x + _loc6_.x,pixelCenter.y + _loc6_.y);
         Shadows.lightPos = _loc7_.Copy();
         Shadows.lightRadius = 180;
         _loc7_.Multiply(1 / Physics.scale);
         _loc8_.Multiply(1 / Physics.scale);
         var _loc9_:Vector.<b2Body> = Body.SelectArea(_loc7_,_loc8_);
         var _loc10_:Array = [];
         for each(_loc11_ in _loc9_)
         {
            if(_loc11_ != param1)
            {
               _loc10_.push(_loc11_);
            }
         }
         Main.instance.drawShadowsFor(_loc10_,2);
      }
   }
}

