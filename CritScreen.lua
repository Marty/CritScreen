local screentime = 0;

function CritScreen_OnLoad() 
	this:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	this:RegisterEvent("ADDON_LOADED");
	 
	SlashCmdList["CS"] = CritScreen_OnCommand;
	SLASH_CS1 = "/cs";
	SLASH_CS2 = "/critscreen";
end

function CritScreen_OnEvent() 
	if (event=="ADDON_LOADED" and arg1=="CritScreen") then
		if (status==NIL or status=="none") then status="off"; end
		if (minvalue==NIL) then minvalue=2000; end
		if (status=="off") then ChatFrame1:AddMessage("|cff33ffffCritScreen|r loaded. Status: |c00ff0000off|r"); end
		if (status=="on") then ChatFrame1:AddMessage("|cff33ffffCritScreen|r loaded. Status: |c0000ff00on|r"); end
	end

	if (time() == screentime+1 and status=="on") then
		Screenshot();
		screentime=0;
	end
	
	if (event=="COMBAT_LOG_EVENT_UNFILTERED") then
		local Type = arg2;
		local SourceName = arg4;
		local CurrentPlayer = UnitName("player");
		
		if (SourceName == CurrentPlayer) then
			if (Type == "SPELL_DAMAGE") then
				critical = arg17;
				amount = arg12;
			elseif (Type == "RANGE_DAMAGE") then
				critical = arg18;
				amount = arg12;
			elseif (Type == "SWING_l") then
				critical = arg14;
				amount = arg9;
			elseif (Type == "SWING_DAMAGE") then
				critical = arg14;
				amount = arg9;
			end
			if (critical ~= Nil and amount >= tonumber(minvalue)) then
				screentime = tonumber(time());		
				--ChatFrame1:AddMessage("|c00ff0000IT'S OVER "..minvalue.." !!!|r");
				critical = NIL;		
			end
		end
	end
end 

function CritScreen_OnCommand(input)
	command, value = strsplit(" ", input);
	
	if (command=="on" and status=="off") then
		status = "on";
		ChatFrame1:AddMessage("|cff33ffffCritScreen|r is now |c0000ff00on|r");
	elseif (command=="off" and status=="on") then
		status = "off";
		ChatFrame1:AddMessage("|cff33ffffCritScreen|r is now |c00ff0000off|r");
	elseif (command=="min") then
		if (value==NIL) then ChatFrame1:AddMessage("Please enter the minimum value to capture.");
		else 
			ChatFrame1:AddMessage("Minimum value set to: "..value); 
			minvalue = value;
		end
	else
		ChatFrame1:AddMessage("|cff33ffffCritScreen|r info:");
		ChatFrame1:AddMessage("|cff33ffff>|r CS is "..status.." (/cs [on|off])");
		ChatFrame1:AddMessage("|cff33ffff>|r Minimum value is "..minvalue.." (/cs min <value>)");
	end
end