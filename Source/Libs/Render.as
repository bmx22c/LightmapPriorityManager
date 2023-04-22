namespace RenderLib
{
	bool InMapEditor() {
		CGameCtnEditorFree@ editor = cast<CGameCtnEditorFree>(GetApp().Editor);
		CGameCtnChallenge@ map = cast<CGameCtnChallenge>(GetApp().RootMap);

		if (map !is null && editor !is null) {
			return true;
		}
		return false;
	}

	void LoadingButton() {
		if (Time::get_Now() % 3000 > 2000) {
				UI::Button("Loading...");
		} else if (Time::get_Now() % 3000 > 1000) {
				UI::Button("Loading.. ");
		} else {
				UI::Button("Loading.  ");
		}
		if (UI::IsItemHovered()) infotext = "Parsing all blocks and items to generate the table. Please wait...";
	}

	void GenerateRow(Objects@ object) {
		UI::TableNextRow();
		UI::TableNextColumn();
		if(Setting_EnableCameraFocus){
			if (UI::Button(Icons::Search + "###" + object.name)) {
				FocusCam(object.name);
			}
			UI::SameLine();
		}

		if(((Setting_LMChangeButtonWhenFinishScanning && finishedScanning) || !Setting_LMChangeButtonWhenFinishScanning) && Setting_LMFoundIndicate && object.isLMUnknown == false && object.selectedLM == -3){
			UI::PushStyleColor(UI::Col::Button, Setting_LMFoundColor);
			UI::PushStyleColor(UI::Col::ButtonHovered, Setting_LMFoundColor-vec4(.1,.1,.1,0));
		}
		if (UI::Button("-3" + "###" + object.name+1)) {
			LightMap lm;
			@lm.obj = object;
			lm.objectName = object.name;
			lm.lmLvlI = CGameCtnAnchoredObject::EMapElemLightmapQuality::Lowest;
			lm.lmLvlB = CGameCtnBlock::EMapElemLightmapQuality::Lowest;
			if(object.name.ToLower().Contains(".item.gbx")){
				startnew(CoroutineFunc(lm.ApplyItem));
			}else if(object.name.ToLower().Contains(".block.gbx")){
				startnew(CoroutineFunc(lm.ApplyBlock));
			}else{
				startnew(CoroutineFunc(lm.ApplyOther));
			}
		}
		if(((Setting_LMChangeButtonWhenFinishScanning && finishedScanning) || !Setting_LMChangeButtonWhenFinishScanning) && Setting_LMFoundIndicate  && object.isLMUnknown == false && object.selectedLM == -3) UI::PopStyleColor(2);
		UI::SameLine();
		if(((Setting_LMChangeButtonWhenFinishScanning && finishedScanning) || !Setting_LMChangeButtonWhenFinishScanning) && Setting_LMFoundIndicate && object.isLMUnknown == false && object.selectedLM == -2){
			UI::PushStyleColor(UI::Col::Button, Setting_LMFoundColor);
			UI::PushStyleColor(UI::Col::ButtonHovered, Setting_LMFoundColor-vec4(.1,.1,.1,0));
		}
		if (UI::Button("-2" + "###" + object.name+2)) {
			LightMap lm;
			@lm.obj = object;
			lm.objectName = object.name;
			lm.lmLvlI = CGameCtnAnchoredObject::EMapElemLightmapQuality::VeryLow;
			lm.lmLvlB = CGameCtnBlock::EMapElemLightmapQuality::VeryLow;
			if(object.name.ToLower().Contains(".item.gbx")){
				startnew(CoroutineFunc(lm.ApplyItem));
			}else if(object.name.ToLower().Contains(".block.gbx")){
				startnew(CoroutineFunc(lm.ApplyBlock));
			}else{
				startnew(CoroutineFunc(lm.ApplyOther));
			}
		}
		if(((Setting_LMChangeButtonWhenFinishScanning && finishedScanning) || !Setting_LMChangeButtonWhenFinishScanning) && Setting_LMFoundIndicate  && object.isLMUnknown == false && object.selectedLM == -2) UI::PopStyleColor(2);
		UI::SameLine();
		if(((Setting_LMChangeButtonWhenFinishScanning && finishedScanning) || !Setting_LMChangeButtonWhenFinishScanning) && Setting_LMFoundIndicate && object.isLMUnknown == false && object.selectedLM == -1){
			UI::PushStyleColor(UI::Col::Button, Setting_LMFoundColor);
			UI::PushStyleColor(UI::Col::ButtonHovered, Setting_LMFoundColor-vec4(.1,.1,.1,0));
		}
		if (UI::Button("-1" + "###" + object.name+3)) {
			LightMap lm;
			@lm.obj = object;
			lm.objectName = object.name;
			lm.lmLvlI = CGameCtnAnchoredObject::EMapElemLightmapQuality::Low;
			lm.lmLvlB = CGameCtnBlock::EMapElemLightmapQuality::Low;
			if(object.name.ToLower().Contains(".item.gbx")){
				startnew(CoroutineFunc(lm.ApplyItem));
			}else if(object.name.ToLower().Contains(".block.gbx")){
				startnew(CoroutineFunc(lm.ApplyBlock));
			}else{
				startnew(CoroutineFunc(lm.ApplyOther));
			}
		}
		if(((Setting_LMChangeButtonWhenFinishScanning && finishedScanning) || !Setting_LMChangeButtonWhenFinishScanning) && Setting_LMFoundIndicate  && object.isLMUnknown == false && object.selectedLM == -1) UI::PopStyleColor(2);
		UI::SameLine();
		if(((Setting_LMChangeButtonWhenFinishScanning && finishedScanning) || !Setting_LMChangeButtonWhenFinishScanning) && Setting_LMFoundIndicate && object.isLMUnknown == false && object.selectedLM == 0){
			UI::PushStyleColor(UI::Col::Button, Setting_LMFoundColor);
			UI::PushStyleColor(UI::Col::ButtonHovered, Setting_LMFoundColor-vec4(.1,.1,.1,0));
		}
		if (UI::Button("0" + "###" + object.name+4)) {
			LightMap lm;
			@lm.obj = object;
			lm.objectName = object.name;
			lm.lmLvlI = CGameCtnAnchoredObject::EMapElemLightmapQuality::Normal;
			lm.lmLvlB = CGameCtnBlock::EMapElemLightmapQuality::Normal;
			if(object.name.ToLower().Contains(".item.gbx")){
				startnew(CoroutineFunc(lm.ApplyItem));
			}else if(object.name.ToLower().Contains(".block.gbx")){
				startnew(CoroutineFunc(lm.ApplyBlock));
			}else{
				startnew(CoroutineFunc(lm.ApplyOther));
			}
		}
		if(((Setting_LMChangeButtonWhenFinishScanning && finishedScanning) || !Setting_LMChangeButtonWhenFinishScanning) && Setting_LMFoundIndicate  && object.isLMUnknown == false && object.selectedLM == 0) UI::PopStyleColor(2);
		UI::SameLine();
		if(((Setting_LMChangeButtonWhenFinishScanning && finishedScanning) || !Setting_LMChangeButtonWhenFinishScanning) && Setting_LMFoundIndicate && object.isLMUnknown == false && object.selectedLM == +1){
			UI::PushStyleColor(UI::Col::Button, Setting_LMFoundColor);
			UI::PushStyleColor(UI::Col::ButtonHovered, Setting_LMFoundColor-vec4(.1,.1,.1,0));
		}
		if (UI::Button("+1" + "###" + object.name+5)) {
			LightMap lm;
			@lm.obj = object;
			lm.objectName = object.name;
			lm.lmLvlI = CGameCtnAnchoredObject::EMapElemLightmapQuality::High;
			lm.lmLvlB = CGameCtnBlock::EMapElemLightmapQuality::High;
			if(object.name.ToLower().Contains(".item.gbx")){
				startnew(CoroutineFunc(lm.ApplyItem));
			}else if(object.name.ToLower().Contains(".block.gbx")){
				startnew(CoroutineFunc(lm.ApplyBlock));
			}else{
				startnew(CoroutineFunc(lm.ApplyOther));
			}
		}
		if(((Setting_LMChangeButtonWhenFinishScanning && finishedScanning) || !Setting_LMChangeButtonWhenFinishScanning) && Setting_LMFoundIndicate  && object.isLMUnknown == false && object.selectedLM == +1) UI::PopStyleColor(2);
		UI::SameLine();
		if(((Setting_LMChangeButtonWhenFinishScanning && finishedScanning) || !Setting_LMChangeButtonWhenFinishScanning) && Setting_LMFoundIndicate && object.isLMUnknown == false && object.selectedLM == +2){
			UI::PushStyleColor(UI::Col::Button, Setting_LMFoundColor);
			UI::PushStyleColor(UI::Col::ButtonHovered, Setting_LMFoundColor-vec4(.1,.1,.1,0));
		}
		if (UI::Button("+2" + "###" + object.name+6)) {
			LightMap lm;
			@lm.obj = object;
			lm.objectName = object.name;
			lm.lmLvlI = CGameCtnAnchoredObject::EMapElemLightmapQuality::VeryHigh;
			lm.lmLvlB = CGameCtnBlock::EMapElemLightmapQuality::VeryHigh;
			if(object.name.ToLower().Contains(".item.gbx")){
				startnew(CoroutineFunc(lm.ApplyItem));
			}else if(object.name.ToLower().Contains(".block.gbx")){
				startnew(CoroutineFunc(lm.ApplyBlock));
			}else{
				startnew(CoroutineFunc(lm.ApplyOther));
			}
		}
		if(((Setting_LMChangeButtonWhenFinishScanning && finishedScanning) || !Setting_LMChangeButtonWhenFinishScanning) && Setting_LMFoundIndicate  && object.isLMUnknown == false && object.selectedLM == +2) UI::PopStyleColor(2);
		UI::SameLine();
		if(((Setting_LMChangeButtonWhenFinishScanning && finishedScanning) || !Setting_LMChangeButtonWhenFinishScanning) && Setting_LMFoundIndicate && object.isLMUnknown == false && object.selectedLM == +3){
			UI::PushStyleColor(UI::Col::Button, Setting_LMFoundColor);
			UI::PushStyleColor(UI::Col::ButtonHovered, Setting_LMFoundColor-vec4(.1,.1,.1,0));
		}
		if (UI::Button("+3" + "###" + object.name+7)) {
			LightMap lm;
			@lm.obj = object;
			lm.objectName = object.name;
			lm.lmLvlI = CGameCtnAnchoredObject::EMapElemLightmapQuality::Highest;
			lm.lmLvlB = CGameCtnBlock::EMapElemLightmapQuality::Highest;
			if(object.name.ToLower().Contains(".item.gbx")){
				startnew(CoroutineFunc(lm.ApplyItem));
			}else if(object.name.ToLower().Contains(".block.gbx")){
				startnew(CoroutineFunc(lm.ApplyBlock));
			}else{
				startnew(CoroutineFunc(lm.ApplyOther));
			}
		}
		if(((Setting_LMChangeButtonWhenFinishScanning && finishedScanning) || !Setting_LMChangeButtonWhenFinishScanning) && Setting_LMFoundIndicate  && object.isLMUnknown == false && object.selectedLM == +3) UI::PopStyleColor(2);

		UI::SameLine(); if (UI::IsItemHovered() && object.type == "Block" && cast<CGameEditorPluginMapMapType>(cast<CGameCtnEditorFree>(GetApp().Editor).PluginMapType) is null) infotext = "Editor plugins are disabled, the coordinates of the blocks are estimated and can be imprecise";
		UI::SameLine();
		switch(object.trigger){
			case CGameCtnBlockInfo::EWayPointType::Start:
				UI::Text("\\$9f9" + object.name);
				if (UI::IsItemHovered()) infotext = "It's a start block/item";
				break;
			case CGameCtnBlockInfo::EWayPointType::Finish:
				UI::Text("\\$f66" + object.name);
				if (UI::IsItemHovered()) infotext = "It's a finish block/item";
				break;
			case CGameCtnBlockInfo::EWayPointType::Checkpoint:
				UI::Text("\\$99f" + object.name);
				if (UI::IsItemHovered()) infotext = "It's a checkpoint block/item";
				break;
			case CGameCtnBlockInfo::EWayPointType::StartFinish:
				UI::Text("\\$ff6" + object.name);
				if (UI::IsItemHovered()) infotext = "It's a multilap block/item";
				break;
			default:
				UI::Text(object.name);
				break;
		}

		if(Setting_TableType) UI::TableNextColumn();
		if(Setting_TableType) UI::Text(object.type);
		if(Setting_TableSource) UI::TableNextColumn();
		if(Setting_TableSource) UI::Text(object.source);
		if(Setting_TableSize) UI::TableNextColumn();
		if(Setting_TableSize) {
			if (object.size == 0 && object.source != "In-Game" && object.source != "In TP") {
				UI::Text("\\$555" + Text::Format("%lld",object.size));
				if (UI::IsItemHovered()) infotext = "Impossible to get the size of this block/item";
			} else {
				if (object.icon) {
					UI::Text("\\$fc0" + Text::Format("%lld",object.size));
					if (UI::IsItemHovered()) infotext = "All items with size in orange contains the icon. You must re-open the map to have the real size.";
				} else {
					UI::Text(Text::Format("%lld",object.size));
				}
			}
		}

		if(Setting_TableCount) UI::TableNextColumn();
		if(Setting_TableCount) UI::Text(Text::Format("%lld",object.count));
	}

	void LoadingIndicator() {
		if(isScanning){
			if (Time::get_Now() % 400 > 300) {
				loadingText = " | " + spinner[0];
			} else if (Time::get_Now() % 400 > 200) {
				loadingText = " | " + spinner[1];
			} else if (Time::get_Now() % 400 > 100) {
				loadingText = " | " + spinner[2];
			} else {
				loadingText = " | " + spinner[3];
			}
		}else{
			loadingText = "";
		}
	}
}
