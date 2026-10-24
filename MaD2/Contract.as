package
{
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Dynamics.b2Body;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class Contract extends Sprite
   {
      
      private var items:Vector.<String>;
      
      private var itemPos:Vector.<b2Vec2>;
      
      private var previewItems:Vector.<String>;
      
      private var previewPos:Vector.<b2Vec2>;
      
      private var targetAreas:Vector.<ContractArea>;
      
      public var targets:Vector.<ContractTarget>;
      
      public var previewing:Boolean = false;
      
      private var _enabled:Boolean = false;
      
      private var targetType:String;
      
      private var timer:Timer;
      
      private var spawnItem:String;
      
      private var spawnPos:b2Vec2;
      
      public var areaSpawn:Boolean;
      
      public var areaDrag:Boolean;
      
      public var areaTrigger:Boolean;
      
      public var areaCut:Boolean;
      
      public var areaDestroy:Boolean;
      
      public var areaPower:Boolean;
      
      public var areaOther:Boolean;
      
      public var itemholder:Sprite = new Sprite();
      
      public var target:int = -1;
      
      public var creator:String = "Guest";
      
      public var title:String = "! REDACTED !";
      
      public function Contract()
      {
         super();
         this.Reset();
         this.timer = new Timer(2000);
         this.timer.addEventListener(TimerEvent.TIMER,this.checkTargets);
      }
      
      public function save(param1:Vector.<b2Body>) : String
      {
         var _loc4_:ContractArea = null;
         var _loc9_:int = 0;
         var _loc10_:ContractTarget = null;
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < this.items.length)
         {
            _loc2_ += "NM=" + this.items[_loc3_];
            _loc2_ += ",PX=" + this.itemPos[_loc3_].x;
            _loc2_ += ",PY=" + this.itemPos[_loc3_].y;
            if(_loc3_ != this.items.length - 1)
            {
               _loc2_ += ";";
            }
            _loc3_++;
         }
         _loc2_ += "|";
         var _loc5_:Vector.<int> = new Vector.<int>();
         var _loc6_:int = 0;
         while(_loc6_ < param1.length)
         {
            _loc9_ = 0;
            while(_loc9_ < this.targets.length)
            {
               _loc10_ = this.targets[_loc9_];
               if(_loc10_.type == 4)
               {
                  if(_loc10_.body == param1[_loc6_])
                  {
                     _loc5_.push(_loc9_);
                  }
               }
               _loc9_++;
            }
            _loc6_++;
         }
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         while(_loc8_ < this.areas.length)
         {
            _loc4_ = this.areas[_loc8_];
            _loc2_ += "PX=" + _loc4_.x;
            _loc2_ += ",PY=" + _loc4_.y;
            _loc2_ += ",W=" + _loc4_.width;
            _loc2_ += ",H=" + _loc4_.height;
            if(_loc4_.spawning)
            {
               _loc2_ += ",SP=1";
            }
            if(_loc4_.dragging)
            {
               _loc2_ += ",DR=1";
            }
            if(_loc4_.triggering)
            {
               _loc2_ += ",TR=1";
            }
            if(_loc4_.cutting)
            {
               _loc2_ += ",CU=1";
            }
            if(_loc4_.deleting)
            {
               _loc2_ += ",DE=1";
            }
            if(_loc4_.power)
            {
               _loc2_ += ",PO=1";
            }
            if(_loc4_.target)
            {
               _loc2_ += ",TA=" + _loc5_[_loc7_];
               _loc7_++;
            }
            if(_loc8_ != this.areas.length - 1)
            {
               _loc2_ += ";";
            }
            _loc8_++;
         }
         return _loc2_;
      }
      
      public function addItem(param1:String, param2:b2Vec2) : void
      {
         this.items.push(param1);
         this.itemPos.push(param2.Copy());
         this.updateItems();
      }
      
      public function updateItems() : void
      {
         var _loc3_:String = null;
         var _loc4_:Item = null;
         var _loc5_:Sprite = null;
         while(this.itemholder.numChildren > 0)
         {
            this.itemholder.removeChildAt(0);
         }
         var _loc1_:Number = 0.5;
         var _loc2_:int = 0;
         for each(_loc3_ in this.items)
         {
            _loc4_ = O.getItem(_loc3_);
            if(_loc4_)
            {
               _loc5_ = _loc4_.updateGraphic(null);
               _loc5_.scaleX = _loc5_.scaleY = _loc1_;
               _loc5_.x = this.itemPos[_loc2_].x - this.itemholder.x;
               _loc5_.y = this.itemPos[_loc2_].y - this.itemholder.y;
               this.itemholder.addChild(_loc5_);
               _loc2_++;
            }
         }
      }
      
      public function addTargetBody(param1:b2Body) : Boolean
      {
         var _loc5_:ContractTarget = null;
         var _loc2_:* = "";
         var _loc3_:userData = userData(param1.GetUserData());
         var _loc4_:Boolean = false;
         for each(_loc5_ in this.targets)
         {
            if(param1 == _loc5_.body)
            {
               _loc4_ = true;
               break;
            }
         }
         if(_loc4_)
         {
            _loc2_ = "This item already has a Target, remove it in Contract main screen first.\n\n";
         }
         else if(this.target == 2 && !_loc3_.alive && !_loc3_.armour)
         {
            _loc2_ = "Pick an alive item for this Target.\n";
         }
         else if(this.target == 5 && !_loc3_.trigger)
         {
            _loc2_ = "Pick a triggerable item for this Target.\n";
         }
         else if(this.target == 6)
         {
            if(_loc3_.alive || _loc3_.health >= _loc3_.maxhealth)
            {
               _loc2_ = "Pick a damaged alive item for this Target.\n";
            }
         }
         if(_loc2_ != "")
         {
            this.target = -1;
            GameState.ui.showTooltip(_loc3_.graphic,_loc2_,100,2000,200);
            return false;
         }
         _loc3_.target = this.target;
         this.targets.push(new ContractTarget(param1,this.target));
         this.target = -1;
         this.timer.start();
         return true;
      }
      
      public function removeTarget(param1:b2Body) : Boolean
      {
         var _loc2_:int = -1;
         var _loc3_:int = 0;
         while(_loc3_ < this.targets.length)
         {
            if(this.targets[_loc3_].body == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         if(_loc2_ == -1)
         {
            return false;
         }
         var _loc4_:userData = userData(param1.GetUserData());
         var _loc5_:Sprite = _loc4_.graphic;
         _loc5_.removeChild(_loc5_.getChildByName("targetIcon"));
         _loc4_.targetX = -1;
         _loc4_.targetY = -1;
         userData(this.targets[_loc2_].body.GetUserData()).target = -1;
         this.targets.splice(_loc2_,1);
         return true;
      }
      
      public function removeArea(param1:b2Vec2) : Boolean
      {
         var _loc4_:ContractArea = null;
         var _loc2_:int = -1;
         var _loc3_:Boolean = false;
         param1.x -= Main.instance.m_sprite.x;
         param1.y -= Main.instance.m_sprite.y;
         for each(_loc4_ in this.targetAreas)
         {
            _loc2_++;
            if(_loc4_.contains(param1.x,param1.y))
            {
               _loc3_ = true;
               break;
            }
         }
         if(_loc3_)
         {
            this.targetAreas.splice(_loc2_,1);
            this.updateAreas();
            return true;
         }
         return false;
      }
      
      public function addArea(param1:b2Vec2, param2:Number, param3:Number) : ContractArea
      {
         if(param2 < 0)
         {
            param1.x += param2;
            param2 *= -1;
         }
         if(param3 < 0)
         {
            param1.y += param3;
            param3 *= -1;
         }
         var _loc4_:ContractArea = new ContractArea(param1.x,param1.y,Math.round(param2),Math.round(param3));
         _loc4_.SetPermissions(this.areaSpawn,this.areaDrag,this.areaTrigger,this.areaCut,this.areaDestroy,this.areaPower,this.areaOther);
         this.ResetPermissions();
         this.targetAreas.push(_loc4_);
         this.updateAreas();
         return _loc4_;
      }
      
      public function ResetPermissions() : void
      {
         this.areaSpawn = false;
         this.areaDrag = false;
         this.areaTrigger = false;
         this.areaCut = false;
         this.areaDestroy = false;
         this.areaOther = false;
         this.areaPower = false;
      }
      
      private function updateAreas() : void
      {
         var _loc1_:ContractArea = null;
         var _loc2_:Vector.<Boolean> = null;
         var _loc3_:Bitmap = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         graphics.clear();
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         for each(_loc1_ in this.targetAreas)
         {
            graphics.lineStyle(1,3355443,0.3);
            graphics.beginFill(15658734,0.1);
            graphics.drawRect(_loc1_.x,_loc1_.y,_loc1_.width,_loc1_.height);
            _loc2_ = _loc1_.GetPermissions();
            _loc5_ = ["iconspawn","tool_drag","tool_trigger","tool_cut","tool_delete","tool_relocate","iconpowers"];
            _loc6_ = 4;
            _loc7_ = 0;
            while(_loc7_ < _loc2_.length)
            {
               if(_loc2_[_loc7_])
               {
                  _loc4_ = _loc5_[_loc7_];
                  _loc3_ = new Bitmap(R.getSprite(_loc4_));
                  _loc3_.x = _loc1_.x + _loc6_;
                  _loc3_.y = _loc1_.y + 4;
                  addChild(_loc3_);
                  graphics.lineStyle();
                  graphics.beginFill(3355443,0.2);
                  graphics.drawRect(_loc3_.x,_loc3_.y,32,32);
                  _loc6_ += 32;
               }
               _loc7_++;
            }
         }
      }
      
      public function selectItem(param1:b2Vec2) : String
      {
         var _loc2_:String = null;
         var _loc6_:b2Vec2 = null;
         var _loc7_:Number = NaN;
         var _loc3_:int = -1;
         var _loc4_:int = 3000;
         var _loc5_:int = 0;
         for each(_loc6_ in this.itemPos)
         {
            _loc7_ = BoxUtils.vectorDist(_loc6_,param1);
            if(_loc7_ < _loc4_)
            {
               _loc3_ = _loc5_;
               _loc4_ = _loc7_;
            }
            _loc5_++;
         }
         if(_loc3_ != -1)
         {
            _loc2_ = this.items[_loc3_];
            this.spawnItem = _loc2_;
            this.spawnPos = this.itemPos[_loc3_];
            this.items.splice(_loc3_,1);
            this.itemPos.splice(_loc3_,1);
         }
         this.updateItems();
         return _loc2_;
      }
      
      private function previewDisabled() : void
      {
         this.items = this.previewItems.slice();
         this.itemPos = this.previewPos.slice();
         this.updateItems();
      }
      
      private function previewEnabled() : void
      {
         this.previewItems = this.items.slice();
         this.previewPos = this.itemPos.slice();
      }
      
      public function restoreSpawnItem() : void
      {
         if(!this.spawnItem || !this.spawnPos)
         {
            return;
         }
         this.items.push(this.spawnItem);
         this.itemPos.push(this.spawnPos);
         this.spawnItem = null;
         this.spawnPos = null;
         this.updateItems();
      }
      
      public function checkTargets(param1:Event) : *
      {
         var _loc3_:ContractTarget = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:b2Body = null;
         var _loc7_:userData = null;
         var _loc8_:Boolean = false;
         var _loc9_:b2Vec2 = null;
         var _loc10_:b2Vec2 = null;
         if(!this.enabled)
         {
            return;
         }
         var _loc2_:int = 0;
         for each(_loc3_ in this.targets)
         {
            _loc6_ = _loc3_.body;
            _loc7_ = userData(_loc6_.GetUserData());
            _loc8_ = false;
            if(_loc3_.type == 1)
            {
               if(_loc7_.dead || _loc7_.hasBeenCut || _loc7_.health <= 10)
               {
                  _loc8_ = true;
               }
            }
            else if(_loc3_.type == 2)
            {
               if(_loc7_.health < _loc7_.maxhealth * 0.4)
               {
                  _loc8_ = true;
               }
            }
            else if(_loc3_.type == 3)
            {
               if(_loc7_.dead || _loc7_.hasBeenCut || _loc7_.health <= 10)
               {
                  dispatchEvent(new Event("RIP"));
                  this.removeTarget(_loc6_);
                  return;
               }
            }
            else if(_loc3_.type == 4)
            {
               if(!_loc7_.targetX)
               {
                  this.removeTarget(_loc6_);
                  return;
               }
               _loc9_ = new b2Vec2(_loc6_.GetPosition().x * Physics.scale,_loc6_.GetPosition().y * Physics.scale);
               _loc10_ = new b2Vec2(_loc7_.targetX,_loc7_.targetY);
               if(BoxUtils.vectorDist(_loc9_,_loc10_) < 900)
               {
                  _loc8_ = true;
               }
            }
            else if(_loc3_.type == 5)
            {
               if(_loc7_.triggered)
               {
                  _loc8_ = true;
               }
            }
            else if(_loc3_.type == 6)
            {
               if(_loc7_.health >= _loc7_.maxhealth * 0.9)
               {
                  _loc8_ = true;
               }
            }
            else if(_loc3_.type == 7)
            {
               if(_loc7_.burning)
               {
                  _loc8_ = true;
               }
            }
            if(_loc8_)
            {
               dispatchEvent(new Event("DED"));
               this.removeTarget(_loc6_);
               break;
            }
            _loc2_++;
         }
         _loc4_ = 0;
         _loc5_ = 0;
         while(_loc5_ < this.targets.length)
         {
            if(this.targets[_loc5_].type != 3)
            {
               _loc4_++;
            }
            _loc5_++;
         }
         if(_loc4_ == 0)
         {
            dispatchEvent(new Event("COMPLETE"));
            this.timer.stop();
         }
      }
      
      public function allowSpawn(param1:b2Vec2) : Boolean
      {
         var _loc3_:ContractArea = null;
         if(!this.enabled)
         {
            return true;
         }
         if(this.targetAreas.length == 0)
         {
            return true;
         }
         var _loc2_:Boolean = false;
         param1.x -= Main.instance.m_sprite.x;
         param1.y -= Main.instance.m_sprite.y;
         for each(_loc3_ in this.targetAreas)
         {
            if(_loc3_.spawning)
            {
               if(_loc3_.contains(param1.x,param1.y))
               {
                  _loc2_ = true;
               }
            }
         }
         return _loc2_;
      }
      
      public function allowDragging(param1:b2Vec2) : Boolean
      {
         var _loc3_:ContractArea = null;
         if(!this.enabled)
         {
            return true;
         }
         if(this.targetAreas.length == 0)
         {
            return true;
         }
         var _loc2_:Boolean = false;
         param1.x -= Main.instance.m_sprite.x;
         param1.y -= Main.instance.m_sprite.y;
         for each(_loc3_ in this.targetAreas)
         {
            if(_loc3_.dragging)
            {
               if(_loc3_.contains(param1.x,param1.y))
               {
                  _loc2_ = true;
               }
            }
         }
         return _loc2_;
      }
      
      public function allowTriggering(param1:b2Vec2) : Boolean
      {
         var _loc3_:ContractArea = null;
         if(!this.enabled)
         {
            return true;
         }
         if(this.targetAreas.length == 0)
         {
            return true;
         }
         var _loc2_:Boolean = false;
         param1.x -= Main.instance.m_sprite.x;
         param1.y -= Main.instance.m_sprite.y;
         for each(_loc3_ in this.targetAreas)
         {
            if(_loc3_.triggering)
            {
               if(_loc3_.contains(param1.x,param1.y))
               {
                  _loc2_ = true;
               }
            }
         }
         return _loc2_;
      }
      
      public function allowDestroy(param1:b2Vec2) : Boolean
      {
         var _loc3_:ContractArea = null;
         if(!this.enabled)
         {
            return true;
         }
         if(this.targetAreas.length == 0)
         {
            return true;
         }
         var _loc2_:Boolean = false;
         param1.x -= Main.instance.m_sprite.x;
         param1.y -= Main.instance.m_sprite.y;
         for each(_loc3_ in this.targetAreas)
         {
            if(_loc3_.deleting)
            {
               if(_loc3_.contains(param1.x,param1.y))
               {
                  _loc2_ = true;
               }
            }
         }
         return _loc2_;
      }
      
      public function allowCut(param1:b2Vec2) : Boolean
      {
         var _loc3_:ContractArea = null;
         if(!this.enabled)
         {
            return true;
         }
         if(this.targetAreas.length == 0)
         {
            return true;
         }
         var _loc2_:Boolean = false;
         param1.x -= Main.instance.m_sprite.x;
         param1.y -= Main.instance.m_sprite.y;
         for each(_loc3_ in this.targetAreas)
         {
            if(_loc3_.cutting)
            {
               if(_loc3_.contains(param1.x,param1.y))
               {
                  _loc2_ = true;
               }
            }
         }
         return _loc2_;
      }
      
      public function allowPower(param1:b2Vec2) : Boolean
      {
         var _loc3_:ContractArea = null;
         if(!this.enabled)
         {
            return true;
         }
         if(this.targetAreas.length == 0)
         {
            return true;
         }
         var _loc2_:Boolean = false;
         param1.x -= Main.instance.m_sprite.x;
         param1.y -= Main.instance.m_sprite.y;
         for each(_loc3_ in this.targetAreas)
         {
            if(_loc3_.power)
            {
               if(_loc3_.contains(param1.x,param1.y))
               {
                  _loc2_ = true;
               }
            }
         }
         return _loc2_;
      }
      
      public function Reset() : void
      {
         var _loc1_:ContractTarget = null;
         for each(_loc1_ in this.targets)
         {
            this.removeTarget(_loc1_.body);
         }
         this.targetAreas = new Vector.<ContractArea>();
         this.items = new Vector.<String>();
         this.itemPos = new Vector.<b2Vec2>();
         this.targets = new Vector.<ContractTarget>();
         this.itemholder.graphics.clear();
         this.itemholder.graphics.beginFill(16711680,0);
         this.itemholder.graphics.drawRect(0,0,200 - Window.BUFFER * 2,200 - Window.BUFFER * 2);
         this.itemholder.name = "holder";
         this.itemholder.mouseChildren = false;
         this.ResetPermissions();
         this.updateAreas();
         this.updateItems();
         this._enabled = false;
         if(this.timer)
         {
            this.timer.stop();
         }
      }
      
      public function get areas() : Vector.<ContractArea>
      {
         return this.targetAreas;
      }
      
      public function get areaCount() : int
      {
         if(!this.targetAreas)
         {
            return 0;
         }
         return this.targetAreas.length;
      }
      
      public function get targetCount() : int
      {
         if(!this.targets)
         {
            return 0;
         }
         return this.targets.length;
      }
      
      public function get itemCount() : int
      {
         if(!this.items)
         {
            return 0;
         }
         return this.items.length;
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         this._enabled = param1;
         if(this.enabled)
         {
            this.previewEnabled();
         }
         else
         {
            this.previewDisabled();
         }
      }
   }
}

