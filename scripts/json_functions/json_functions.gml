/// @description Loads in data from the supplied encrypted json file. The same key must be used for encryption and decryption DON'T FORGET THAT.
/// @param filename
/// @param key
function encrypted_json_load(_filename, _key){
	// First, decrypt the data into a temporary file, and then load from there
	var _tempFilename = _filename + "_DECRYPTED.json";
	file_fast_crypt_ultra_zlib(_filename + ".json", _tempFilename, false, _key);
	
	// Load in the decrypted data using a buffer
	var _buffer, _bufferString;
	_buffer = buffer_load(_tempFilename);
	_bufferString = buffer_read(_buffer, buffer_string);
	
	// Delete the decrypted file and buffer that loaded the data in
	file_delete(_tempFilename);
	buffer_delete(_buffer);
	
	// Return the decoded json data for use in the rest of the program
	return json_decode(_bufferString);
}