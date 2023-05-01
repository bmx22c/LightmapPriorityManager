// TODO
// DONE: Note that Grass blocks don't keep LM after editor map reload
// DONE: Apply button color right after setting LM
// DONE: Make scan start more clear
// DONE: Only apply the button colors when scan is finished
// DONE: Change button hover color

class Objects { //Items or Blocks
	string name;
	int trigger; // CGameItemModel::EnumWaypointType or CGameCtnBlockInfo::EWayPointType
	string type;
	string source;
	int size;
	int count;
	bool icon;
	array<vec3> positions;
	bool isLMUnknown = true;
	int selectedLM = 0;
	bool firstScan = true;


	Objects(const string &in name, int trigger, bool icon, const string &in type, const string &in source, int size, vec3 pos ) {
		this.name = name;
		this.trigger = trigger;
		this.count = 1;
		this.type = type;
		this.icon = icon;
		this.source = source;
		this.size = size;
		this.positions = {pos};
	}
}

class SearchParams {
  Objects@[] sortableobjects;
  CGameCtnAnchoredObject::EMapElemLightmapQuality lmLvlI;
  CGameCtnBlock::EMapElemLightmapQuality lmLvlB;

	void ApplySearch() {
		Notification notif;
		notif.text = Icons::ClockO + " Started processing...";
		notif.duration = 5000;
		if(Setting_NotifSearchProcess) notif.Add();
		for(int i = 0; i < this.sortableobjects.Length; i++){
			if(this.sortableobjects[i].name.ToLower().Contains(".item.gbx")){
				LightMap lm;
				@lm.obj = this.sortableobjects[i];
				lm.objectName = this.sortableobjects[i].name;
				lm.lmLvlI = this.lmLvlI;
				lm.lmLvlB = this.lmLvlB;
				startnew(CoroutineFunc(lm.ApplyItem));
				yield();
			}else if(this.sortableobjects[i].name.ToLower().Contains(".block.gbx")){
				LightMap lm;
				@lm.obj = this.sortableobjects[i];
				lm.objectName = this.sortableobjects[i].name;
				lm.lmLvlI = this.lmLvlI;
				lm.lmLvlB = this.lmLvlB;
				startnew(CoroutineFunc(lm.ApplyBlock));
				yield();
			}else{
				LightMap lm;
				@lm.obj = this.sortableobjects[i];
				lm.objectName = this.sortableobjects[i].name;
				lm.lmLvlI = this.lmLvlI;
				lm.lmLvlB = this.lmLvlB;
				startnew(CoroutineFunc(lm.ApplyOther));
				yield();
			}
		}
	}
}

class Notification {
	string text;
	int duration;
	int type = 0;
	string style = "Default";

	void Add() {
		if(type == 0){
			UI::ShowNotification(this.text, this.duration);
		}else{
			if(style == "Default"){
				UI::ShowNotification("\\$FF0" + Icons::LightbulbO + "\\$z" + Meta::ExecutingPlugin().Name, this.text, this.duration);
			}else if(style == "Success") {
				UI::ShowNotification("\\$FF0" + Icons::LightbulbO + "\\$z" + Meta::ExecutingPlugin().Name, this.text, vec4(0.3,0.7,0.3,1), this.duration);
			}
		}
		yield();
	}
}

class LightMap {
	Objects@ obj;
	string objectName;
	CGameCtnAnchoredObject::EMapElemLightmapQuality lmLvlI;
	CGameCtnBlock::EMapElemLightmapQuality lmLvlB;

	void ApplyBlock() {
		auto editor = cast<CGameCtnEditorFree>(GetApp().Editor);
		auto blocks = editor.Challenge.Blocks;
		for(int i = 0; i < blocks.Length; i++){
			auto block = blocks[i];
			auto article = cast<CGameCtnArticle>(block.BlockInfo.ArticlePtr);
			if (article !is null) {
				auto biima = cast<CGameCtnArticle>(article.BlockItem_ItemModelArticle);
				if (biima !is null) {
					string reqBlock = objectName.SubStr(0, objectName.Length - 10) + objectName.ToLower().SubStr(biima.IdName.Length - 10, 10);
					string mapBlock = string(article.PageName) + string(article.Name) + biima.IdName.ToLower().SubStr(biima.IdName.Length - 10, 10);

					if(reqBlock == mapBlock){
						block.MapElemLmQuality = lmLvlB;
					}
				}
				if (i % 100 == 0) yield();
			}
		}

		obj.selectedLM = LMToIntBlock(lmLvlB);
		string[] name = objectName.Split("/");
		Notification notif;
		notif.text = Icons::Check + " " + name[name.Length-1] + " lightmap priority applied successfully";
		notif.duration = 1000;
		if(Setting_NotifLMApplied) startnew(CoroutineFunc(notif.Add));
	}

	void ApplyItem() {
		auto editor = cast<CGameCtnEditorFree>(GetApp().Editor);
		auto items = editor.Challenge.AnchoredObjects;
		for(int i = 0; i < items.Length; i++){
			auto item = items[i];
			auto article = cast<CGameCtnArticle>(item.ItemModel.ArticlePtr);
			if (article !is null) {
				string reqItem = objectName.SubStr(0, objectName.Length - 9) + objectName.ToLower().SubStr(item.ItemModel.IdName.Length - 9, 9);
				string mapItem = string(article.PageName) + string(article.Name) + item.ItemModel.IdName.ToLower().SubStr(item.ItemModel.IdName.Length - 9, 9);

				if(reqItem == mapItem){
					item.MapElemLmQuality = lmLvlI;
				}
			}
			if (i % 100 == 0) yield();
		}

		obj.selectedLM = LMToIntItem(lmLvlI);
		string[] name = objectName.Split("/");
		Notification notif;
		notif.text = Icons::Check + " " + name[name.Length-1] + " lightmap priority applied successfully";
		notif.duration = 1000;
		if(Setting_NotifLMApplied) startnew(CoroutineFunc(notif.Add));
	}

	void ApplyOther() {
		auto editor = cast<CGameCtnEditorFree>(GetApp().Editor);

		if(obj.type == "Block"){
			auto blocks = editor.Challenge.Blocks;
			for(int i = 0; i < blocks.Length; i++){
				auto block = blocks[i];
				auto article = cast<CGameCtnArticle>(block.BlockInfo.ArticlePtr);
				if (article !is null) {
						string reqBlock = objectName;
						string mapBlock = article.Name;

						if(reqBlock == mapBlock){
							block.MapElemLmQuality = lmLvlB;
						}
				}
				if (i % 100 == 0) yield();
			}
		}else if(obj.type == "Item"){
			auto items = editor.Challenge.AnchoredObjects;
			for(int i = 0; i < items.Length; i++){
				auto item = items[i];
				auto article = cast<CGameCtnArticle>(item.ItemModel.ArticlePtr);
				if (article !is null) {
					print("inside article");
					string reqItem = objectName;
					string mapItem = article.Name;

					if(reqItem == mapItem){
						item.MapElemLmQuality = lmLvlI;
					}
				}else{
					print("not inside article");
				}
				if (i % 100 == 0) yield();
			}
		}

		if(obj.type == "Block"){
			obj.selectedLM = LMToIntBlock(lmLvlB);
		}else if(obj.type == "Item"){
			obj.selectedLM = LMToIntItem(lmLvlI);
		}

		string[] name = objectName.Split("/");
		Notification notif;
		notif.text = Icons::Check + " " + name[name.Length-1] + " lightmap priority applied successfully";
		notif.duration = 1000;
		if(Setting_NotifLMApplied) startnew(CoroutineFunc(notif.Add));
	}
}

class ItemLMInfo {
	string elemName;
	string elemType;
	bool firstScan = true;
	CGameCtnAnchoredObject::EMapElemLightmapQuality lmLvlI = CGameCtnAnchoredObject::EMapElemLightmapQuality::Normal;
	CGameCtnBlock::EMapElemLightmapQuality lmLvlB = CGameCtnBlock::EMapElemLightmapQuality::Normal;
	bool isLMUnknown = true;
}
class State {
	Objects@[] sortableobjects;

	void Scan() {
		scanningStatus = " Scanning lightmap priorities...";
		isScanning = true;

		auto editor = cast<CGameCtnEditorFree>(GetApp().Editor);
		auto items = editor.Challenge.AnchoredObjects;
		auto blocks = editor.Challenge.Blocks;

		for(int j = 0; j < items.Length; j++){
			auto item = items[j];
			auto article = cast<CGameCtnArticle>(item.ItemModel.ArticlePtr);
			if (article !is null) {
				string mapItem = string(article.PageName) + string(article.Name) + item.ItemModel.IdName.ToLower().SubStr(item.ItemModel.IdName.Length - 9, 9);

				for(int i = 0; i < sortableobjects.Length; i++){
					string reqItem = sortableobjects[i].name.SubStr(0, sortableobjects[i].name.Length - 9) + sortableobjects[i].name.ToLower().SubStr(item.ItemModel.IdName.Length - 9, 9);

					if(reqItem == mapItem){
						if(sortableobjects[i].firstScan == true){
							sortableobjects[i].firstScan = false;
							sortableobjects[i].selectedLM = LMToIntItem(item.MapElemLmQuality);
							sortableobjects[i].isLMUnknown = false;
						}else{
							if(sortableobjects[i].selectedLM != LMToIntItem(item.MapElemLmQuality)){
								sortableobjects[i].isLMUnknown = true;
							}
						}
					}
				}

			}
			if (j % 100 == 0) yield();
		}

		for(int j = 0; j < blocks.Length; j++){
			auto block = blocks[j];
			auto article = cast<CGameCtnArticle>(block.BlockInfo.ArticlePtr);
			if (article !is null) {
				auto biima = cast<CGameCtnArticle>(article.BlockItem_ItemModelArticle);
				if (biima !is null) {
					string mapBlock = string(article.PageName) + string(article.Name) + biima.IdName.ToLower().SubStr(biima.IdName.Length - 10, 10);

					for(int i = 0; i < sortableobjects.Length; i++){
						string reqBlock = sortableobjects[i].name.SubStr(0, sortableobjects[i].name.Length - 10) + sortableobjects[i].name.ToLower().SubStr(biima.IdName.Length - 10, 10);
						
						if(reqBlock == mapBlock){
							if(sortableobjects[i].firstScan == true){
								sortableobjects[i].firstScan = false;
								sortableobjects[i].selectedLM = LMToIntBlock(block.MapElemLmQuality);
								sortableobjects[i].isLMUnknown = false;
							}else{
								if(sortableobjects[i].selectedLM != LMToIntBlock(block.MapElemLmQuality)){
									sortableobjects[i].isLMUnknown = true;
								}
							}
						}
					}
				}
			}
			if (j % 100 == 0) yield();
		}

		for(int j = 0; j < blocks.Length; j++){
			auto block = blocks[j];
			auto article = cast<CGameCtnArticle>(block.BlockInfo.ArticlePtr);
			if (article !is null) {
				string mapBlock = article.Name;

				for(int i = 0; i < sortableobjects.Length; i++){
					string reqBlock = sortableobjects[i].name;

					if(reqBlock == mapBlock){
						if(sortableobjects[i].firstScan == true){
							sortableobjects[i].firstScan = false;
							sortableobjects[i].selectedLM = LMToIntBlock(block.MapElemLmQuality);
							sortableobjects[i].isLMUnknown = false;
						}else{
							if(sortableobjects[i].selectedLM != LMToIntBlock(block.MapElemLmQuality)){
								sortableobjects[i].isLMUnknown = true;
							}
						}
					}
				}
			}
			if (j % 100 == 0) yield();
		}

		for(int j = 0; j < items.Length; j++){
			auto item = items[j];
			auto article = cast<CGameCtnArticle>(item.ItemModel.ArticlePtr);
			if (article !is null) {
				string mapItem = article.Name;

				for(int i = 0; i < sortableobjects.Length; i++){
					string reqItem = sortableobjects[i].name;

					if(reqItem == mapItem){
						if(sortableobjects[i].firstScan == true){
							sortableobjects[i].firstScan = false;
							sortableobjects[i].selectedLM = LMToIntItem(item.MapElemLmQuality);
							sortableobjects[i].isLMUnknown = false;
						}else{
							if(sortableobjects[i].selectedLM != LMToIntItem(item.MapElemLmQuality)){
								sortableobjects[i].isLMUnknown = true;
							}
						}
					}
				}

			}
			if (j % 100 == 0) yield();
		}
		
		isScanning = false;
		finishedScanning = true;
		scanningStatus = " | " + Icons::Check + " Finished scanning lightmap priorities";
		sleep(3000);
		scanningStatus = "";
	}
}

int LMToIntItem(CGameCtnAnchoredObject::EMapElemLightmapQuality lmLvl){
	switch (lmLvl){
		case CGameCtnAnchoredObject::EMapElemLightmapQuality::Lowest:
			return -3;
		case CGameCtnAnchoredObject::EMapElemLightmapQuality::VeryLow:
			return -2;
		case CGameCtnAnchoredObject::EMapElemLightmapQuality::Low:
			return -1;
		case CGameCtnAnchoredObject::EMapElemLightmapQuality::Normal:
			return 0;
		case CGameCtnAnchoredObject::EMapElemLightmapQuality::High:
			return 1;
		case CGameCtnAnchoredObject::EMapElemLightmapQuality::VeryHigh:
			return 2;
		case CGameCtnAnchoredObject::EMapElemLightmapQuality::Highest:
			return 3;
		default:
			return 0;
	}
}
int LMToIntBlock(CGameCtnBlock::EMapElemLightmapQuality lmLvl){
	switch (lmLvl){
		case CGameCtnBlock::EMapElemLightmapQuality::Lowest:
			return -3;
		case CGameCtnBlock::EMapElemLightmapQuality::VeryLow:
			return -2;
		case CGameCtnBlock::EMapElemLightmapQuality::Low:
			return -1;
		case CGameCtnBlock::EMapElemLightmapQuality::Normal:
			return 0;
		case CGameCtnBlock::EMapElemLightmapQuality::High:
			return 1;
		case CGameCtnBlock::EMapElemLightmapQuality::VeryHigh:
			return 2;
		case CGameCtnBlock::EMapElemLightmapQuality::Highest:
			return 3;
		default:
			return 0;
	}
}

// Force to split the refresh functions to bypass the script execution delay on heavy maps
void RefreshBlocks() {
	auto map = GetApp().RootMap;

	if (map !is null) {
		// Blocks
		auto blocks = map.Blocks;

		// Editor plugin API for GetVec3FromCoord function
		auto pluginmaptype = cast<CGameEditorPluginMapMapType>(cast<CGameCtnEditorFree>(GetApp().Editor).PluginMapType);

		for(uint i = 0; i < blocks.Length; i++) {
			int idifexist = -1;
			string blockname;
			bool isofficial = true;
			blockname = blocks[i].BlockModel.IdName;
			if (blockname.ToLower().SubStr(blockname.Length - 22, 22) == ".block.gbx_customblock") {
				isofficial = false;
				blockname = blockname.SubStr(0, blockname.Length - 12);
			}

			if (include_default_objects || blockname.ToLower().SubStr(blockname.Length - 10, 10) == ".block.gbx") {
				if(!((exclude_grass && blockname == "Grass") || (exclude_decowallbasepillar && blockname == "DecoWallBasePillar"))){
					vec3 pos;
					if (blocks[i].CoordX != 4294967295 && blocks[i].CoordZ != 4294967295) { // Not placed in free mapping
						if (pluginmaptype !is null) { // Editor plugin is available
							pos = pluginmaptype.GetVec3FromCoord(blocks[i].Coord);
						} else {
							pos.x = blocks[i].CoordX * 32 + 16;
							pos.y = (blocks[i].CoordY - 8) * 8 + 4;
							pos.z = blocks[i].CoordZ * 32 + 16;
						}
					} else {
						pos = Dev::GetOffsetVec3(blocks[i], 0x6c);
						// center the coordinates in the middle of the block
						pos.x += 16;
						pos.y += 4;
						pos.z += 16;
					}

					int index = objectsindex.Find(blockname);
					
					if (index >= 0) {
						objects[index].count++;
						totalObjectCount++;
						objects[index].positions.InsertLast(pos);
					} else {
						totalObjectCount++;
						int trigger = blocks[i].BlockModel.EdWaypointType;
						AddNewObject(blockname, trigger, "Block", pos, 0, isofficial);
						objectsindex.InsertLast(blockname);
					}
				}
			}
			if (i % 100 == 0) yield(); // to avoid timeout
		}
	}
}

// Force to split the refresh functions to bypass the script execution delay on heavy maps
void RefreshItems() {
	auto map = GetApp().RootMap;

	if (map !is null) {
		// Items
		auto items = map.AnchoredObjects;
		for(uint i = 0; i < items.Length; i++) {
			int idifexist = -1;
			string itemname = items[i].ItemModel.IdName;
			int fallbacksize = 0;
			bool isofficial = true;

			if (itemname.ToLower().SubStr(itemname.Length - 9, 9) == ".item.gbx") {
				isofficial = false;
				auto article = cast<CGameCtnArticle>(items[i].ItemModel.ArticlePtr);
				if (article !is null) {
					itemname = string(article.PageName) + string(article.Name) + ".Item.Gbx";
				} else {
					auto fid = cast<CSystemFidFile@>(GetFidFromNod(items[i].ItemModel));
					fallbacksize = fid.ByteSize;
				}
			}

			if (include_default_objects || itemname.ToLower().SubStr(itemname.Length - 9, 9) == ".item.gbx") {
				int index = objectsindex.Find(itemname);
				if (index >= 0) {
					objects[index].count++;
					totalObjectCount++;
					objects[index].positions.InsertLast(items[i].AbsolutePositionInMap);
				} else {
					totalObjectCount++;
					int trigger = items[i].ItemModel.WaypointType;
					AddNewObject(itemname, trigger, "Item", items[i].AbsolutePositionInMap, fallbacksize, isofficial);
					objectsindex.InsertLast(itemname);
				}
			}
			// yield();
			if (i % 100 == 0) yield(); // to avoid timeout
		}
	}
}

void AddNewObject(const string &in objectname, int trigger, const string &in type, vec3 pos, int fallbacksize, bool isofficial) {
	bool icon = false;
	int size;
	string source;
	CSystemFidFile@ file;
	CGameCtnCollector@ collector;
	CSystemFidFile@ tempfile;

	if (type == "Item" && Regex::IsMatch(objectname, "^[0-9]*/.*.zip/.*", Regex::Flags::None)) {//  ItemCollections
		source = "Club";
		@file = Fids::GetFake('MemoryTemp\\FavoriteClubItems\\' + objectname);
		@collector = cast<CGameCtnCollector>(cast<CGameItemModel>(file.Nod));
		if (collector is null || (collector.Icon !is null || file.ByteSize == 0)) {
			@tempfile = Fids::GetFake('MemoryTemp\\CurrentMap_EmbeddedFiles\\ContentLoaded\\ClubItems\\' + objectname);
		}
	} else { // Blocks and Items
		source = "Local";
		@file = Fids::GetUser(type + 's\\' + objectname);
		@collector = cast<CGameCtnCollector>(cast<CGameItemModel>(file.Nod));
		if (collector is null || (collector.Icon !is null || file.ByteSize == 0)) {
			@tempfile = Fids::GetFake('MemoryTemp\\CurrentMap_EmbeddedFiles\\ContentLoaded\\' + type + 's\\' + objectname);

			if (type == "Block" && tempfile.ByteSize == 0) { // Block is in Items dir
				@tempfile = Fids::GetFake('MemoryTemp\\CurrentMap_EmbeddedFiles\\ContentLoaded\\Items\\' + objectname);
			}
		}
	}
	if (tempfile !is null) {
		if (collector !is null && collector.Icon !is null && tempfile.ByteSize == 0) {
			icon = true;
			size = file.ByteSize;
		} else  {
			size = tempfile.ByteSize;
		}
		if (isofficial) {
			source = "In-Game";
		} else if (file.ByteSize == 0 && tempfile.ByteSize == 0 && fallbacksize == 0) {
#if TMNEXT
			source = "Local";
#else
			source = "In TP";
#endif
		} else if (file.ByteSize == 0 && tempfile.ByteSize == 0 && fallbacksize > 0 ) {
			source = "Embedded";
			size = fallbacksize;
		} else if (file.ByteSize == 0 && tempfile.ByteSize > 0) {
			source = "Embedded";
		}
	} else {
		size = file.ByteSize;
	}

	objects.InsertLast(Objects(objectname, trigger, icon, type, source, size, pos));
}

bool FocusCam(const string &in objectname) {
	auto editor = cast<CGameCtnEditorFree>(GetApp().Editor);
	auto camera = editor.OrbitalCameraControl;
	auto map = GetApp().RootMap;


	if (camera !is null) {
		int index = objectsindex.Find(objectname);

		camerafocusindex++;

		if (camerafocusindex > objects[index].positions.Length - 1 ) {
			camerafocusindex = 0;
		}

		camera.m_TargetedPosition = objects[index].positions[camerafocusindex];
		// Workaround to update camera TargetedPosition
		editor.ButtonZoomInOnClick();
		editor.ButtonZoomOutOnClick();
		return true;
	}
	return false;
}