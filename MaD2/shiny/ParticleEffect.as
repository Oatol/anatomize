package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.utils.getQualifiedClassName;
   
   public class ParticleEffect
   {
      
      private var roffset:b2Vec2;
      
      private var name:String;
      
      public var applyOffset:Boolean = true;
      
      private var _applyScale:Boolean = false;
      
      private var _applyGravity:Boolean = false;
      
      public var replaceDefault:Boolean = false;
      
      private var _body:b2Body;
      
      public var ud:userData;
      
      protected var _ratios:Vector.<Number>;
      
      protected var _particles:Vector.<String>;
      
      public var offset:b2Vec2;
      
      public var radius:Number = 25;
      
      public var size:Number = 1;
      
      public var speed:Number = 1;
      
      public var hull:Array;
      
      public var elementIcon:String;
      
      public var effectIcon:String;
      
      public var elementLabel:String = "Element";
      
      public var effectLabel:String = "Effect";
      
      public var amount:Number = 0.5;
      
      public var noRadius:Boolean = false;
      
      public var noAmount:Boolean = false;
      
      public var noSpeed:Boolean = false;
      
      public var noCenter:Boolean = false;
      
      public var noScale:Boolean = false;
      
      public function ParticleEffect(param1:b2Body, param2:b2Vec2 = null)
      {
         super();
         this.name = getQualifiedClassName(this).replace("shiny::PFX","");
         this._ratios = new Vector.<Number>();
         this._particles = new Vector.<String>();
         this.body = param1;
         this.ud = param1.GetUserData() as userData;
         if(param2)
         {
            this.offset = new b2Vec2(param1.GetPosition().x - param2.x,param1.GetPosition().y - param2.y);
            this.offset = BoxUtils.rotateVec(this.offset,-this.body.GetAngle());
            this.offset.Multiply(Physics.scale);
         }
         else
         {
            this.offset = new b2Vec2();
         }
         this.init();
      }
      
      protected function init() : void
      {
      }
      
      protected function initHull() : void
      {
         this.hull = this.ud.hull;
      }
      
      protected function initRadius() : void
      {
         this.radius = this.ud.width;
         if(this.ud.height > this.radius)
         {
            this.radius = this.ud.height;
         }
         this.radius *= 0.5;
         if(!this.applyScale)
         {
            this.radius = 25;
         }
      }
      
      public function attachParticles(param1:Number, param2:String) : *
      {
         this._ratios.push(param1);
         this._particles.push(param2);
      }
      
      public function set particles(param1:Vector.<String>) : void
      {
         this._particles = param1.slice();
      }
      
      public function get particles() : Vector.<String>
      {
         return this._particles.slice();
      }
      
      public function get ratios() : Vector.<Number>
      {
         return this._ratios.slice();
      }
      
      public function set ratios(param1:Vector.<Number>) : void
      {
         this._ratios = param1.slice();
      }
      
      public function get applyScale() : Boolean
      {
         return this._applyScale;
      }
      
      public function set applyScale(param1:Boolean) : void
      {
         this._applyScale = param1;
         if(!param1)
         {
            this.radius = 25;
         }
         else
         {
            this.initRadius();
         }
      }
      
      public function get applyGravity() : Boolean
      {
         return this._applyGravity;
      }
      
      public function set applyGravity(param1:Boolean) : void
      {
         this._applyGravity = param1;
      }
      
      public function get body() : b2Body
      {
         return this._body;
      }
      
      public function set body(param1:b2Body) : void
      {
         this._body = param1;
         if(this.body)
         {
            this.ud = userData(this.body.GetUserData());
         }
      }
      
      public function update() : void
      {
         this.roffset = BoxUtils.rotateVec(this.offset,this.body.GetAngle());
      }
      
      public function addParticles(param1:Number, param2:Number, param3:Number, param4:String, param5:* = 0, param6:* = 0, param7:Number = 1, param8:Number = 1, param9:Boolean = false) : Vector.<MyLittleParticle>
      {
         if(this._particles.length == 0)
         {
            return new Vector.<MyLittleParticle>();
         }
         if(Math.random() > this.amount)
         {
            return new Vector.<MyLittleParticle>();
         }
         if(this.applyOffset)
         {
            param1 -= this.roffset.x;
            param2 -= this.roffset.y;
         }
         param5 += this.body.GetLinearVelocity().x * 0.1;
         param6 += this.body.GetLinearVelocity().y * 0.1;
         var _loc10_:String = this.getParticle();
         var _loc11_:Vector.<MyLittleParticle> = GameState.particles.addParticles(param1,param2,param3,_loc10_,param5,param6,param7,param8,param9);
         var _loc12_:int = GameState.particles.names.indexOf(_loc10_);
         return _loc11_;
      }
      
      public function PasteProperties(param1:ParticleEffect) : void
      {
         param1.amount = this.amount;
         param1.ratios = this.ratios;
         param1.particles = this.particles;
         param1.speed = this.speed;
         param1.size = this.size;
         param1.effectIcon = this.effectIcon;
         param1.elementIcon = this.elementIcon;
         param1.effectLabel = this.effectLabel;
         param1.elementLabel = this.elementLabel;
         param1.applyOffset = this.applyOffset;
         param1.applyScale = this.applyScale;
      }
      
      public function Summarise() : String
      {
         var _loc3_:Number = NaN;
         var _loc1_:String = "";
         var _loc2_:Vector.<Number> = new Vector.<Number>();
         for each(_loc3_ in this._ratios)
         {
            _loc2_.push(_loc3_ * 100 >> 0);
         }
         _loc1_ += "FXE=" + this.name;
         _loc1_ += ",FXPA=" + this._particles.join(".");
         _loc1_ += ",FXR=" + _loc2_.join(".");
         _loc1_ += ",FXSP=" + this.speed;
         _loc1_ += ",FXSZ=" + this.size;
         _loc1_ += ",FXN=" + this.amount;
         if(this.applyOffset)
         {
            _loc1_ += ",FXPO=" + Math.round(this.offset.x).toString() + "." + Math.round(this.offset.y).toString();
         }
         return _loc1_ + (",FXSC=" + (this._applyScale ? "1" : "0"));
      }
      
      public function getParticle() : String
      {
         if(this._particles.length == 0)
         {
            return null;
         }
         if(this._particles.length == 1)
         {
            return this._particles[0];
         }
         var _loc1_:Number = Math.random();
         var _loc2_:int = int(this._ratios.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc1_ < this._ratios[_loc3_])
            {
               return this._particles[_loc3_];
            }
            _loc3_++;
         }
         return this._particles[0];
      }
   }
}

