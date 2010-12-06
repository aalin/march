#include <iostream>
#include <iterator>
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

	std::cout << "Choose sources, end with EOF:" << std::endl;
	std::istream_iterator<unsigned int> it(std::cin);
	std::istream_iterator<unsigned int> end;
	std::vector<unsigned int> sources(it, end);

	try
	{
		MidiInput midi_input(sources);
		CFRunLoopRun();
	}
	catch(const char* str)
	{
		std::cerr << str << std::endl;
		return 1;
	}
}
