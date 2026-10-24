package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class DeathBullet extends GenericBullet
   {
      
      public function DeathBullet()
      {
         super("dark");
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         var _loc8_:BitmapData = null;
         var _loc9_:Bitmap = null;
         var _loc10_:int = 0;
         var _loc11_:b2Vec2 = null;
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         ud.dead = true;
         if(_loc7_.resistKill)
         {
            return true;
         }
         _loc7_.health = 0;
         GameState.particles.addParticles(param5.x * Physics.scale,param5.y * Physics.scale,10,"dark",0,0,3,2);
         _loc8_ = BoxUtils.getEffectBMD(param1);
         if(_loc8_)
         {
            _loc9_ = Bitmap(_loc7_.graphic.getChildByName("effects"));
            _loc10_ = 0;
            while(_loc10_ < 10)
            {
               _loc11_ = param1.GetLocalPoint(param5).Copy();
               _loc11_ = GeneralUtils.pointOnCircle(_loc11_.x,_loc11_.y,Math.random() * _loc10_,Math.random() * 360);
               _loc11_.Multiply(Physics.scale);
               _loc11_.x -= _loc9_.x;
               _loc11_.y -= _loc9_.y;
               _loc8_.copyPixels(R.getSprite(Math.random() > 0.8 ? "p_blood" : "p_dark"),new Rectangle(0,0,8,8),new Point(_loc11_.x,_loc11_.y),null,null,true);
               _loc10_++;
            }
         }
         return true;
      }
   }
}

