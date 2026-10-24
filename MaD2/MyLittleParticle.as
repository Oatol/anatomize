package
{
   import environment.Environment;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class MyLittleParticle
   {
      
      private var pos:Point = new Point(0,0);
      
      private var old:Point = new Point(0,0);
      
      private var vel:Point = new Point(0,0);
      
      public var cap:Number = 100;
      
      public var bounds:Rectangle = new Rectangle();
      
      public var health:Number = 100;
      
      public var restitution:Number = 0.1;
      
      public var friction:Number = 1;
      
      public var fade:Number = 0;
      
      public var wander:Number = 0;
      
      public var wanderX:Number = 0;
      
      public var wanderY:Number = 0;
      
      public var collide:Boolean = false;
      
      public var colour:uint = 4294901760;
      
      public var sprite:String;
      
      internal var walls:int = 15;
      
      internal var env:Environment;
      
      internal var left:Number;
      
      internal var right:Number;
      
      internal var top:Number;
      
      internal var bottom:Number;
      
      internal var wallL:Boolean;
      
      internal var wallR:Boolean;
      
      internal var wallU:Boolean;
      
      internal var wallD:Boolean;
      
      public function MyLittleParticle(param1:Rectangle, param2:Number, param3:Number, param4:Number, param5:Number)
      {
         super();
         this.pos.x = param2;
         this.pos.y = param3;
         this.vel.x = param4;
         this.vel.y = param5;
         if(this.vel.x > this.cap)
         {
            this.vel.x = this.cap;
         }
         if(this.vel.y > this.cap)
         {
            this.vel.y = this.cap;
         }
         if(this.vel.x < -this.cap)
         {
            this.vel.x = -this.cap;
         }
         if(this.vel.y < -this.cap)
         {
            this.vel.y = -this.cap;
         }
         this.env = GameState.environment;
         this.left = this.env.borderLeft + this.walls;
         this.right = this.env.borderRight - this.walls;
         this.top = -this.env.borderTop + GameState.height + this.walls;
         this.bottom = GameState.height - this.walls;
         this.wallL = this.env.wallL;
         this.wallR = this.env.wallR;
         this.wallU = this.env.roof;
         this.wallD = this.env.floor;
      }
      
      private function rand(param1:Number) : Number
      {
         return Math.random() * param1;
      }
      
      public function update(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:Number = NaN;
         if(param3 == 0)
         {
            return;
         }
         if(this.wander != 0)
         {
            this.wanderX = Math.random() * this.wander - this.wander * 0.5;
            this.wanderY = Math.random() * this.wander - this.wander * 0.5;
            this.vel.x += this.wanderX * param3;
            this.vel.y += this.wanderY * param3;
         }
         else if(this.wanderX != 0 || this.wanderY != 0)
         {
            this.vel.x += Math.random() * this.wanderX - this.wanderX * 0.5;
            this.vel.y += Math.random() * this.wanderY - this.wanderY * 0.5;
         }
         if(this.friction != 1)
         {
            if(this.friction > 1)
            {
               _loc4_ = (this.friction - 1) * param3;
               this.vel.x *= 1 + _loc4_;
               this.vel.y *= 1 + _loc4_;
            }
            else
            {
               _loc4_ = (1 - this.friction) * param3;
               this.vel.x *= 1 - _loc4_;
               this.vel.y *= 1 - _loc4_;
            }
         }
         this.old.x = this.pos.x;
         this.old.y = this.pos.y;
         this.pos.x += this.vel.x * param3;
         this.pos.y += this.vel.y * param3;
         if(this.fade > 0)
         {
            this.health -= this.fade * param3;
         }
         if(this.vel.length < 1 * param3)
         {
            this.health -= 5 * param3;
         }
         this.vel.x += param2 * param3;
         this.vel.y += param1 * param3;
         if(this.collide)
         {
            this.checkWalls();
         }
      }
      
      private function checkWalls() : void
      {
         var _loc1_:Number = 9000;
         if(this.pos.x < -_loc1_ || this.pos.x > _loc1_ || this.pos.y < -_loc1_ || this.pos.y > _loc1_)
         {
            this.health = 0;
            return;
         }
         if(this.wallR && this.pos.x > this.right)
         {
            if(this.restitution == -1)
            {
               this.health = 0;
               return;
            }
            this.vel.x *= -this.restitution;
            this.vel.y *= this.restitution;
            this.pos.x = this.right;
         }
         if(this.wallL && this.pos.x < this.left)
         {
            if(this.restitution == -1)
            {
               this.health = 0;
               return;
            }
            this.vel.x *= -this.restitution;
            this.vel.y *= this.restitution;
            this.pos.x = this.left;
         }
         if(this.wallU && this.pos.y < this.top || this.wallD && this.pos.y > this.bottom)
         {
            if(this.restitution == -1)
            {
               this.health = 0;
               return;
            }
            this.vel.x *= this.restitution;
            this.vel.y *= -this.restitution;
            if(this.pos.y > this.bottom)
            {
               this.pos.y = this.bottom;
            }
            else if(this.pos.y < -this.top)
            {
               this.pos.y = this.top;
            }
         }
      }
      
      public function get x() : Number
      {
         return this.pos.x;
      }
      
      public function get y() : Number
      {
         return this.pos.y;
      }
      
      public function get px() : Number
      {
         return this.old.x;
      }
      
      public function get py() : Number
      {
         return this.old.y;
      }
      
      public function get v() : Point
      {
         return this.vel;
      }
      
      public function set vx(param1:Number) : void
      {
         this.vel.x = param1;
      }
      
      public function set vy(param1:Number) : void
      {
         this.vel.y = param1;
      }
      
      public function set x(param1:Number) : void
      {
         this.pos.x = param1;
      }
      
      public function set y(param1:Number) : void
      {
         this.pos.y = param1;
      }
      
      public function get remove() : Boolean
      {
         return this.health <= 0;
      }
   }
}

