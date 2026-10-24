package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class BrickFist extends ArmourGlove
   {
      
      private var sp:b2Vec2;
      
      internal var brickcols:Array = [15922162,1780276,16108847,12855323,879019,10593698];
      
      internal var convert:b2Body;
      
      public function BrickFist(param1:b2Body)
      {
         super(param1,123,0.5,0.5,100);
         collideWithDolls = true;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:Vector.<Array> = null;
         var _loc6_:uint = 0;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:b2Vec2 = null;
         var _loc10_:b2Body = null;
         var _loc11_:b2Vec2 = null;
         if(ud.triggerState == 1)
         {
            super.trigger(param1,param2);
            ud.triggerState = 0;
            ud.triggered = true;
            return;
         }
         if(!this.convert)
         {
            return;
         }
         ud.triggered = false;
         _loc3_ = this.convert.GetWorldCenter();
         _loc3_.Multiply(Physics.scale);
         Body.Destroy(this.convert,"brickfist");
         this.convert = null;
         _loc4_ = new Vector.<Array>();
         _loc4_ = new Vector.<Array>();
         _loc4_.push(["ca392d","FFFFFF"]);
         _loc4_.push(["e03f33","FFFFFF"]);
         var _loc5_:int = 0;
         while(_loc5_ < Math.random() * 3 + 3)
         {
            _loc6_ = uint(this.brickcols[int(Math.random() * this.brickcols.length)]);
            _loc4_ = BoxUtils.replaceSkinColour(_loc4_,"ca392d",GraphicUtils.scalehex(_loc6_,0.9).toString(16));
            _loc4_ = BoxUtils.replaceSkinColour(_loc4_,"e03f33",_loc6_.toString(16));
            _loc7_ = GameState.objects.spawnSkin;
            GameState.objects.spawnSkin = _loc4_;
            _loc8_ = Vars.objSize;
            Vars.objSize = 0.4;
            _loc9_ = _loc3_;
            _loc9_.x += Math.random() * 20 - 10;
            _loc9_.y += Math.random() * 20 - 10;
            _loc10_ = GameState.objects.delayedSpawnObject(Math.random() > 0.5 ? "legobrick" : "smalllegobrick",_loc3_.x,_loc3_.y,Math.random() * 360,false,true);
            GameState.objects.spawnSkin = _loc7_;
            userData(_loc10_.GetUserData()).ignore = "legobrick";
            userData(_loc10_.GetUserData()).trigger = new TempProjectile(60 + Math.random() * 60);
            userData(_loc10_.GetUserData()).triggerOnContact = true;
            _loc11_ = new b2Vec2(Math.random() - 0.5,Math.random() - 0.5);
            _loc11_.Multiply(50);
            _loc10_.ApplyImpulse(_loc11_,_loc10_.GetWorldCenter());
            Vars.objSize = _loc8_;
            _loc5_++;
         }
      }
      
      override protected function Position(param1:b2Body) : void
      {
         var _loc3_:b2Body = null;
         var _loc4_:b2Body = null;
         Body.RemoveJoints(body);
         var _loc2_:Array = BoxUtils.selectCompound(param1);
         for each(_loc4_ in _loc2_)
         {
            if(userData(_loc4_.GetUserData()).name == "doll_head")
            {
               _loc3_ = _loc4_;
               break;
            }
         }
         if(!_loc3_)
         {
            return;
         }
         var _loc5_:b2Vec2 = new b2Vec2(0,-1);
         var _loc6_:b2Vec2 = new b2Vec2(0,1);
         _loc5_ = BoxUtils.rotateVec(_loc5_,_loc3_.GetAngle());
         _loc6_ = BoxUtils.rotateVec(_loc6_,_loc3_.GetAngle());
         _loc5_.Add(_loc3_.GetPosition());
         _loc6_.Add(_loc3_.GetPosition());
         var _loc7_:Number = GeneralUtils.determinant(_loc5_.x,_loc5_.y,_loc6_.x,_loc6_.y,param1.GetPosition().x,param1.GetPosition().y);
         if(_loc7_ > 0)
         {
            this.sp = new b2Vec2(-20 * ud.size,0 * ud.size);
            this.sp.Multiply(userData(param1.GetUserData()).size);
         }
         else
         {
            this.sp = new b2Vec2(20 * ud.size,0 * ud.size);
            this.sp.Multiply(userData(param1.GetUserData()).size);
         }
         var _loc8_:Number = param1.GetAngle();
         this.sp = BoxUtils.rotateVec(this.sp,_loc8_);
         this.sp.Multiply(1 / Physics.scale);
         if(ud.flipped)
         {
            equipAngle = -Vars.PI * 0.5;
         }
         else
         {
            equipAngle = Vars.PI * 0.5;
         }
         body.SetXForm(new b2Vec2(this.sp.x + param1.GetPosition().x,this.sp.y + param1.GetPosition().y),_loc8_ + equipAngle);
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         if(param3.name != "ff0000")
         {
            ud.triggerState = 1;
            ud.triggered = true;
            return true;
         }
         if(param1.IsStatic())
         {
            return true;
         }
         if(this.convert)
         {
            return true;
         }
         var _loc7_:userData = param1.GetUserData();
         if(!_loc7_ || _loc7_.dead)
         {
            return true;
         }
         if(_loc7_.name == "legobrick")
         {
            return true;
         }
         if(_loc7_.name == "smalllegobrick")
         {
            return true;
         }
         this.convert = param1;
         ud.triggered = true;
         return true;
      }
      
      override public function OnDelete() : void
      {
         if(attachedBody)
         {
            userData(attachedBody.GetUserData()).trigger.reset();
         }
         super.OnDelete();
      }
   }
}

