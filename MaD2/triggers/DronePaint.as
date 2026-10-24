package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Sprite;
   
   public class DronePaint extends Drone
   {
      
      public function DronePaint()
      {
         super();
      }
      
      override protected function seek() : void
      {
         var _loc1_:b2Body = null;
         var _loc2_:userData = null;
         super.seek();
         var _loc3_:int = 0;
         while(_loc3_ < seekbodies.length)
         {
            _loc1_ = b2Body(seekbodies[_loc3_]);
            if(userData(_loc1_.GetUserData()).saveable == false)
            {
               return;
            }
            if(Math.random() > 0.8)
            {
               followBody(_loc1_);
               break;
            }
            _loc3_++;
         }
      }
      
      override protected function follow() : void
      {
         var _loc1_:b2Vec2 = null;
         var _loc2_:b2Vec2 = null;
         var _loc3_:Vector.<Array> = null;
         var _loc4_:uint = 0;
         var _loc5_:Sprite = null;
         super.follow();
         if(targetBody)
         {
            _loc1_ = bodyCenter;
            _loc2_ = targetBody.GetWorldCenter().Copy();
            _loc3_ = ud.skin;
            _loc4_ = 12921900;
            if(Boolean(_loc3_) && _loc3_.length > 0)
            {
               _loc4_ = BoxUtils.getSkinColour(_loc3_,"c52c2c");
            }
            _loc5_ = new Sprite();
            _loc5_.graphics.lineStyle(2,_loc4_,Math.random());
            _loc5_.graphics.drawCircle(GraphicUtils.camX(pixelCenter.x) + camPos.x,GraphicUtils.camY(pixelCenter.y) + camPos.y,Math.random() * 10 * Main.instance.cam.scaleX);
            Main.instance.particlesBMD.draw(_loc5_);
         }
      }
      
      override protected function destroy() : Boolean
      {
         if(!super.destroy())
         {
            return false;
         }
         var _loc1_:b2Vec2 = targetBody.GetPosition();
         var _loc2_:Number = Math.atan2(_loc1_.y - bodyCenter.y,_loc1_.x - bodyCenter.x);
         var _loc3_:b2Vec2 = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,32 * ud.size,Vars.toDegrees * _loc2_);
         var _loc4_:String = "c52c2c";
         var _loc5_:Vector.<Array> = ud.skin;
         if((Boolean(_loc5_)) && _loc5_.length > 0)
         {
            _loc4_ = BoxUtils.getSkinColour(_loc5_,"c52c2c").toString(16);
         }
         while(_loc4_.length < 6)
         {
            _loc4_ = "0" + _loc4_;
         }
         var _loc6_:userData = Properties.objTemp(_loc4_);
         _loc6_.trigger = new Paint();
         _loc6_.triggered = true;
         _loc6_.killOnContact = true;
         _loc6_.projectileName = "pnt";
         var _loc7_:b2Body = Spawn.circle(_loc3_.x,_loc3_.y,0.1,_loc6_,[1,1,1]);
         _loc7_.ApplyForce(new b2Vec2(0.002 * (_loc1_.x * Physics.scale - _loc3_.x),0.002 * (_loc1_.y * Physics.scale - _loc3_.y)),_loc7_.GetWorldCenter());
         beginSeek();
         return true;
      }
   }
}

