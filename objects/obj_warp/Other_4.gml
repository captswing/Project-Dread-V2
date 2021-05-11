/// @description Check if Door is Already Unlocked

// If the flag is set, the list will be cleared to mimic an "open" door
if (get_event_flag(eventFlagIndex)) {ds_list_clear(requiredKeys);}