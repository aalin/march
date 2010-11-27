#ifndef MIDI_INPUT_HPP
#define MIDI_INPUT_HPP

#include <CoreMIDI/MIDIServices.h>
#include <string>
#include <vector>

class MidiInput
{
	public:
		struct SourceInfo
		{
			std::string name;
			std::string model;
			std::string manufacturer;
		};

		MidiInput(unsigned int);

		static unsigned int numberOfSources() { return MIDIGetNumberOfSources(); }
		static const SourceInfo getSourceInfo(unsigned int source);

		void printAndClearQueue();

	private:
		static void read(const MIDIPacketList* packet_list, void* midi_input, void* src_conn_ref_con);

		static std::string sourceName(unsigned int source);
		static std::string sourceModel(unsigned int source);
		static std::string sourceManufacturer(unsigned int source);

		void receivePacket(const MIDIPacket* packet);

		MIDIClientRef _midi_client;
		MIDIPortRef _midi_in;

		static std::string getPropertyAsString(MIDIObjectRef obj, CFStringRef property_id)
		{
			CFStringRef cf_str;
			MIDIObjectGetStringProperty(obj, property_id, &cf_str);
			std::string str(CFStringGetCStringPtr(cf_str, 0));
			CFRelease(cf_str);
			return str;
		}
};

#endif
