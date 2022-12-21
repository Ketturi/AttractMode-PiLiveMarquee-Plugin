// Attract-Mode Frontend - PiLiveMarquee plugin

class UserConfig </ help="Plugin to command external RPi display for showing arcade artwork" /> {
	</ label="Command", help="Path to the curl executable", order=1 />
	command="curl";

	</ label="Address", help="Network address of the PiLiveMarquee", order=1 />
	ServiceURL="http://livemarquee:8080/";
	
	</ label="Show in AM", help="Action when selection changes", order=2, options="Default artwork, Game artwork" />
	selectionAction="Default artwork";

	</ label="On startup", help="Image to show on startup", order=3 />
	welcome="default";

	</ label="On exit", help="Image to show on exit", order=4 />
	goodbye="startimage";
}

class PiLiveMarquee{
	config = null;

	constructor() {
		config = fe.get_config(); // get the plugin settings configured by the user
		fe.add_transition_callback(this, "transitions");
	}
	
	function transitions( ttype, var, ttime ) {
		if ( ScreenSaverActive )
			return false;

		switch ( ttype ){	
		case Transition.ToNewSelection:
			local emulator_str = fe.game_info(Info.Emulator, var);
			local rom_name = fe.game_info(Info.Name, var);
			if (config["selectionAction"] == "Default artwork" ){		
				rom_name = "default";		
			}
			local cmd_args = "\"" + config["ServiceURL"];
			cmd_args +=  "marquee" + "/";
			cmd_args += emulator_str + "/";
			cmd_args += rom_name  + "\"";
			print(cmd_args + "\n")
			fe.plugin_command_bg( config["command"], cmd_args);
			break;
			
		case Transition.ToGame:
			local emulator_str = fe.game_info(Info.Emulator, var);
			local rom_name = fe.game_info(Info.Name, var);
			
			local cmd_args = "\"" + config["ServiceURL"];
			cmd_args +=  "marquee" + "/";
			cmd_args += emulator_str + "/";
			cmd_args += rom_name  + "\"";
			print(cmd_args + "\n")
			fe.plugin_command_bg( config["command"], cmd_args);

			break;

		case Transition.FromGame:
			local emulator_str = fe.game_info(Info.Emulator, var);
			local rom_name = fe.game_info(Info.Name, var);
			
			if (config["selectionAction"] == "Default-artwork" ){		
				rom_name = "default";		
			}
			
			local cmd_args = "\"" + config["ServiceURL"];
			cmd_args +=  "marquee" + "/";
			cmd_args += emulator_str + "/";
			cmd_args += rom_name  + "\"";
			print(cmd_args + "\n")
			fe.plugin_command_bg( config["command"], cmd_args);
			break;
			
		case Transition.StartLayout:
			if (( var == FromTo.Frontend ) && ( config["welcome"].len() > 0 )){		
				local emulator_str = "AMUI";
				local rom_name = config["welcome"];
				
				local cmd_args = "\"" + config["ServiceURL"];
				cmd_args +=  "marquee" + "/";
				cmd_args += emulator_str + "/";
				cmd_args += rom_name  + "\"";
				print(cmd_args + "\n")
				fe.plugin_command_bg( config["command"], cmd_args);
			}
			break;

		case Transition.EndLayout:
			if (( var == FromTo.Frontend ) && ( config["goodbye"].len() > 0 )){		
				local emulator_str = "AMUI";
				local rom_name = config["goodbye"];
				
				local cmd_args = "\"" + config["ServiceURL"];
				cmd_args +=  "marquee" + "/";
				cmd_args += emulator_str + "/";
				cmd_args += rom_name  + "\"";
				print(cmd_args + "\n")
				fe.plugin_command_bg( config["command"], cmd_args);
			}
			break;
		}
	return false; // must return false
	}
}
fe.plugin["PiLiveMarquee"] <- PiLiveMarquee();