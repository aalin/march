#include <iostream>
#include "midi_input.hpp"

int main()
{
	for(unsigned int i = 0; i < MidiInput::numberOfSources(); i++)
	{
		const MidiInput::SourceInfo source_info = MidiInput::getSourceInfo(i);
		std::cout << "MIDI source " << i << ":" << "\n"
		          << "\tName: "         << source_info.name << "\n"
		          << "\tModel: "        << source_info.model << "\n"
		          << "\tManufacturer: " << source_info.manufacturer << std::endl;
	}

	std::cout << "Choose source: " << std::endl;

	unsigned int source;
	std::cin >> source;

	std::cout << "Using source " << source << std::endl;

	try
	{
		MidiInput midi_input(source);
		CFRunLoopRun();
	}
	catch(const char* str)
	{
		std::cerr << str << std::endl;
		return 1;
	}
}
