package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import com.anegmetex.Soundmanager.sounds;
   import flash.display.Sprite;
   
   public class SlotMachine extends Trigger
   {
      
      private var colours:Array = [39423,6723840,16750899,16751103,13382400,10027263,10053222,16763955,13395558];
      
      private var roll1:int;
      
      private var roll2:int;
      
      private var roll3:int;
      
      internal var first:Sprite = new Sprite();
      
      internal var secon:Sprite = new Sprite();
      
      internal var third:Sprite = new Sprite();
      
      internal var paid:Boolean = false;
      
      public function SlotMachine()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         this.first.graphics.clear();
         this.secon.graphics.clear();
         this.third.graphics.clear();
         this.first.graphics.beginFill(2236962);
         this.secon.graphics.beginFill(2236962);
         this.third.graphics.beginFill(2236962);
         this.first.graphics.drawCircle(0,0,8);
         this.secon.graphics.drawCircle(0,0,8);
         this.third.graphics.drawCircle(0,0,8);
         this.first.x = -27 * ud.size;
         this.secon.x = 0;
         this.third.x = 27 * ud.size;
         if(ud.flipped)
         {
            this.first.x += 13 * ud.size;
            this.secon.x += 13 * ud.size;
            this.third.x += 13 * ud.size;
         }
         this.first.y = 32 * ud.size;
         this.secon.y = 32 * ud.size;
         this.third.y = 32 * ud.size;
         ud.graphic.addChild(this.first);
         ud.graphic.addChild(this.secon);
         ud.graphic.addChild(this.third);
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:Array = null;
         var _loc4_:userData = null;
         var _loc5_:b2Body = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         super.trigger(param1,param2);
         if(ud.triggerState == 2)
         {
            ud.triggerDuration -= TimeLord.speed;
            if(ud.triggerDuration <= 0)
            {
               ud.triggerState = 0;
            }
         }
         else if(ud.triggerState == 0)
         {
            _loc3_ = Body.GetAround(body,50,50);
            for each(_loc5_ in _loc3_)
            {
               _loc4_ = userData(_loc5_.GetUserData());
               if((Boolean(_loc4_)) && _loc4_.name == "casinotoken")
               {
                  _loc4_.dead = true;
                  ud.triggerState = 1;
                  ud.triggerDuration = 60;
                  this.paid = true;
                  break;
               }
            }
         }
         else if(ud.triggerState == 1)
         {
            ud.triggerDuration -= TimeLord.speed;
            if(ud.triggerDuration <= 0)
            {
               ud.triggered = false;
               this.onUntrigger();
               return;
            }
            this.roll1 = int(Math.random() * this.colours.length);
            this.roll2 = int(Math.random() * this.colours.length);
            this.roll3 = int(Math.random() * this.colours.length);
            this.first.graphics.clear();
            this.secon.graphics.clear();
            this.third.graphics.clear();
            this.first.graphics.beginFill(this.colours[this.roll1]);
            this.secon.graphics.beginFill(this.colours[this.roll2]);
            this.third.graphics.beginFill(this.colours[this.roll3]);
            _loc6_ = 12 * ud.size;
            _loc7_ = 24 * ud.size;
            this.first.graphics.drawRoundRect(-_loc6_ * 0.5,-Math.random() * _loc7_ * 0.5 - _loc7_ * 0.25,_loc6_,_loc7_,8,8);
            this.secon.graphics.drawRoundRect(-_loc6_ * 0.5,-Math.random() * _loc7_ * 0.5 - _loc7_ * 0.25,_loc6_,_loc7_,8,8);
            this.third.graphics.drawRoundRect(-_loc6_ * 0.5,-Math.random() * _loc7_ * 0.5 - _loc7_ * 0.25,_loc6_,_loc7_,8,8);
            if(ud.triggerDuration % 8 == 0)
            {
               sounds.play("nerf",body,pixelCenter,Math.random() * 0.4 + 0.2);
            }
         }
      }
      
      override public function onUntrigger() : void
      {
         var _loc2_:b2Vec2 = null;
         var _loc3_:b2Vec2 = null;
         var _loc4_:b2Vec2 = null;
         var _loc5_:b2Body = null;
         var _loc6_:int = 0;
         super.onUntrigger();
         if(!this.paid)
         {
            return;
         }
         this.first.graphics.clear();
         this.secon.graphics.clear();
         this.third.graphics.clear();
         this.first.graphics.lineStyle(4,this.colours[this.roll1],0.5);
         this.secon.graphics.lineStyle(4,this.colours[this.roll2],0.5);
         this.third.graphics.lineStyle(4,this.colours[this.roll3],0.5);
         this.first.graphics.beginFill(this.colours[this.roll1]);
         this.secon.graphics.beginFill(this.colours[this.roll2]);
         this.third.graphics.beginFill(this.colours[this.roll3]);
         this.first.graphics.drawCircle(0,0,8 * ud.size);
         this.secon.graphics.drawCircle(0,0,8 * ud.size);
         this.third.graphics.drawCircle(0,0,8 * ud.size);
         var _loc1_:int = 0;
         if(this.roll1 == this.roll2 && this.roll2 == this.roll3)
         {
            _loc1_ = 10;
         }
         else if(this.roll1 == this.roll2 || this.roll1 == this.roll3 || this.roll2 == this.roll3)
         {
            _loc1_ = 2;
         }
         if(_loc1_ > 0)
         {
            sounds.play("ching",body,pixelCenter);
            _loc2_ = ud.triggerPos.Copy();
            _loc3_ = BoxUtils.rotateVec(_loc2_,bodyAngle);
            _loc4_ = new b2Vec2(pixelCenter.x + _loc3_.x,pixelCenter.y + _loc3_.y);
            _loc6_ = 0;
            while(_loc6_ < _loc1_)
            {
               _loc5_ = GameState.objects.delayedSpawnObject("casinotoken",_loc4_.x,_loc4_.y,0,false,true);
               if(_loc5_)
               {
                  _loc5_.ApplyForce(new b2Vec2(Math.random() * 100 - 50,Math.random() * 500),_loc5_.GetWorldCenter());
               }
               _loc6_++;
            }
         }
         ud.triggerState = 2;
         ud.triggerDuration = 30;
         ud.triggered = true;
         this.paid = false;
      }
   }
}

