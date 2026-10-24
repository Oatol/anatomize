package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.Joints.b2WeldJoint;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class ScorpionStinger extends TempProjectile
   {
      
      private var targetBody:b2Body;
      
      private var oud:userData;
      
      public function ScorpionStinger()
      {
         super(180,10);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:BitmapData = null;
         var _loc8_:Sprite = null;
         var _loc9_:b2Vec2 = null;
         super.trigger(param1,param2);
         if(ud.triggerState == 0)
         {
            return;
         }
         if(!this.targetBody)
         {
            ud.dead = true;
            return;
         }
         if(Math.random() < 0.95)
         {
            return;
         }
         _loc3_ = Math.random() * (this.oud.width * 1.2) - this.oud.width * 0.6;
         _loc4_ = Math.random() * (this.oud.height * 1.2) - this.oud.height * 0.6;
         _loc5_ = Math.random() * (this.oud.width * 1.2) - this.oud.width * 0.6;
         _loc6_ = Math.random() * (this.oud.height * 1.2) - this.oud.height * 0.6;
         if(Math.random() > 0.7)
         {
            this.oud.bleeding.push([new b2Vec2(_loc3_ / Physics.scale,_loc4_ / Physics.scale),new b2Vec2(_loc5_ / Physics.scale,_loc6_ / Physics.scale),new b2Vec2(),5]);
         }
         _loc7_ = BoxUtils.getEffectBMD(this.targetBody);
         if(_loc7_)
         {
            _loc8_ = new Sprite();
            _loc9_ = new b2Vec2();
            _loc9_.x -= Bitmap(this.oud.graphic.getChildByName("effects")).x;
            _loc9_.y -= Bitmap(this.oud.graphic.getChildByName("effects")).y;
            _loc8_.graphics.lineStyle(Math.random() * 2 + 2,GraphicUtils.scalehex(this.oud.bloodColour,0.6 + Math.random() * 0.4),Math.random() * 0.4 + 0.6);
            _loc8_.graphics.moveTo(_loc3_ + _loc9_.x,_loc4_ + _loc9_.y);
            _loc8_.graphics.lineTo(_loc5_ + _loc9_.x,_loc6_ + _loc9_.y);
            _loc8_.graphics.moveTo(_loc3_,_loc4_);
            _loc8_.graphics.lineTo(_loc5_,_loc6_);
            _loc7_.draw(_loc8_);
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         ud.triggered = true;
         if(triggerState == 1)
         {
            return true;
         }
         if(!userData(param1.GetUserData()).alive)
         {
            return true;
         }
         if(userData(param1.GetUserData()).resistBleed)
         {
            return true;
         }
         sounds.play("drain2",body,pixelCenter,0.2);
         this.targetBody = param1;
         this.oud = userData(this.targetBody.GetUserData());
         this.oud.bloodColour = BoxUtils.getSkinColour(ud.skin,"1b3600");
         ud.triggerState = 1;
         var _loc7_:b2WeldJoint = Joints.Weld("scorp",body,param1,param1.GetPosition());
         jointUserData(_loc7_.GetUserData()).lineAlpha = 0;
         return true;
      }
   }
}

