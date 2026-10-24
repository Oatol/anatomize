package powers
{
   import Box2D.Common.Math.b2Vec2;
   import com.yahoo.astra.fl.controls.treeClasses.TreeDataProvider;
   import mx.utils.StringUtil;
   
   public class PowerCrash extends Power
   {
      
      private var menuPrompt:Window;
      
      private var newname:String;
      
      private var buttonPos:b2Vec2;
      
      internal var counter:Number = 0;
      
      internal var xml_reboot:XML = <node label="Root Node">
			<node label="" func="spacer" center="true" noReadabilityTint="true"/>
			<node label="Restart" func="crashPower" center="true" noReadabilityTint="true"/>
		</node>;
      
      internal var xml_rebootLeft:XML = <node label="Root Node">
			<node label="" func="spacer" center="true" noReadabilityTint="true"/>
			<node label="Restart" func="crashPower" noReadabilityTint="true"/>
		</node>;
      
      internal var xml_rebootIcon:XML = <node label="Root Node">
			<node label="" func="spacer" center="true" noReadabilityTint="true"/>
			<node label="Restart" func="crashPower" ico="icon_restart" center="true" noReadabilityTint="true"/>
		</node>;
      
      internal var xml_rebootSkin:XML = <node label="Root Node">
			<node label="" func="spacer" center="true" noReadabilityTint="true"/>
			<node label="Restart" func="crashPower" center="true" noReadabilityTint="true" background="#27E833"/>
		</node>;
      
      internal var xml_rebootTop:XML = <node label="Root Node">
			<node label="Restart" func="crashPower" center="true" noReadabilityTint="true"/>
			<node label="" func="spacer" center="true" noReadabilityTint="true"/>
		</node>;
      
      internal var xml_reboot2:XML = <node label="Root Node">
			<node label="Restart" func="crashPowerYes" center="true" noReadabilityTint="true"/>
			<node label="Restart" func="crashPowerNo" center="true" noReadabilityTint="true"/>
		</node>;
      
      internal var xml_yesno:XML = <node label="Root Node">
			<node label="Yes" func="crashPowerYes" center="true" noReadabilityTint="true"/>
			<node label="No" func="crashPowerNo" center="true" noReadabilityTint="true"/>
		</node>;
      
      internal var xml_unlock:XML = <node label="Root Node">
			<node label="Allow " func="crashPowerYes" center="true" noReadabilityTint="true"/>
			<node label="Deny" func="crashPowerNo" center="true" noReadabilityTint="true"/>
		</node>;
      
      public function PowerCrash()
      {
         super(Tool.CRASH);
         this.menuPrompt = GameState.menuHandler.getMenu("Prompt");
         noThrow = true;
         noPressRadius = true;
         this.start();
      }
      
      internal function start() : void
      {
         this.menuPrompt.title = "";
         this.menuPrompt.getField("info").text = "The game has crashed.\n\nYou will now be guided through the restart process.\n\nWould you kindly press the Restart button.";
         this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_reboot);
         this.menuPrompt.visible = true;
         this.menuPrompt.open();
         this.menuPrompt.unlock();
         this.menuPrompt.moveToTop();
         this.menuPrompt.center();
         this.menuPrompt.lock();
         this.counter = 0;
         TimeLord.pause();
      }
      
      override public function Press(param1:b2Vec2, param2:b2Vec2) : void
      {
      }
      
      public function Yes() : void
      {
         var _loc1_:String = null;
         switch(this.counter)
         {
            case 9:
               _loc1_ = "Great!\n\nYou can call me A Menu. Nice to meet you.\n\n\nI suppose we should get on with restarting the game then, eh?";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_reboot);
               break;
            case 10:
               _loc1_ = "Well, go on then. I can\'t wait!\n\n";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_name());
               break;
            case 11:
               _loc1_ = "That\'s nice!\n\nSounds almost randomly generated, but hey, I\'ll take it!\n\n\nI suppose we should get on with restarting the game then, eh?";
               this.menuPrompt.title = this.newname;
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_reboot);
               break;
            case 16:
               _loc1_ = "That one not working either?\n\nBack to square one.";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_reboot);
               break;
            case 18:
               _loc1_ = "Good job.\n\nMaybe the button is working now?";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_reboot);
               break;
            case 20:
               _loc1_ = "Great!\n\nI\'m over here now.\n\nIs it working now?\n\nI figured a change of scenery might make the button change its stubborn mind.";
               this.menuPrompt.x += Math.random() * 400 - 200;
               this.menuPrompt.y += Math.random() * 200 - 100;
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_reboot);
               break;
            case 33:
               _loc1_ = "A splash of colour!\n\nMuch better!\n\nMaybe making the button a pleasant traffic light green will make it go ahead and work already.";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_rebootSkin);
               break;
            case 38:
               _loc1_ = "I\'ll take your word for it.\n\nCan you think of anything else?";
               break;
            case 39:
               _loc1_ = "Well?!\n\nWhat is it?\n\nWould it work?";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_yesno);
               break;
            case 40:
               _loc1_ = "That\'s great!\n\nDo it!";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_reboot);
         }
         ++this.counter;
         if(_loc1_)
         {
            this.setText(_loc1_);
         }
      }
      
      public function No() : void
      {
         var _loc1_:String = null;
         switch(this.counter)
         {
            case 9:
               _loc1_ = "Thought so.\n\nCan you think of anything better?";
               break;
            case 10:
               _loc1_ = "I like it!\n\nFrom now on, I\'ll be called \"No.\"\n\nWhat a great suggestion.\n\nNice to meet you.\n\nI suppose we should get on with restarting the game then, eh?";
               this.menuPrompt.title = "No";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_reboot);
               break;
            case 11:
               _loc1_ = "Sure thing!\n\nI like it now too.\n\n\nI suppose we should get on with restarting the game then, eh?";
               this.menuPrompt.title = "A Menu.";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_reboot);
               break;
            case 16:
               _loc1_ = "I think you pressed the same button again.\n\nTry the other one.";
               --this.counter;
               break;
            case 18:
               _loc1_ = this.encourage() + "\n\nGot it now?";
               --this.counter;
               break;
            case 20:
               _loc1_ = "Very well.\nI\'ll just stay here, then.\n\nIt probably wouldn\'t have worked in any case.\n\nTry the button again, then.";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_reboot);
               break;
            case 33:
               _loc1_ = "Let\'s stick to the grey, then.\n\nJust hit it again then.";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_reboot);
               break;
            case 38:
               _loc1_ = "Well, at least you\'re honest.\n\nIt was probably a long shot to begin with.\n\nCan you think of anything else?";
               break;
            case 39:
               _loc1_ = "Shame.\n\nWell here\'s the button again, just in case.";
               ++this.counter;
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_reboot);
               break;
            case 40:
               _loc1_ = "Shame.\n\nWell here\'s the button again, just in case.";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_reboot);
         }
         ++this.counter;
         if(_loc1_)
         {
            this.setText(_loc1_);
         }
      }
      
      private function xml_customReboot(param1:String) : XML
      {
         var _loc2_:XML = <node label="Root Node">
				<node label="" func="spacer" center="true" noReadabilityTint="true"/>
			</node>;
         var _loc3_:XML = <node/>;
         _loc3_.@func = "crashPower";
         _loc3_.@label = param1;
         _loc3_.@center = "true";
         _loc3_.@noReadabilityTint = "true";
         _loc2_.appendChild(_loc3_);
         return _loc2_;
      }
      
      private function xml_name() : XML
      {
         var _loc1_:XML = <node label="Root Node"></node>;
         var _loc2_:XML = <node/>;
         _loc2_.@func = "crashPowerYes";
         this.newname = GeneralUtils.objectToName(O.names[int(Math.random() * O.names.length)]);
         _loc2_.@label = "\"" + this.newname + "\"";
         _loc2_.@center = "true";
         _loc2_.@noReadabilityTint = "true";
         _loc1_.appendChild(_loc2_);
         _loc2_ = <node/>;
         _loc2_.@func = "crashPowerNo";
         _loc2_.@label = "Maybe \"A Menu.\" is fine after all.";
         _loc2_.@center = "true";
         _loc2_.@noReadabilityTint = "true";
         _loc1_.appendChild(_loc2_);
         return _loc1_;
      }
      
      public function Crash() : void
      {
         var _loc1_:String = null;
         if(this.counter < 7)
         {
            _loc1_ = "\n" + StringUtil.repeat("...\n",this.counter) + this.capitalize(this.totally()) + " " + this.unexpected() + ".";
            if(this.counter > 0)
            {
               _loc1_ = "\n" + _loc1_;
            }
         }
         if(this.counter > 21 && this.counter < 31)
         {
            _loc1_ = StringUtil.repeat(StringUtil.repeat(String(this.counter - 21),21) + "\n",10);
         }
         if(this.counter > 45 && this.counter < 55)
         {
            _loc1_ = "Uh oh." + StringUtil.repeat(".",this.counter - 45);
            this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_customReboot(String(55 - this.counter)));
         }
         if(this.counter > 57 && this.counter < 66)
         {
            this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_customReboot("CAN\'T CATCH ME!" + StringUtil.repeat("!",Math.random() * 10)));
            this.menuPrompt.getTree("buttons").x = -200 + Math.random() * 500;
            this.menuPrompt.getTree("buttons").y = -200 + Math.random() * 400;
         }
         switch(this.counter)
         {
            case 0:
               _loc1_ = "I mean, who would\'ve thought clicking on something that says \"Crash\" would actually crash the game." + _loc1_;
               break;
            case 6:
               _loc1_ += "\n\n...Although...";
               break;
            case 7:
               _loc1_ = "At least the Restart button is here to keep us entertained.\n\nAnd by us, I mean you. I\'m just a menu.";
               this.menuPrompt.title = "A Menu.";
               break;
            case 8:
               _loc1_ = "Oh, hey-oh. That\'s pretty cool.\n\nIt says I\'m \"A Menu.\" at the top now.\nRight after I said I was.\n\nI\'m not sure if I like it, though.\n\nDo you?";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_yesno);
               break;
            case 11:
               _loc1_ = "Simply, press the button to restart the game and recover from this nasty crash.\n\nShould be simple enough.";
               break;
            case 12:
               _loc1_ = "Did you press the button? Try it again.";
               break;
            case 13:
               _loc1_ = "Maybe you missed it. Once more.";
               break;
            case 14:
               _loc1_ = "Try really putting some effort into it.\n\nDon\'t just click the button,\nreally *CLICK* it.";
               break;
            case 15:
               _loc1_ = "Well this really isn\'t working.\n\nLet\'s try something else.\n\nPress the other Restart button instead.";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_reboot2);
               break;
            case 17:
               _loc1_ = "Shall we play a game while the button refuses to work?\n\nI\'m thinking of a number between " + this.numbergame() + ".\n\nGot it?";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_yesno);
               break;
            case 19:
               _loc1_ = "Still nothing?\n\nLet\'s try something different.\n\nGive me the permission to move, I promise I won\'t run away.\n\n\n\n[Allow \'" + this.menuPrompt.title + "\' to access *Position*?]";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_unlock);
               break;
            case 21:
               _loc1_ = "No deal?\n\nWelllllll...\n\nMaybe if you hit the button TEN TIMES as fast as you can?";
               this.menuPrompt.unlock();
               this.menuPrompt.moveToTop();
               this.menuPrompt.center();
               this.menuPrompt.lock();
               break;
            case 31:
               _loc1_ = "Whoa there!\n\nI moved the button so you wouldn\'t accidentally shoot past the ten click mark.\n\nThat could\'ve been a catastrophy!\n\nMaybe the moved button will work though?";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_rebootTop);
               break;
            case 32:
               _loc1_ = "There has got to be something we can do.\n\nMaybe if the button looked a bit less grey!\n\nGive me the permission to spice it up! Might as well try everything at this point, right?\n\n[Allow \'" + this.menuPrompt.title + "\' to access *Skin*?]";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_unlock);
               break;
            case 34:
               _loc1_ = "Well, that was a complete waste of time.\n\n\nI\'ve gone ahead and left aligned the button.\n\nMaybe this way at the very least the left side of the game will restart.\n\nBetter than nothing, right?";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_rebootLeft);
               break;
            case 35:
               _loc1_ = "Nope.\n\nMaybe a nice icon?";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_rebootIcon);
               break;
            case 36:
               _loc1_ = "Still nope.\n\nI\'m out of ideas.\n\nYour turn.\n\nGet on your knees, and beg the button to work.";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_reboot);
               break;
            case 37:
               _loc1_ = "Nothing!\n\nDid you actually do it, though?\n\nI can\'t see you the way you can see me, you know.";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_yesno);
               break;
            case 41:
               _loc1_ = "Nope.\n\nThe button is still refusing to cooperate.\n\nMaybe we can fool it.\n\nTry this one...";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_customReboot("Don\'t Not Restart"));
               break;
            case 42:
               _loc1_ = "How about...";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_customReboot("Duuuh! I\'m a dumb button look at me!"));
               break;
            case 43:
               _loc1_ = "Uhhh...\n\nI think teasing the button wasn\'t the greatest idea...\n\nI\'ve just lost control of it.";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_customReboot("I AM THE MIGHTY BUTTON!"));
               break;
            case 44:
               _loc1_ = "It has a bit of an ego, eh?";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_customReboot("HOW DARE *YOU* CLICK ME, THE MIGHTY BUTTON!?"));
               break;
            case 45:
               _loc1_ = "You\'re a... what?\n\nMaybe you should stop pressing it.";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_customReboot("CEASE THE PRESSING! NASTY MOUSE-WIELDER!"));
               break;
            case 55:
               _loc1_ = "...Oh.\n\n\n\nI guess the button doesn\'t have any permissions.\n\n";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_customReboot("BOOM! EXPLOSION! YOU ARE DEAD!"));
               break;
            case 56:
               _loc1_ = "It seems you\'ve hit a wall.\n\nLet me give it a shot.\n\nHey button, you\'re ruining the UX of this UI!";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_customReboot("I REFUSE TO SPEAK TO DEAD PEOPLE!"));
               break;
            case 56:
               _loc1_ = "Well, I tried.";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_customReboot("I ALSO REFUSE TO SPEAK TO TEXT FIELDS!"));
               break;
            case 57:
               _loc1_ = "Uhhh.\n\nThe button just gave itself permission to change its position.\n\nThat\'s definitely not supposed to happen.\n\nI think I saw it sneak somewhere below me.";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_customReboot("IN FACT, I REFUSE TO BE A PART OF THAT MENU!"));
               this.buttonPos = new b2Vec2(this.menuPrompt.getTree("buttons").x,this.menuPrompt.getTree("buttons").y);
               this.menuPrompt.getTree("buttons").y = this.menuPrompt.getTree("buttons").y + 100;
               break;
            case 58:
               _loc1_ = "Off you go, then.\n\nGo play some tag.";
               break;
            case 65:
               _loc1_ = "Seems you managed to wear down the button.\n\nI\'ve regained control of it.";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_customReboot("Restart"));
               this.menuPrompt.getTree("buttons").x = this.buttonPos.x;
               this.menuPrompt.getTree("buttons").y = this.buttonPos.y;
               break;
            case 66:
               _loc1_ = "It seems to be working, finally.\n\nIt\'s been a pleasure.\n\nEnjoy the game.";
               this.menuPrompt.getTree("buttons").dataProvider = new TreeDataProvider(this.xml_customReboot("Close Restart Menu"));
               break;
            case 67:
               Tool.drag();
               this.menuPrompt.close();
               TimeLord.unpause();
               this.counter = 0;
         }
         if(_loc1_)
         {
            this.setText(_loc1_);
         }
         ++this.counter;
      }
      
      private function numbergame() : String
      {
         var _loc1_:Number = int(Math.random() * 100);
         return _loc1_.toString() + " and " + String(_loc1_ + 2);
      }
      
      private function encourage() : String
      {
         var _loc1_:Array = ["You can do it!","Keep trying.","How about now?","Keep at it.","Generic encouraging quote!\n\n\n\nI mean, do your best."];
         return _loc1_[int(Math.random() * _loc1_.length)];
      }
      
      private function unexpected() : String
      {
         var _loc1_:Array = ["unexpected","unforeseen","unpredictable","stunning","staggering","unanticipated"];
         return _loc1_[int(Math.random() * _loc1_.length)];
      }
      
      private function totally() : String
      {
         var _loc1_:Array = ["totally","completely","utterly","completely","thoroughly","entirely","altogether","all in all"];
         return _loc1_[int(Math.random() * _loc1_.length)];
      }
      
      internal function capitalize(param1:String) : String
      {
         var _loc2_:String = param1.substr(0,1);
         var _loc3_:String = param1.substr(1,param1.length);
         return _loc2_.toUpperCase() + _loc3_.toLowerCase();
      }
      
      private function setText(param1:String) : void
      {
         this.menuPrompt.getField("info").text = param1;
      }
   }
}

