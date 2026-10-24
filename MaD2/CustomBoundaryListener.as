package
{
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.*;
   import Box2D.Common.Math.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Contacts.*;
   
   public class CustomBoundaryListener extends b2BoundaryListener
   {
      
      private var Contact:Boolean = false;
      
      private var Bodies:Vector.<b2Body> = new Vector.<b2Body>();
      
      public function CustomBoundaryListener()
      {
         super();
      }
      
      override public function Violation(param1:b2Body) : void
      {
         this.Contact = true;
         this.Bodies.push(param1);
      }
      
      public function get contact() : *
      {
         return this.Contact;
      }
      
      public function get bodies() : *
      {
         return this.Bodies;
      }
      
      public function done() : *
      {
         this.Contact = false;
         this.Bodies = new Vector.<b2Body>();
      }
   }
}

