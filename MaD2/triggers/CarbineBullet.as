package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class CarbineBullet extends GenericBullet
   {
      
      public function CarbineBullet()
      {
         super("trailblazer");
         trail = true;
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         updateTriggerHelpers();
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc11_:Sprite = null;
         var _loc12_:b2Vec2 = null;
         var _loc13_:int = 0;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(_loc7_.resistArc)
         {
            return true;
         }
         ud.dead = true;
         if(param1.IsStatic())
         {
            return true;
         }
         super.updateTriggerHelpers();
         var _loc8_:int = 0;
         while(_loc8_ < 20)
         {
            GameState.particles.addParticles(pixelCenter.x,pixelCenter.y,2,"trailblazer",Math.random() * 20 - 10,Math.random() * 20 - 10,1,1);
            _loc8_++;
         }
         var _loc9_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(_loc9_)
         {
            _loc11_ = new Sprite();
            _loc11_.graphics.lineStyle(0,0,0);
            _loc12_ = param1.GetLocalPoint(param5).Copy();
            _loc12_.Multiply(Physics.scale);
            _loc12_.x -= Bitmap(_loc7_.graphic.getChildByName("effects")).x;
            _loc12_.y -= Bitmap(_loc7_.graphic.getChildByName("effects")).y;
            _loc13_ = 0;
            while(_loc13_ < 10)
            {
               if(Math.random() > 0.5)
               {
                  _loc11_.graphics.beginFill(399674,Math.random());
               }
               else
               {
                  _loc11_.graphics.beginFill(39423,Math.random());
               }
               _loc11_.graphics.drawRect(_loc12_.x + Math.random() * 20 - 10,_loc12_.y + Math.random() * 20 - 10,Math.random() * 5,Math.random() * 5);
               _loc11_.graphics.endFill();
               _loc13_++;
            }
            _loc9_.draw(_loc11_);
         }
         var _loc10_:Number = _loc7_.maxhealth * 0.3;
         Body.Damage(param1,_loc10_,param5,new b2Vec2(),new b2Vec2(2,2),false);
         return true;
      }
   }
}

