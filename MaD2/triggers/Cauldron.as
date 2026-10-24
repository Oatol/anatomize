package triggers
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Cauldron extends Trigger
   {
      
      protected var maxProjectiles:int = 50;
      
      protected var whenToBoilOver:int = 10;
      
      protected var elements:Array;
      
      public function Cauldron()
      {
         super();
      }
      
      override public function init(param1:b2Body, param2:userData) : void
      {
         super.init(param1,param2);
         this.elements = [];
      }
      
      override public function OnLoadCustom() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         if(ud.triggerCustom)
         {
            _loc1_ = ud.triggerCustom.split(".");
            _loc2_ = 0;
            while(_loc2_ < ud.triggerDuration)
            {
               this.elements.push(_loc1_[int(Math.random() * _loc1_.length)]);
               _loc2_++;
            }
         }
         this.Effect();
      }
      
      override public function OnSaveCustom() : void
      {
         var _loc2_:String = null;
         super.OnSaveCustom();
         var _loc1_:Array = [];
         for each(_loc2_ in this.elements)
         {
            if(_loc1_.indexOf(_loc2_) == -1)
            {
               _loc1_.push(_loc2_);
            }
         }
         ud.triggerCustom = _loc1_.join(".");
         ud.triggerDuration = this.elements.length;
      }
      
      override public function trigger(param1:b2Body, param2:userData) : void
      {
         super.trigger(param1,param2);
         if(this.elements.length > this.whenToBoilOver)
         {
            if(Math.random() > 0.9)
            {
               this.boil();
            }
         }
         if(this.elements.length > this.maxProjectiles)
         {
            if(Math.random() > 0.9)
            {
               this.boil();
            }
         }
      }
      
      internal function boil() : void
      {
         var _loc9_:b2Vec2 = null;
         if(this.elements.length == 0)
         {
            return;
         }
         this.Effect();
         var _loc1_:int = int(Math.random() * this.elements.length);
         var _loc2_:String = this.elements[_loc1_];
         var _loc3_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(ud.size * triggerPos.x / Physics.scale,ud.size * -triggerPos.y / Physics.scale),bodyAngle);
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(new b2Vec2(ud.size * -triggerPos.x / Physics.scale,ud.size * -triggerPos.y / Physics.scale),bodyAngle);
         var _loc5_:Number = (_loc4_.y - _loc3_.y) / (_loc4_.x - _loc3_.x);
         var _loc6_:Number = _loc3_.x + Math.random() * (_loc4_.x - _loc3_.x);
         var _loc7_:Number = _loc3_.y + _loc5_ * (_loc6_ - _loc3_.x);
         var _loc8_:b2Body = GameState.objects.addbullet(_loc2_,bodyCenter.x + _loc6_,bodyCenter.y + _loc7_,Math.random() * 360,1,Math.random() * 0.4 + 0.8,new b2Vec2(Math.random() * 10 - 5 + _loc6_,Math.random() * 10 - 5 + _loc7_),10,body);
         if(_loc8_)
         {
            userData(_loc8_.GetUserData()).ignore = "largecauldron";
            _loc9_ = new b2Vec2(0,_loc8_.GetMass() * ud.triggerForce * 0.1);
            _loc9_ = BoxUtils.rotateVec(_loc9_,bodyAngle + Math.PI);
            _loc8_.ApplyImpulse(_loc9_,_loc8_.GetPosition());
         }
         if(this.maxProjectiles > 1)
         {
            this.elements.splice(_loc1_,1);
         }
      }
      
      override public function OnCollision(param1:b2Body, param2:ShapeUserData, param3:ShapeUserData, param4:Number, param5:b2Vec2, param6:b2Vec2) : Boolean
      {
         if(!super.OnCollision(param1,param2,param3,param4,param5,param6))
         {
            return false;
         }
         var _loc7_:userData = userData(param1.GetUserData());
         if(_loc7_.ignore == "largecauldron")
         {
            return true;
         }
         if(!_loc7_.projectile)
         {
            return true;
         }
         if(!_loc7_.projectileName)
         {
            return true;
         }
         _loc7_.dead = true;
         if(this.maxProjectiles == 1)
         {
            this.elements = [];
         }
         this.elements.push(_loc7_.projectileName);
         this.Effect();
         return false;
      }
      
      protected function Effect() : void
      {
      }
   }
}

