#include "midi_input.hpp"
#include <iterator>
#include <iostream>

MidiInput::MidiInput(std::vector<unsigned int> sources)
{
	if(OSStatus status = MIDIClientCreate(CFSTR("March"), 0, 0, &_midi_client))
	{   
		std::cerr << "Couldn't create MIDI client: " << status << std::endl;
		std::cerr << GetMacOSStatusErrorString(status) << std::endl;
		throw "Couldn't create MIDI client.";
	}   

	if(OSStatus status = MIDIInputPortCreate(_midi_client, CFSTR("March Input"), MidiInput::read, this, &_midi_in))
	{
		std::cerr << "Couldn't create MIDI input port: " << status << std::endl;
		std::cerr << GetMacOSStatusErrorString(status) << std::endl;
		throw "Couldn't create MIDI input port.";
	}

	for(std::vector<unsigned int>::iterator it = sources.begin(); it != sources.end(); it++)
	{
		MIDIEndpointRef src = MIDIGetSource(*it);
		std::cout << "Using source " << *it << " (" << sourceName(src) << ", " << sourceModel(src) << ", " << sourceManufacturer(src) << ")" << std::endl;
		MIDIPortConnectSource(_midi_in, src, 0);
	}
}

void MidiInput::read(const MIDIPacketList* packet_list, void* midi_input, void* src_conn_ref_con)
{
	MIDIPacket* packet = const_cast<MIDIPacket*>(packet_list->packet);
	for(unsigned int i = 0; i < packet_list->numPackets; i++)
	{
		static_cast<MidiInput*>(midi_input)->receivePacket(packet);
		packet = MIDIPacketNext(packet);
	}
}

void MidiInput::receivePacket(const MIDIPacket* packet)
{
	std::vector<unsigned char> data;
	for(unsigned int i = 0; i < packet->length; i++)
		data.push_back(static_cast<unsigned char>(packet->data[i]));
	std::copy(data.begin(), data.end(), std::ostream_iterator<int>(std::cout, " "));
	std::cout << std::endl;
}

const MidiInput::SourceInfo MidiInput::getSourceInfo(unsigned int source)
{
	SourceInfo source_info;
	MIDIEndpointRef src = MIDIGetSource(source);
	source_info.name = sourceName(src);
	source_info.model = sourceModel(src);
	source_info.manufacturer = sourceManufacturer(src);
	return source_info;
}

std::string MidiInput::sourceName(MIDIEndpointRef source)
{
	return getPropertyAsString(source, kMIDIPropertyName);
}

std::string MidiInput::sourceModel(MIDIEndpointRef source)
{
	return getPropertyAsString(source, kMIDIPropertyModel);
}

std::string MidiInput::sourceManufacturer(MIDIEndpointRef source)
{
	return getPropertyAsString(source, kMIDIPropertyManufacturer);
}
