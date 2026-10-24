package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class BlissSprite extends Trigger
   {
      
      private var eaten:b2Body;
      
      internal var busy:Boolean = false;
      
      internal var decals:Sprite;
      
      internal var fly:b2Vec2 = new b2Vec2();
      
      internal var target:b2Body;
      
      internal var wings:int = 1;
      
      public function BlissSprite()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         if(!ud.triggerDuration || ud.triggerDuration == 0)
         {
            ud.triggerDuration = 300;
         }
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc4_:b2Vec2 = null;
         var _loc5_:Array = null;
         var _loc6_:userData = null;
         var _loc7_:b2Body = null;
         super.trigger(param1,param2);
         var _loc3_:String = "petal";
         if(param2.triggerState == 1)
         {
            _loc3_ = "smoke";
         }
         if(Boolean(param2.pfx) && param2.pfx.replaceDefault)
         {
            _loc3_ = param2.pfx.getParticle();
         }
         if(this.eaten)
         {
            Body.Disintegrate(this.eaten,"blood",10,5,5);
            GameState.objects.spawnObject(param2.name,this.eaten.GetPosition().x * Physics.scale + Math.random() * 30 - 15,this.eaten.GetPosition().y * Physics.scale + Math.random() * 30 - 15,0,false,true);
            this.eaten = null;
            this.target = null;
            return;
         }
         if(Math.random() > 0.95)
         {
            _loc4_ = GeneralUtils.pointOnCircle(pixelCenter.x,pixelCenter.y,20 * Math.random(),Math.random() * 360);
            GameState.particles.addParticles(_loc4_.x,_loc4_.y,1,_loc3_,bodyVel.x * 0.5,bodyVel.y * 0.5,1,1);
         }
         if(param2.triggerState == 1)
         {
            _loc5_ = Body.GetAround(param1,200,200);
            for each(_loc7_ in _loc5_)
            {
               _loc6_ = userData(_loc7_.GetUserData());
               if(_loc6_.alive && Math.random() > 0.9)
               {
                  this.target = _loc7_;
                  break;
               }
            }
            if(!this.target)
            {
               param2.triggerDuration -= TimeLord.speed;
               if(param2.triggerDuration < 0)
               {
                  if(Math.random() > 0.95)
                  {
                     param2.dead = true;
                     Body.Disintegrate(param1,_loc3_,20,10,10);
                     return;
                  }
               }
            }
         }
         if(!this.target || !this.target.GetUserData() || userData(this.target.GetUserData()).dead)
         {
            this.target = null;
         }
         this.fly.x *= 0.9;
         this.fly.y *= 0.9;
         this.fly.x += Math.random() - 0.5;
         this.fly.y += Math.random() - 0.5;
         this.fly.y -= 2 * param2.size * param1.GetMass();
         if(Math.random() > 0.9)
         {
            this.fly.x += 50 * Math.random() - 25;
            this.fly.y += 50 * Math.random() - 25;
         }
         if(this.target != null)
         {
            this.fly.x = -pixelCenter.x + this.target.GetPosition().x * Physics.scale;
            this.fly.y = -pixelCenter.y + this.target.GetPosition().y * Physics.scale;
         }
         param1.ApplyForce(this.fly,bodyCenter);
         if(!this.decals)
         {
            this.decals = param2.graphic.getChildByName("decals") as Sprite;
         }
         this.animate();
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(ud.triggerState != 1)
         {
            return true;
         }
         if(ud.ignored.indexOf(param1) != -1)
         {
            return true;
         }
         if(!userData(param1.GetUserData()).alive)
         {
            return true;
         }
         Body.Damage(param1,Math.random() * (100 + userData(param1.GetUserData()).maxhealth * 0.01) + 100,param5,param5,param5,false);
         if(Math.random() > 0.8)
         {
            this.Bite(param1);
         }
         if(userData(param1.GetUserData()).health <= 0)
         {
            this.eaten = param1;
         }
         return true;
      }
      
      private function Bite(param1:b2Body) : void
      {
         var _loc2_:b2Vec2 = null;
         var _loc3_:userData = null;
         var _loc5_:Sprite = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:b2Vec2 = null;
         _loc2_ = new b2Vec2();
         _loc3_ = userData(param1.GetUserData());
         _loc2_.x = Math.random() * _loc3_.width - _loc3_.width * 0.5;
         _loc2_.y = Math.random() * _loc3_.height - _loc3_.height * 0.5;
         var _loc4_:BitmapData = BoxUtils.getEffectBMD(param1);
         if(_loc4_)
         {
            _loc5_ = new Sprite();
            _loc5_.graphics.lineStyle(0,0,0);
            _loc6_ = new b2Vec2();
            _loc6_.Multiply(Physics.scale);
            _loc6_.x -= Bitmap(_loc3_.graphic.getChildByName("effects")).x;
            _loc6_.y -= Bitmap(_loc3_.graphic.getChildByName("effects")).y;
            _loc5_.graphics.beginFill(_loc3_.bloodColour,1);
            _loc7_ = _loc6_.x + _loc2_.x;
            _loc8_ = _loc6_.y + _loc2_.y;
            _loc5_.graphics.drawCircle(_loc7_,_loc8_,Math.random() * 2 + 3);
            _loc5_.graphics.beginFill(GraphicUtils.scalehex(_loc3_.bloodColour,0.5),1);
            _loc5_.graphics.drawCircle(_loc7_ + Math.random() * 2 - 1,_loc8_ + Math.random() * 2 - 1,Math.random() * 2 + 1);
            _loc5_.graphics.endFill();
            _loc9_ = new b2Vec2(_loc7_,_loc8_);
            _loc9_.x += param1.GetPosition().x * Physics.scale - pixelCenter.x;
            _loc9_.y += param1.GetPosition().y * Physics.scale - pixelCenter.y;
            _loc4_.draw(_loc5_);
         }
      }
      
      private function animate() : void
      {
         var _loc1_:Number = -ud.graphic.rotation + (this.wings == 1 ? Math.random() * 30 : Math.random() * -30);
         this.decals.rotation = _loc1_;
         this.wings *= -1;
      }
   }
}

