extends Node

@onready var fltr: Tree = %FileTree

var opennder_files := []

var tabs_files := {}

func _on_file_tree_item_activated() -> void:
	var selected_file := fltr.get_selected()
	var file_name := selected_file.get_text(0)
	
	if G.file_cache.has(file_name) and !opennder_files.has(file_name):
		create_tab(file_name)
		load_text(file_name)

func create_tab(tab_name: String) -> void:
	var tab_bar := TabBar.new()
	tab_bar.name = tab_name
	%FilesTabContainer.add_child(tab_bar)
	opennder_files.push_back(tab_name)
	tabs_files[tab_name] = G.file_cache[tab_name]
	
	%FilesTabContainer.current_tab = %FilesTabContainer.get_child_count() - 1

func load_text(file_name: String) -> void:
	var fs := FileAccess.open(G.file_cache[file_name], FileAccess.READ)
	
	%CodeEdit.text = fs.get_as_text()


func _on_files_tab_container_tab_changed(tab: int) -> void:
	var selected_tab := %FilesTabContainer.get_child(tab)
	if tabs_files.has(selected_tab.name.replace("_", ".")):
		%CodeEdit.text = FileAccess.open(tabs_files[selected_tab.name.replace("_", ".")], FileAccess.READ).get_as_text()
