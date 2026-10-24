package
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class Explosion
   {
      
      private var _position:b2Vec2;
      
      private var _radius:Number;
      
      private var _force:Number;
      
      private var _raycast:Boolean;
      
      private var _raycastAccuracy:int;
      
      private var _raycastName:String;
      
      private var _cut:Boolean;
      
      private var _cutAccuracy:int;
      
      private var _shadows:Boolean;
      
      private var _shadowBodies:Array = [];
      
      private var _queryBodies:Vector.<b2Body> = new Vector.<b2Body>();
      
      private var _queryPoints:Vector.<b2Vec2> = new Vector.<b2Vec2>();
      
      internal var ignores:Array = [];
      
      public function Explosion(param1:b2Vec2, param2:Number, param3:Number, param4:Boolean, param5:int = 10, param6:String = "normal", param7:Array = null)
      {
         super();
         this._position = param1;
         this._radius = param2;
         this._force = param3;
         this._raycast = true;
         this._raycastAccuracy = 60;
         this._raycastName = param6;
         this._cut = param5 > 0;
         this._cutAccuracy = param5;
         this._shadows = param4;
         if(param7)
         {
            this.ignores = param7;
         }
         this.damage();
         this.query();
         this.explode();
      }
      
      private function damage() : void
      {
         var _loc2_:b2Body = null;
         var _loc3_:int = 0;
         var _loc4_:b2Vec2 = null;
         if(!this._cut)
         {
            return;
         }
         var _loc1_:Vector.<b2Body> = new Vector.<b2Body>();
         for each(_loc2_ in this.ignores)
         {
            _loc1_.push(_loc2_);
         }
         _loc3_ = 0;
         while(_loc3_ <= this._cutAccuracy)
         {
            GameState.madeby = "explosion";
            _loc4_ = GeneralUtils.pointOnCircle(this._position.x,this._position.y,this._radius,Math.random() * 360);
            GameState.cutter.Exclude(_loc1_);
            GameState.cutter.CustomCut(_loc4_,this._position,3,this._radius,0);
            _loc3_++;
         }
      }
      
      private function query() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Array = null;
         this._queryBodies = new Vector.<b2Body>();
         this._queryPoints = new Vector.<b2Vec2>();
         if(this._raycast)
         {
            _loc1_ = 0;
            while(_loc1_ <= this._raycastAccuracy)
            {
               _loc2_ = GameState.cutter.CustomRaycast(new b2Vec2(this._position.x,this._position.y),this._radius,GeneralUtils.pointOnCircle(this._position.x,this._position.y,1,_loc1_ * (360 / this._raycastAccuracy)),true,this._raycastName);
               if(_loc2_[0])
               {
                  this._queryBodies.push(_loc2_[0]);
                  this._queryPoints.push(_loc2_[1]);
               }
               _loc1_++;
            }
         }
      }
      
      private function explode() : void
      {
         var _loc3_:b2Body = null;
         var _loc4_:b2Vec2 = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:b2Vec2 = null;
         var _loc1_:int = int(this._queryBodies.length);
         this._shadowBodies = [];
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._queryBodies[_loc2_];
            _loc4_ = this._queryPoints[_loc2_];
            if(_loc3_)
            {
               if(this.ignores.indexOf(userData(_loc3_.GetUserData()).name) == -1)
               {
                  if(userData(_loc3_.GetUserData()).name != "boomstaff")
                  {
                     if(userData(_loc3_.GetUserData()).name != "mininuke")
                     {
                        if(this._shadows)
                        {
                           if(this._shadowBodies.indexOf(_loc3_) == -1)
                           {
                              this._shadowBodies.push(_loc3_);
                           }
                        }
                        if(!_loc3_.IsStatic())
                        {
                           _loc3_.WakeUp();
                           _loc5_ = new b2Vec2(_loc4_.x - this._position.x / Physics.scale,_loc4_.y - this._position.y / Physics.scale);
                           _loc6_ = _loc5_.Normalize();
                           _loc7_ = (this._radius - _loc6_) / this._radius * this._force;
                           _loc8_ = new b2Vec2(_loc5_.x * _loc7_,_loc5_.y * _loc7_);
                           Body.Damage(_loc3_,_loc8_.Length() * 0.01,_loc3_.GetWorldCenter(),_loc8_,null,false);
                           _loc3_.ApplyForce(_loc8_,_loc3_.GetLocalPoint(_loc4_));
                        }
                     }
                  }
               }
            }
            _loc2_++;
         }
         if(this._shadows)
         {
            Shadows.lightPos = this._position.Copy();
            Shadows.lightRadius = 100;
            Main.instance.drawShadowsFor(this._shadowBodies,30);
         }
      }
   }
}

