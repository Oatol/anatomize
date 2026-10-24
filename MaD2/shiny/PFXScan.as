package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PFXScan extends ParticleEffect
   {
      
      internal var left:Number;
      
      internal var right:Number;
      
      internal var width:Number;
      
      internal var pos:Vector.<b2Vec2>;
      
      internal var looper:Number = 0;
      
      internal var loopdir:Number = 1;
      
      public function PFXScan(param1:b2Body, param2:b2Vec2 = null)
      {
         super(param1,param2);
         this.init();
      }
      
      override protected function init() : void
      {
         applyOffset = false;
         this.pos = new Vector.<b2Vec2>();
         this.left = -ud.height * 0.5;
         this.right = ud.height * 0.5;
         this.width = ud.width;
      }
      
      override public function update() : void
      {
         super.update();
         this.looper += this.loopdir * speed;
         if(this.looper > this.right || this.looper < this.left)
         {
            this.loopdir *= -1;
         }
         var _loc1_:Number = body.GetPosition().x * Physics.scale;
         var _loc2_:Number = body.GetPosition().y * Physics.scale;
         var _loc3_:Number = body.GetAngle();
         var _loc4_:b2Vec2 = new b2Vec2(Math.random() * this.width - ud.width * 0.5,this.looper);
         var _loc5_:b2Vec2 = BoxUtils.rotateVec(_loc4_,_loc3_);
         addParticles(_loc1_ + _loc5_.x,_loc2_ + _loc5_.y,1,"sparkle",0,0,1,1);
      }
   }
}

