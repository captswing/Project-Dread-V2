eventFlagIndex = 0;

var _player = global.singletonID[? PLAYER];
ds_queue_enqueue(sceneData,
	[cutscene_wait, 2],
	[cutscene_move_camera_position, 280, 250, 0.5, false],
	[cutscene_move_entity, 250, 250, _player],
	[cutscene_wait, 0.5],
	[cutscene_init_textbox],
	[create_textbox_actor_portrait, "This is a test of the cutscene system!", Actor.Claire, 6],
	[create_textbox_actor_portrait, "Hopefully this all works as it should work!", Actor.Claire, 1],
	[cutscene_end_textbox],
	[cutscene_wait, 1.5],
	[cutscene_move_camera_object, _player, 0.5, true],
	[cutscene_move_entity, 120, 100, _player],
	[cutscene_wait, 0.5],
	[cutscene_init_textbox],
	[create_textbox, "There's a lot of blood on that table..."],
	[cutscene_end_textbox],
	[cutscene_wait, 2]
);