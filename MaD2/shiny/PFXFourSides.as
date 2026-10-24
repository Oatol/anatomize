package shiny
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   
   public class PFXFourSides extends ParticleEffect
   {
      
      internal var w:Number;
      
      internal var h:Number;
      
      internal var pos:Vector.<b2Vec2>;
      
      public function PFXFourSides(param1:b2Body, param2:b2Vec2 = null)
      {
         super(param1,param2);
         this.init();
         applyOffset = false;
      }
      
      override protected function init() : void
      {
         this.pos = new Vector.<b2Vec2>();
         this.w = ud.width * 0.5;
         this.h = ud.height * 0.5;
         this.pos.push(new b2Vec2(0 + this.w,0));
         this.pos.push(new b2Vec2(0,0 + this.h));
         this.pos.push(new b2Vec2(0 - this.w,0));
         this.pos.push(new b2Vec2(0,0 - this.h));
      }
      
      override public function update() : void
      {
         super.update();
         var _loc1_:Number = body.GetPosition().x * Physics.scale;
         var _loc2_:Number = body.GetPosition().y * Physics.scale;
         var _loc3_:Number = body.GetAngle();
         var _loc4_:b2Vec2 = BoxUtils.rotateVec(this.pos[0],_loc3_);
         var _loc5_:b2Vec2 = BoxUtils.rotateVec(this.pos[1],_loc3_);
         var _loc6_:b2Vec2 = BoxUtils.rotateVec(this.pos[2],_loc3_);
         var _loc7_:b2Vec2 = BoxUtils.rotateVec(this.pos[3],_loc3_);
         addParticles(_loc1_ + _loc4_.x * size,_loc2_ + _loc4_.y * size,1,"sparkle",0,0,1,1);
         addParticles(_loc1_ + _loc5_.x * size,_loc2_ + _loc5_.y * size,1,"sparkle",0,0,1,1);
         addParticles(_loc1_ + _loc6_.x * size,_loc2_ + _loc6_.y * size,1,"sparkle",0,0,1,1);
         addParticles(_loc1_ + _loc7_.x * size,_loc2_ + _loc7_.y * size,1,"sparkle",0,0,1,1);
      }
   }
}

