extends Node

@onready var fltr: Tree = %FileTree


func _on_dir_selected_dir_selected(dir: String) -> void:
	fltr.clear()
	fltr.create_item()
	
	draw_dirs(dir, null)
	draw_files(dir, null)

func draw_dirs(dir_path: String, parent_itm: TreeItem) -> void:
	var da := DirAccess.open(dir_path)
	
	if da.get_directories().size() == 0: return
	
	for dire in da.get_directories().size():
		var itm_dir := fltr.create_item(parent_itm)
		var dir_name := da.get_directories()[dire]
		
		itm_dir.set_text(0, dir_name)
		itm_dir.collapsed = true
		
		var new_path := dir_path + "\\" + dir_name
		
		if DirAccess.get_directories_at(new_path).size() > 0 or DirAccess.get_files_at(new_path).size() > 0:
			G.dir_cache[dir_name] = new_path

func draw_files(dir_path: String, parent_itm: TreeItem) -> void:
	var da := DirAccess.open(dir_path)
	
	if da.get_files().size() == 0: return
	
	for file in da.get_files().size():
		var itm_fil := fltr.create_item(parent_itm)
		var file_name := da.get_files()[file]
		itm_fil.set_text(0, file_name)
		
		G.file_cache[file_name] = dir_path + "\\" + file_name

func _on_file_tree_item_activated() -> void:
	var selected_itm := fltr.get_selected()
	var dir_name := selected_itm.get_text(0)
	
	if selected_itm.get_child_count() > 0:
		selected_itm.collapsed = !selected_itm.collapsed
	
	if G.dir_cache.has(dir_name):
		draw_dirs(G.dir_cache.get(dir_name), selected_itm)
		draw_files(G.dir_cache.get(dir_name), selected_itm)
		G.dir_cache.erase(dir_name)
		
		selected_itm.collapsed = !selected_itm.collapsed
